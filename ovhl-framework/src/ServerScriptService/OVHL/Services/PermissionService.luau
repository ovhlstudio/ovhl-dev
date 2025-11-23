--!strict
-- @Service: PermissionService (REFACTORED: V3 COMPLIANT)
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local Cfg = require(SSS.OVHL.Config.PermissionConfig)

local Hub = {}

function Hub:Init(ctx)
    -- [1] Init bersih: Hanya setup dependencies & register routes
    self.Logger = ctx:CreateLogger("PERMISSION")
    self.DB = ctx.Adapters.DB
    self.HD = ctx.Adapters.HD
    self.Network = ctx.Network
    self._cache = {} 
    self.RANKS = { GUEST = 0, VIP = 1, MOD = 2, ADMIN = 3, HEAD = 4, OWNER = 5 }

    self.Network:Register("Permission", {
        Requests = {
            SetRank = {
                RateLimit = { Max = 10, Interval = 60 },
                Args = { { name = "targetUserId", type = "number" }, { name = "rankId", type = "number" } }
            },
            GetPlayers = { 
                RateLimit = { Max = 5, Interval = 1 }, 
                Args = {} 
            },
        },
        Events = { "RankChanged" },
    })

    self.Network:Bind("Permission", self)
    self.Logger:Info("System", "🛡️ Permission System Initialized")
end

function Hub:Start()
    -- [2] Pindahkan Logic Berat ke Start (Async)
    Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
    
    -- Scan players existing
    for _, p in ipairs(Players:GetPlayers()) do self:OnJoin(p) end

    -- Handle HD Admin Integration Async
    if Cfg.Provider == "HDAdmin" then
        task.spawn(function()
            -- Retry logic moved to dedicated routine outside Init blocker
            local ready = self.HD.WaitForAPI(10) -- Max 10s wait but inside spawn
            if ready then
                self.Logger:Info("Link", "HD Admin Integration Ready")
                -- Re-resolve all players
                for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
            else
                self.Logger:Warn("Link", "HD Admin not found within timeout. Defaulting to InternalDB.")
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

    -- HD Admin Check (Safe Call)
    if Cfg.Provider == "HDAdmin" and self.HD then
        local success, rank = pcall(function() return self.HD.GetRank(p) end)
        if success and type(rank) == "number" then rawHD = rank end
    end

    local isOwner = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
    local r, s = 0, "GUEST"

    if rawDB > r then r = rawDB; s = "INTERNAL_DB" end
    if rawHD > r then r = rawHD; s = "HD_ADMIN" end
    if isOwner then r = 5; s = "OWNER" end

    local oldRank = p:GetAttribute("OVHL_Rank")
    if oldRank ~= r then
        p:SetAttribute("OVHL_Rank", r)
        p:SetAttribute("OVHL_Role", s)
        self.Network:FireAll("Permission", "RankChanged", p.UserId, r)
        
        -- Logging Identity (Structured)
        self.Logger:Debug("IdentityResolve", { User=p.Name, Rank=r, Source=s })
    end
end

function Hub:SetRank(adminPlayer, targetUserId, newRank)
    -- Security Check
    local myRank = adminPlayer:GetAttribute("OVHL_Rank") or 0
    if myRank < self.RANKS.HEAD then
        self.Logger:Warn("Security", { Attempt="SetRank", Actor=adminPlayer.Name })
        -- [3] Error Masking: Jangan bocorkan logic internal
        return { Success = false, Error = "E-403: Access Denied" }
    end

    if newRank < 0 or newRank > self.RANKS.OWNER then
        return { Success = false, Error = "E-400: Invalid Argument" }
    end

    local success = self.DB.Set(targetUserId, newRank)
    if success then
        self.Logger:Info("AdminAction", { Action="SetRank", Actor=adminPlayer.Name, Target=targetUserId, Val=newRank })
        
        -- Refresh target if online
        local target = Players:GetPlayerByUserId(targetUserId)
        if target then self:Resolve(target) end
        
        return { Success = true, Data = "Rank Updated" }
    else
        -- [3] Error Masking
        self.Logger:Error("DBWrite", "Failed to set rank for "..targetUserId)
        return { Success = false, Error = "E-500: System Error" }
    end
end

function Hub:GetPlayers(player)
    local myRank = player:GetAttribute("OVHL_Rank") or 0
    if myRank < self.RANKS.ADMIN then return { Success = false, Data = {} } end

    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(list, { UserId = p.UserId, Name = p.Name, Rank = p:GetAttribute("OVHL_Rank") or 0, Role = p:GetAttribute("OVHL_Role") })
    end
    return { Success = true, Data = list }
end

return Hub
