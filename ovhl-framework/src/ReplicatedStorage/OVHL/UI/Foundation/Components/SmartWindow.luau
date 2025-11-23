--!strict
-- @Component: SmartWindow v5.2 (Solid Input Block)
return function(API)
    local Theme = API.Theme
    local Assets = API.Assets
    local MotionPresets = API.MotionPresets
    local function New(scope, class) return API.New(scope, class) end

    return function(scope, props)
        local isVisible = props.Visible
        if isVisible == nil then isVisible = scope:Value(true) end
        
        local styleName = props.Transition or "PopUp"
        local presetFunc = MotionPresets[styleName] or MotionPresets.PopUp
        local animProps = presetFunc(scope, isVisible)
        
        local isRendering = API.Computed(scope, function(use)
            local t = use(animProps.Transparency)
            return t < 0.99
        end)
        
        return New(scope, "Frame") {
            Name = "WindowFrame",
            AnchorPoint = animProps.AnchorPoint,
            Position = animProps.Position,
            Size = props.Size or UDim2.fromOffset(500, 400),
            BackgroundTransparency = 1, -- Root tetep transparan biar gak kotak kaku
            Visible = isRendering,
            
            [API.Children] = {
                New(scope, "UIScale") { Scale = animProps.Scale },
                
                New(scope, "CanvasGroup") {
                    Name = "Canvas",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Theme.Colors.Base.Main,
                    GroupTransparency = animProps.Transparency,
                    
                    -- [FIX CRITICAL] AKTIFKAN INPUT SINK
                    -- Ini membuat Window jadi benda padat bagi Mouse.
                    -- Klik tidak akan tembus ke UI di belakangnya.
                    Active = true, 
                    
                    [API.Children] = {
                        New(scope, "UICorner") { CornerRadius = UDim.new(0, 12) },
                        New(scope, "UIStroke") { Color = Theme.Colors.Neutral.Main, Thickness = 1 },
                        
                        -- [[ HEADER ]]
                        New(scope, "Frame") {
                            Name = "Header",
                            Size = UDim2.new(1, 0, 0, 48),
                            BackgroundTransparency = 1,
                            
                            [API.Children] = {
                                New(scope, "UIPadding") { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) },
                                
                                New(scope, "UIListLayout") {
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                },

                                -- TITLE CONTAINER
                                New(scope, "Frame") {
                                    Name = "TitleContainer",
                                    Size = UDim2.new(1, -30, 1, 0),
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 1,
                                    [API.Children] = {
                                        New(scope, "UIListLayout") { VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Left },
                                        scope:SmartText {
                                            Variant = "Header",
                                            Text = props.Title or "Window",
                                            Size = 20,
                                            Align = Enum.TextXAlignment.Left
                                        }
                                    }
                                },
                                
                                -- CLOSE BUTTON
                                New(scope, "ImageButton") {
                                    LayoutOrder = 2,
                                    Size = UDim2.fromOffset(24, 24),
                                    BackgroundTransparency = 1,
                                    Image = Assets.Icons.Close,
                                    ImageColor3 = Theme.Colors.BaseContent.Main,
                                    [API.OnEvent "Activated"] = props.OnClose
                                }
                            }
                        },
                        
                        -- [[ BODY ]]
                        New(scope, "Frame") {
                            Name = "Body",
                            Position = UDim2.fromOffset(0, 48),
                            Size = UDim2.new(1, 0, 1, -48),
                            BackgroundTransparency = 1,
                            [API.Children] = props[API.Children]
                        }
                    }
                }
            }
        }
    end
end
