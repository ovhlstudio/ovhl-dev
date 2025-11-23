--!strict
-- @Controller: InventoryController
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Pkg("Fusion")
local Trove = Loader.Pkg("Trove")
local Bridge = Loader.Core.Networking.Bridge.New()
local SharedConfig = Loader.Module("Inventory").SharedConfig
local UI = Loader.UI.Foundation.API
local Topbar = Loader.UI.Foundation.Bridges.Topbar
local InventoryView = Loader.UI.Views.Inventory.InventoryView

local Ctrl = {}

function Ctrl:Init(ctx)
    self.Logger = ctx:CreateLogger("INVENTORY")
    self._trove = Trove.new()
    self.Scope = UI.NewScope()
    
    self.State = {
        Visible = self.Scope:Value(false),
        Items = self.Scope:Value({})
    }
    
    local mounted = UI.SafeLoader.Mount(self.Scope, InventoryView, {
        Config = SharedConfig,
        State = self.State,
        OnClose = function() self:Toggle(false) end,
        
        -- [HANDLER]
        OnAction = function(item, actionId, unlockUI)
            self:HandleAction(item, actionId, unlockUI)
        end
    })
    if mounted then self._trove:Add(mounted) end

    self.Icon = Topbar.Register("Inventory", SharedConfig.Topbar, function(isOpened)
        self:Toggle(isOpened)
    end)
end

function Ctrl:Start()
    self:FetchData()
end

function Ctrl:HandleAction(item, actionId, unlockUI)
    -- [SMART] Call PerformAction endpoint
    Bridge:Request("Inventory", "PerformAction", item.Id, actionId)
        :andThen(function(res)
            self.Logger:Info("ActionSuccess", res.Msg)
            -- Refresh Data agar UI update (Equipped status / Item removed)
            return self:FetchData() 
        end)
        :catch(function(err)
            self.Logger:Warn("ActionFail", err)
        end)
        :finally(function()
            unlockUI() -- Selalu buka kunci tombol
        end)
end

function Ctrl:FetchData()
    return Bridge:Request("Inventory", "GetItems")
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
