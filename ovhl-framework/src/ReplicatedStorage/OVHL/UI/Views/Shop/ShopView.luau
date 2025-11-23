--!strict
-- @View: ShopView
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.UI.Foundation.API
local Children = UI.Children

return function(scope, props)
    local Config = props.Config
    local State = props.State
    
    return scope:ScreenWrapper {
        Name = "ShopScreen",
        Enabled = true,
        Order = 15,
        
        [Children] = {
            scope:SmartWindow {
                Title = Config.UI.Title,
                Size = UDim2.fromOffset(600, 450),
                OnClose = props.OnClose,
                Visible = State.Visible,
                Transition = Config.UI.Transition or "PopUp",
                
                [Children] = {
                    scope:GridContainer {
                        CellSize = Config.Layout.Grid.CellSize,
                        Gap = Config.Layout.Grid.Gap,
                        [Children] = {
                            UI.ForValues(scope, State.Items, function(use, innerScope, item)
                                local displayItem = table.clone(item)
                                displayItem.Name = item.Name .. " ($" .. item.Price .. ")"
                                displayItem.Count = "INF"
                                return innerScope:ItemSlot {
                                    Item = displayItem, Config = Config, OnAction = props.OnAction
                                }
                            end)
                        }
                    }
                }
            }
        }
    }
end
