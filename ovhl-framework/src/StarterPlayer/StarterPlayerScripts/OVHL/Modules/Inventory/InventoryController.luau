--!strict
-- @Controller: InventoryController (V2 Standard)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework)

local UI = Loader.Get("API")
local Fusion = UI.Fusion
local Trove = Loader.Get("Trove")
local Topbar = Loader.Get("Topbar")
local InventoryView = Loader.UI.Views.Inventory.InventoryView

local Ctrl = OVHL.CreateController({
    Name = "Inventory",
    ConfigName = "Inventory" -- Auto-load Config
})

function Ctrl:Init()
    self._trove = Trove.new()
    self.Scope = UI.NewScope()
    
    self.State = {
        Visible = self.Scope:Value(false),
        Items = self.Scope:Value({})
    }
    
    local mounted = UI.SafeLoader.Mount(self.Scope, InventoryView, {
        Config = self.Config,
        State = self.State,
        OnClose = function() self:Toggle(false) end,
        OnAction = function(item, actionId, unlockUI) self:HandleAction(item, actionId, unlockUI) end
    })
    if mounted then self._trove:Add(mounted) end

    self.Icon = Topbar.Register("Inventory", self.Config.Topbar, function(isOpened)
        self:Toggle(isOpened)
    end)
end

function Ctrl:Start()
    self:FetchData()
end

-- [CRITICAL FIX] Memory Cleanup
-- Metode ini dipersiapkan untuk dipanggil oleh Framework saat Controller di-unload
-- atau saat Player Reset/Keluar (tergantung implementasi Framework Kernel kedepannya)
function Ctrl:Shutdown()
    if self._trove then
        self._trove:Destroy()
        self._trove = nil
    end
    -- Scope Fusion juga perlu dibersihkan jika Framework support hot-reload
    if self.Scope and self.Scope.doCleanup then
        self.Scope:doCleanup()
        self.Scope = nil
    end
end

function Ctrl:HandleAction(item, actionId, unlockUI)
    -- [FIX] Pake self.Guard
    self.Guard.Run({ Debounce = 0.5 }, function()
        -- [FIX] Pake self.Bridge
        self.Bridge:Request("Inventory", "PerformAction", item.Id, actionId)
            :andThen(function(res)
                self.Logger:Info("ActionSuccess", res.Msg)
                return self:FetchData() 
            end)
            :catch(function(err)
                self.Logger:Warn("ActionFail", err)
            end)
            :finally(function()
                unlockUI()
            end)
    end)
end

function Ctrl:FetchData()
    return self.Bridge:Request("Inventory", "GetItems")
        :andThen(function(items) 
            self.State.Items:set(items)
        end)
end

function Ctrl:Toggle(forceState)
    local current = Fusion.peek(self.State.Visible)
    local newState = if forceState ~= nil then forceState else not current
    self.State.Visible:set(newState)
    if self.Icon then if newState then self.Icon:select() else self.Icon:deselect() end end
    if newState then self:FetchData() end
end

return Ctrl