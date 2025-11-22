-- @View: InventoryView
-- @Standard: OVHL v0.1.1 (Strict API Usage)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- [STRICT] Only use UI API.
local UI = Loader.UI("Foundation/API")
local Children = UI.Children

-- [[ SUB-COMPONENT: ITEM SLOT ]]
local function ItemSlot(scope, props)
    local C = UI.Theme.Colors
    local Config = props.Config
    local Item = props.Item
    
    local rarityColor = Config.UI.RarityColors[Item.Rarity] or C.Neutral.Main
    local layoutMode = Config.Layout.Mode

    local size
    if layoutMode == "List" then
        size = UDim2.new(1, 0, 0, Config.Layout.List.Height)
    else
        size = UDim2.fromOffset(Config.Layout.Grid.CellSize.X, Config.Layout.Grid.CellSize.Y)
    end

    -- [FIX] Explicit UI.New call.
    -- Using Raw "Frame" means we must manually add UIPadding if we want padding.
    return UI.New(scope, "Frame") {
        Name = "Slot_" .. Item.Id,
        Size = size,
        BackgroundColor3 = UI.Theme.Colors.Base.Main,
        BackgroundTransparency = 0,
        
        [Children] = {
            UI.New(scope, "UICorner") { CornerRadius = UDim.new(0, 6) },
            UI.New(scope, "UIStroke") {
                Color = rarityColor,
                Thickness = 2,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            },
            
            UI.New(scope, "Frame") {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                
                [Children] = {
                    -- Fix Padding: Add explicit UIPadding child
                    UI.New(scope, "UIPadding") {
                        PaddingTop = UDim.new(0, 8),
                        PaddingBottom = UDim.new(0, 8),
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8),
                    },
                    
                    UI.New(scope, "TextLabel") {
                        Text = Item.Name,
                        TextColor3 = C.BaseContent.Main,
                        TextSize = 14,
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        FontFace = UI.Theme.Font.Body
                    },
                    UI.New(scope, "TextLabel") {
                        Text = "x" .. Item.Count,
                        TextColor3 = C.Neutral.Main,
                        TextSize = 12,
                        Size = UDim2.new(1, 0, 0, 20),
                        Position = UDim2.fromScale(0, 1),
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundTransparency = 1,
                        FontFace = UI.Theme.Font.Body
                    }
                }
            }
        }
    }
end

-- [[ LAYOUT STRATEGY ]]
local function RenderLayoutStrategy(scope, layoutConfig)
    if layoutConfig.Mode == "List" then
        return UI.New(scope, "UIListLayout") {
            Padding = UDim.new(0, layoutConfig.List.Gap),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }
    else
        return UI.New(scope, "UIGridLayout") {
            CellSize = UDim2.fromOffset(layoutConfig.Grid.CellSize.X, layoutConfig.Grid.CellSize.Y),
            CellPadding = UDim2.fromOffset(layoutConfig.Grid.Gap.X, layoutConfig.Grid.Gap.Y),
            SortOrder = layoutConfig.Grid.Sort,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }
    end
end

-- [[ MAIN VIEW ]]
return function(scope, props)
    local Config = props.Config
    local State = props.State
    
    -- 'scope' here is the Main Scope (Onyx Enabled).
    return scope:ScreenWrapper {
        Name = "InventoryScreen",
        Enabled = State.Visible,
        Order = 10,
        
        [Children] = {
            scope:Window {
                Title = Config.UI.Title,
                Size = UDim2.fromOffset(600, 450),
                OnClose = props.OnClose,
                
                [Children] = {
                    UI.New(scope, "ScrollingFrame") {
                        Name = "Container",
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 4,
                        
                        [Children] = {
                            RenderLayoutStrategy(scope, Config.Layout),
                            
                            UI.ForValues(scope, State.Items, function(use, innerScope, item)
                                return ItemSlot(innerScope, {
                                    Item = item,
                                    Config = Config
                                })
                            end)
                        }
                    },
                    
                    UI.Computed(scope, function(use)
                        local items = use(State.Items)
                        if #items == 0 then
                            return UI.New(scope, "TextLabel") {
                                Text = Config.UI.EmptyState,
                                Size = UDim2.fromScale(1, 1),
                                BackgroundTransparency = 1,
                                TextColor3 = UI.Theme.Colors.Neutral.Main,
                                TextSize = 16,
                                FontFace = UI.Theme.Font.Body
                            }
                        end
                        return nil
                    end)
                }
            }
        }
    }
end
