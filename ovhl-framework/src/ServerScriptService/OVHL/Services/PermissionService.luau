-- @Service: PermissionService (Lifecycle Fixed)
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local Cfg = require(SSS.OVHL.Config.PermissionConfig)

local Hub = {}

function Hub:Init(ctx)
    -- [1] PRIORITAS: Logger harus dibuat di Init
    self.Logger = ctx:CreateLogger("PERMISSION")
    
    self.DB = ctx.Adapters.DB
    self.HD = ctx.Adapters.HD
    self._cache = {}
    self.RANKS = { GUEST=0, VIP=1, MOD=2, ADMIN=3, HEAD=4, OWNER=5 }

    Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
    
    -- [2] FIX TIMING: Defer StartScan agar Init selesai
    if Cfg.Provider == "HDAdmin" then
        task.defer(function()
            self.HD.StartScan(self.Logger) -- self.Logger sekarang pasti non-nil
            -- Re-scan players setelah HD connect
            task.wait(3) 
            for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
        end)
    end
end

function Hub:Start()
    -- Logika HDAdmin dipindahkan ke Init/Defer.
end

function Hub:OnJoin(p)
    -- Delay sedikit untuk memastikan DataStore/HD siap
    task.delay(1, function() 
        if p.Parent then self:Resolve(p) end 
    end)
end

function Hub:Resolve(p)
    -- 1. Fetch Sources
    local rawDB = self.DB.Get(p.UserId) or 0
    local rawHD = 0
    
    -- [FIX] Gunakan pcall untuk GetRank agar tidak crash jika adapter nil
    if Cfg.Provider == "HDAdmin" and self.HD and self.HD.GetRank then 
        local s, r = pcall(self.HD.GetRank, self.HD, p)
        if s and type(r) == "number" then rawHD = r end
    end
    
    local isOwnerConfig = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
    
    -- 2. WINNING SOURCE LOGIC (OWNER PRIORITY)
    local r, s = 0, "GUEST"
    if rawDB > r then r=rawDB; s="INTERNAL_DB" end -- Internal DB can set rank
    if rawHD > r then r=rawHD; s="HD_ADMIN" end    -- HD Admin can set rank
    if isOwnerConfig then r=5; s="OWNER" end       -- Owner ALWAYS wins (Override)
    
    -- 3. Cache & REPLICATE
    p:SetAttribute("OVHL_Rank", r) -- Client can read this
    p:SetAttribute("OVHL_Role", s)
    
    self.Logger:Info("Identity", {
        User = p.Name,
        Rank = r,
        Source = s,
        Details = string.format("[HD:%d] [DB:%d]", rawHD, rawDB)
    })
end

function Hub:GetRank(p)
    return p:GetAttribute("OVHL_Rank") or 0
end

return Hub
