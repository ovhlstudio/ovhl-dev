--!strict
-- @Service: PermissionService (Refactored)
local Players = game:GetService("Players")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- [CLEAN IMPORT] Config via Loader Alias
local Cfg = Loader.Get("PermissionConfig") 

local Hub = {}

function Hub:Init(ctx)
    self.Logger = ctx:CreateLogger("PERMISSION")
    -- Adapters injected by ServerKernel (Clean)
    self.DB = ctx.Adapters.DB
    self.HD = ctx.Adapters.HD
    self.Network = ctx.Network
    self.RANKS = { GUEST = 0, VIP = 1, MOD = 2, ADMIN = 3, HEAD = 4, OWNER = 5 }

    self.Network:Register("Permission", {
        Requests = {
            SetRank = {
                RateLimit = { Max = 10, Interval = 60 },
                Args = { { name = "targetUserId", type = "number" }, { name = "rankId", type = "number" } }
            },
            GetPlayers = { RateLimit = { Max = 5, Interval = 1 }, Args = {} },
        },
        Events = { "RankChanged" },
    })

    self.Network:Bind("Permission", self)
end

function Hub:Start()
    Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
    for _, p in ipairs(Players:GetPlayers()) do self:OnJoin(p) end

    if Cfg.Provider == "HDAdmin" then
        task.spawn(function()
            local ready = self.HD.WaitForAPI(10)
            if ready then
                self.Logger:Info("Link", "HD Admin Integration Ready")
                for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
            else
                self.Logger:Warn("Link", "HD Admin not found. Fallback Internal.")
            end
        end)
    end
end

function Hub:OnJoin(p)
    if not p.Parent then return end
    self:Resolve(p)
end

function Hub:Resolve(p)
    local rawDB = self.DB.Get(p.UserId) or 0
    local rawHD = 0

    if Cfg.Provider == "HDAdmin" and self.HD then
        local success, rank = pcall(function() return self.HD.GetRank(p) end)
        if success and type(rank) == "number" then rawHD = rank end
    end

    local isOwner = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
    local r, s = 0, "GUEST"

    if rawDB > r then r = rawDB; s = "INTERNAL_DB" end
    if rawHD > r then r = rawHD; s = "HD_ADMIN" end
    if isOwner then r = 5; s = "OWNER" end

    if p:GetAttribute("OVHL_Rank") ~= r then
        p:SetAttribute("OVHL_Rank", r)
        p:SetAttribute("OVHL_Role", s)
        self.Network:FireAll("Permission", "RankChanged", p.UserId, r)
    end
end

function Hub:SetRank(adminPlayer, targetUserId, newRank)
    local myRank = adminPlayer:GetAttribute("OVHL_Rank") or 0
    if myRank < self.RANKS.HEAD then return { Success = false, Error = "Access Denied" } end

    local success = self.DB.Set(targetUserId, newRank)
    if success then
        local target = Players:GetPlayerByUserId(targetUserId)
        if target then self:Resolve(target) end
        return { Success = true, Data = "Rank Updated" }
    end
    return { Success = false, Error = "System Error" }
end

function Hub:GetPlayers(player)
    local myRank = player:GetAttribute("OVHL_Rank") or 0
    if myRank < self.RANKS.ADMIN then return { Success = false, Data = {} } end

    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(list, { UserId = p.UserId, Name = p.Name, Rank = p:GetAttribute("OVHL_Rank") or 0 })
    end
    return { Success = true, Data = list }
end

return Hub
