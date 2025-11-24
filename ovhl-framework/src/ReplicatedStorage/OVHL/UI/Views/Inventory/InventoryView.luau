--!strict
-- @View: InventoryView (Wired Correctly)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.Get("API")
local Children = UI.Children

return function(scope, props)
    local Config = props.Config
    local State = props.State
    
    return scope:ScreenWrapper {
        Name = "InventoryScreen",
        Enabled = true,
        Order = 10,
        
        [Children] = {
            scope:SmartWindow {
                Title = Config.UI.Title,
                Size = UDim2.fromOffset(650, 500),
                OnClose = props.OnClose,
                Visible = State.Visible,
                Transition = Config.UI.Transition or "PopUp",
                
                [Children] = {
                    scope:GridContainer {
                        CellSize = Config.Layout.Grid.CellSize, 
                        Gap = Config.Layout.Grid.Gap,
                        
                        [Children] = {
                            UI.ForValues(scope, State.Items, function(use, innerScope, item)
                                return innerScope:ItemSlot {
                                    Item = item,
                                    Config = Config,
                                    
                                    -- [FIXED] Jalur komunikasi disambung kembali
                                    OnAction = props.OnAction
                                }
                            end),
                            
                            UI.Computed(scope, function(use)
                                if #use(State.Items) == 0 then
                                    return scope:SmartText {
                                        Variant = "Body",
                                        Text = Config.UI.EmptyState,
                                        Size = 16,
                                        Align = Enum.TextXAlignment.Center
                                    }
                                end
                                return nil
                            end)
                        }
                    }
                }
            }
        }
    }
end
