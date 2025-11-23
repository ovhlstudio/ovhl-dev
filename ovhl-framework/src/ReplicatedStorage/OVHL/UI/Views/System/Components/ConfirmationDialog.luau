--!strict
-- @Component: Global Confirmation Dialog
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.UI.Foundation.API
local Children = UI.Children

return function(scope, props)
    local Data = props.Data -- { Title, Message, OnConfirm, OnCancel }
    
    -- Animasi Timer Bar (5 Detik berkurang)
    local TimeLeft = scope:Value(1) -- 1 = Penuh, 0 = Habis
    local Tween = UI.Fusion.Tween(scope, TimeLeft, 
        TweenInfo.new(5, Enum.EasingStyle.Linear)
    )
    
    -- Start Timer pas mount
    TimeLeft:set(0) 

    return scope:New "Frame" {
        Name = "ConfirmationOverlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.6, -- Dimmed Background
        ZIndex = 1000, -- Paling Atas
        
        [Children] = {
            -- Modal Window
            scope:New "Frame" {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(400, 220),
                BackgroundColor3 = UI.Theme.Colors.Base.Main,
                
                [Children] = {
                    scope:New "UICorner" { CornerRadius = UDim.new(0, 12) },
                    scope:New "UIStroke" { Color = UI.Theme.Colors.Error.Main, Thickness = 2 }, -- Merah biar kerasa penting
                    scope:New "UIPadding" { PaddingTop=UDim.new(0,20), PaddingBottom=UDim.new(0,20), PaddingLeft=UDim.new(0,24), PaddingRight=UDim.new(0,24) },
                    
                    scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 12)
                    },
                    
                    -- Header
                    scope:SmartText { 
                        Text = Data.Title or "CONFIRMATION", 
                        Variant = "Header", 
                        Size = 20, 
                        Color = "Error",
                        LayoutOrder = 1
                    },
                    
                    -- Message Body
                    scope:SmartText { 
                        Text = Data.Message or "Are you sure?", 
                        Variant = "Body", 
                        Size = 16, 
                        Align = Enum.TextXAlignment.Center,
                        LayoutOrder = 2,
                        Color = "BaseContent"
                    },
                    
                    -- Spacer
                    scope:New "Frame" { Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, LayoutOrder = 3 },
                    
                    -- Action Buttons
                    scope:New "Frame" {
                        Size = UDim2.new(1, 0, 0, 40),
                        BackgroundTransparency = 1,
                        LayoutOrder = 4,
                        [Children] = {
                            scope:New "UIListLayout" { 
                                FillDirection = Enum.FillDirection.Horizontal, 
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                Padding = UDim.new(0, 16)
                            },
                            
                            -- Cancel
                            scope:AsyncButton {
                                Text = "CANCEL",
                                Size = UDim2.fromOffset(120, 40),
                                Style = "Ghost",
                                OnClick = function()
                                    if props.OnClose then props.OnClose(false) end
                                end
                            },
                            
                            -- Confirm
                            scope:AsyncButton {
                                Text = "CONFIRM",
                                Size = UDim2.fromOffset(120, 40),
                                Style = "Filled",
                                Color = UI.Theme.Colors.Error.Main, -- Merah
                                OnClick = function()
                                    if props.OnClose then props.OnClose(true) end
                                end
                            }
                        }
                    },
                    
                    -- Timer Bar (Visual)
                    scope:New "Frame" {
                        Name = "TimerContainer",
                        Size = UDim2.new(1, 0, 0, 4),
                        Position = UDim2.new(0, 0, 1, -2), -- Nempel bawah
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundTransparency = 1,
                        LayoutOrder = 5, -- Paling bawah urutan
                        [Children] = {
                            scope:New "Frame" {
                                BackgroundColor3 = UI.Theme.Colors.Error.Main,
                                Size = UI.Computed(scope, function(use)
                                    return UDim2.fromScale(use(Tween), 1)
                                end)
                            }
                        }
                    }
                }
            }
        }
    }
end
