-- @Controller: InventoryController
-- @Standard: OVHL v0.1.1 (Trove Lifecycle)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Fusion = Loader.Pkg("Fusion")
local Trove = Loader.Pkg("Trove")
local Bridge = Loader.Core("Networking/Bridge").New()

local SharedConfig = Loader.Module("Inventory", "SharedConfig")
local UI = Loader.UI("Foundation/API")
local Topbar = Loader.UI("Foundation/Bridges/Topbar")
local InventoryView = Loader.UI("Views/Inventory/InventoryView")

local Ctrl = {}

function Ctrl:Init(ctx)
    self.Logger = ctx:CreateLogger("INVENTORY")
    self._trove = Trove.new()
    
    local scope = UI.NewScope()
    self.Scope = scope
    
    self.State = {
        Visible = scope:Value(false),
        Items = scope:Value({})
    }
    
    self._trove:Add(function()
        Fusion.doCleanup(scope)
    end)
    
    local mounted = UI.SafeLoader.Mount(scope, InventoryView, {
        Config = SharedConfig,
        State = self.State,
        OnClose = function() self:Toggle(false) end
    })
    
    if mounted then
        self._trove:Add(mounted)
    end

    self.Icon = Topbar.Register("Inventory", SharedConfig.Topbar, function(isOpened)
        self:Toggle(isOpened)
    end)
    
    self.Logger:Info("System", "Inventory Initialized (Trove Active)")
end

function Ctrl:Start()
    self:FetchData()
end

function Ctrl:FetchData()
    self.Logger:Debug("Fetch", "Requesting items...")
    Bridge:Request("Inventory", "GetItems")
        :andThen(function(res)
            if res.Success then
                self.State.Items:set(res.Data)
                self.Logger:Info("Data", { Count = #res.Data })
            end
        end)
        :catch(function(err)
            self.Logger:Error("FetchFail", err)
        end)
end

function Ctrl:Toggle(forceState)
    local current = Fusion.peek(self.State.Visible)
    local newState = if forceState ~= nil then forceState else not current
    self.State.Visible:set(newState)
    
    if self.Icon then
        if newState then self.Icon:select() else self.Icon:deselect() end
    end
    
    if newState then
        self:FetchData()
    end
end

return Ctrl
