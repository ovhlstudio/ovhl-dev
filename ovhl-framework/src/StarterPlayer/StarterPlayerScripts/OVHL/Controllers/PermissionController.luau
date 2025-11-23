--!strict
-- @Controller: PermissionController
-- @Responsibility: Listen to Rank updates and notify system
local Players = game:GetService("Players")
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Logger = ctx:CreateLogger("PERMISSION")
    self.Player = Players.LocalPlayer
end

function Ctrl:Start()
    -- Listen to Attribute Changes (Replication from Server)
    self.Player:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
        self:OnRankChanged()
    end)
    
    -- Initial Check
    self:OnRankChanged()
end

function Ctrl:OnRankChanged()
    local rank = self.Player:GetAttribute("OVHL_Rank") or 0
    local role = self.Player:GetAttribute("OVHL_Role") or "Guest"
    
    self.Logger:Info("Update", { 
        Rank = rank, 
        Role = role 
    })
    
    -- TODO: Trigger UI Refresh jika perlu (via Signals)
end

function Ctrl:GetRank()
    return self.Player:GetAttribute("OVHL_Rank") or 0
end

return Ctrl
