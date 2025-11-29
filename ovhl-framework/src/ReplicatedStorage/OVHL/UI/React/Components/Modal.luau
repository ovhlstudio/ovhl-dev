--!strict
-- @Component: Modal v2.0 (Animated)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local Style = Loader.Get("Style")
local useMotion = require(RS.OVHL.UI.React.Hooks.useMotion)
local UIConfig = require(RS.OVHL.Config.UISystemConfig) -- Config Driven

local e = React.createElement

export type Props = { Title: string, Size: UDim2?, OnClose: () -> (), OnAction: (() -> ())?, ActionLabel: string?, children: any }

return function(props: Props)
    -- Modal Entrance Logic: Scale 0.8 -> 1 + Fade In
    local animScale = useMotion(UDim2.fromScale(1,1), UIConfig.Motion.ModalEntrance, UDim2.fromScale(0.8, 0.8))
    local animTrans = useMotion(UDim2.new(0,0,0,0), "Smooth", UDim2.new(1,0,0,0)) -- 1 -> 0 transparency
    
    local transBinding = animTrans:map(function(v) return v.X.Scale end)
    local scaleBinding = animScale:map(function(v) return v.X.Scale end)

    return e("Frame", { 
        Name = "ModalOverlay", 
        Size = UDim2.fromScale(1, 1), 
        BackgroundColor3 = Style.Colors.Background.Overlay, 
        BackgroundTransparency = transBinding:map(function(t) return 0.5 + (t*0.5) end), -- Dimming anim
        ZIndex = UIConfig.ZIndex.Modal, 
        Active = true 
    }, {
        Container = e("CanvasGroup", { -- CanvasGroup for Scale + Fade
            Size = props.Size or UDim2.fromOffset(400, 250), 
            Position = UDim2.fromScale(0.5, 0.5), 
            AnchorPoint = Vector2.new(0.5, 0.5),
            GroupTransparency = transBinding,
            
            BackgroundColor3 = Style.Colors.Background.Surface,
            BorderSizePixel = 0
        }, {
            UIScale = e("UIScale", { Scale = scaleBinding }),
            Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Large }),
            
            -- Inner Content
            Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = Style.Metrics.Padding.Medium, HorizontalAlignment = Enum.HorizontalAlignment.Center }),
            Padding = e("UIPadding", { PaddingTop = UDim.new(0,20), PaddingBottom = UDim.new(0,20), PaddingLeft = UDim.new(0,20), PaddingRight = UDim.new(0,20) }),
            
            Header = e(Atoms.Text, { Content = props.Title, Variant = "H2", Align = Enum.TextXAlignment.Center, LayoutOrder = 1 }),
            Divider = e(Atoms.Divider, { Direction = "Horizontal", LayoutOrder = 2 }),
            
            Content = e("Frame", { Size = UDim2.new(1, 0, 1, -100), BackgroundTransparency = 1, LayoutOrder = 3 }, {
                Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = Style.Metrics.Padding.Small }), 
                Body = React.createElement(React.Fragment, nil, props.children)
            }),
            
            Actions = e("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, LayoutOrder = 4 }, {
                Layout = e("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = Style.Metrics.Padding.Medium, VerticalAlignment = Enum.VerticalAlignment.Bottom }),
                CancelBtn = e(Atoms.Button, { Text = "Cancel", Variant = "Ghost", OnClick = props.OnClose }),
                ActionBtn = props.OnAction and e(Atoms.Button, { Text = props.ActionLabel or "Confirm", Variant = "Primary", OnClick = props.OnAction })
            })
        })
    })
end
