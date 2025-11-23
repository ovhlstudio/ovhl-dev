--!strict
-- @Component: SmartWindow v5.0 (Config Driven Motion)
return function(API)
    local Theme = API.Theme
    local Assets = API.Assets
    local MotionPresets = API.MotionPresets
    local function New(scope, class) return API.New(scope, class) end

    return function(scope, props)
        local isVisible = props.Visible
        if isVisible == nil then isVisible = scope:Value(true) end
        
        -- [LOGIC] Ambil style dari props, default "PopUp"
        local styleName = props.Transition or "PopUp"
        local presetFunc = MotionPresets[styleName] or MotionPresets.PopUp
        
        -- Hitung animasi via Preset
        local animProps = presetFunc(scope, isVisible)
        
        -- Optimasi Render
        local isRendering = API.Computed(scope, function(use)
            local t = use(animProps.Transparency)
            return t < 0.99
        end)
        
        return New(scope, "Frame") {
            Name = "WindowFrame",
            AnchorPoint = animProps.AnchorPoint,
            Position = animProps.Position,
            Size = props.Size or UDim2.fromOffset(500, 400),
            BackgroundTransparency = 1,
            Visible = isRendering,
            
            [API.Children] = {
                New(scope, "UIScale") { Scale = animProps.Scale },
                
                New(scope, "CanvasGroup") {
                    Name = "Canvas",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Theme.Colors.Base.Main,
                    GroupTransparency = animProps.Transparency,
                    
                    [API.Children] = {
                        New(scope, "UICorner") { CornerRadius = UDim.new(0, 12) },
                        New(scope, "UIStroke") { Color = Theme.Colors.Neutral.Main, Thickness = 1 },
                        
                        New(scope, "Frame") {
                            Name = "Header",
                            Size = UDim2.new(1, 0, 0, 48),
                            BackgroundTransparency = 1,
                            
                            [API.Children] = {
                                New(scope, "UIPadding") { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) },
                                
                                scope:SmartText {
                                    Variant = "Header",
                                    Text = props.Title or "Window",
                                    Size = 20,
                                    LayoutOrder = 1,
                                    Align = Enum.TextXAlignment.Left
                                },
                                
                                New(scope, "ImageButton") {
                                    AnchorPoint = Vector2.new(1, 0.5),
                                    Position = UDim2.new(1, 0, 0.5, 0),
                                    Size = UDim2.fromOffset(24, 24),
                                    BackgroundTransparency = 1,
                                    Image = Assets.Icons.Close,
                                    ImageColor3 = Theme.Colors.BaseContent.Main,
                                    [API.OnEvent "Activated"] = props.OnClose
                                }
                            }
                        },
                        
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
