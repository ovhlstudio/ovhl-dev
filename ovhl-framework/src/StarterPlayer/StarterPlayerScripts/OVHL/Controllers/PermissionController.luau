--!strict
-- @Controller: PermissionController (V2 Standard)
local RS = game:GetService("ReplicatedStorage")
local OVHL = require(RS.OVHL.Core.Framework)

local Ctrl = OVHL.CreateController({
    Name = "Permission",
    -- Tidak ada Config khusus
})

function Ctrl:Init()
    self.Player = game.Players.LocalPlayer
end

function Ctrl:Start()
    self.Player:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
        self:OnRankChanged()
    end)
    self:OnRankChanged()
end

function Ctrl:OnRankChanged()
    local rank = self.Player:GetAttribute("OVHL_Rank") or 0
    local role = self.Player:GetAttribute("OVHL_Role") or "Guest"
    self.Logger:Info("Update", { Rank = rank, Role = role })
end

function Ctrl:GetRank()
    return self.Player:GetAttribute("OVHL_Rank") or 0
end

return Ctrl
