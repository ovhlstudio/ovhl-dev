--!strict
-- @Component: Window v4.1 (Full Animation)
-- @Update: Added AnchorPoint Animation to fix layout glitches
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local useMotion = require(RS.OVHL.UI.React.Hooks.useMotion)

local e = React.createElement

export type Props = { 
    Title: string, Size: UDim2?, OnClose: (() -> ())?, Visible: boolean?, 
    _OverridePos: UDim2?, _OverrideAnchor: Vector2?, children: any? 
}

-- Helper untuk Map Vector2 ke Binding (karena useMotion kita return UDim2 binding)
local function useVectorMotion(target: Vector2, preset: string)
    -- Hack: Bungkus Vector2 ke dalam UDim2 (X=ScaleX, Y=ScaleY) agar bisa dimakan useMotion
    local proxyTarget = UDim2.fromScale(target.X, target.Y)
    local binding = useMotion(proxyTarget, preset)
    
    -- Unpack kembali ke Vector2 untuk property AnchorPoint
    return binding:map(function(val)
        return Vector2.new(val.X.Scale, val.Y.Scale)
    end)
end

return function(props: Props)
    local isVisible = (props.Visible == nil) and true or props.Visible
    local finalSize = props.Size or UDim2.fromOffset(400, 300)
    local targetPos = props._OverridePos or UDim2.fromScale(0.5, 0.5)
    local targetAnchor = props._OverrideAnchor or Vector2.new(0.5, 0.5)
    
    local goalSize = isVisible and finalSize or UDim2.fromScale(0, 0)
    local goalTrans = isVisible and 0 or 1
    
    -- PHYSICS ENGINE
    local animSize = useMotion(goalSize, "Bouncy", UDim2.fromScale(0, 0))
    local animPos = useMotion(targetPos, "Stiff") 
    
    -- [NEW] ANIMATED ANCHOR POINT
    -- Ini kunci agar perpindahan 9-slice tidak patah/reset ke 0
    local animAnchor = useVectorMotion(targetAnchor, "Stiff") 
    
    local transProxy = useMotion(UDim2.new(goalTrans, 0, 0, 0), "Snappy")
    local transBinding = transProxy:map(function(val) return val.X.Scale end)
    local visibleBinding = transProxy:map(function(val) return val.X.Scale < 0.99 end)

    return e("CanvasGroup", {
        Size = animSize, 
        Position = animPos,
        
        -- Gunakan Anchor yang dianimasikan!
        AnchorPoint = animAnchor,
        
        GroupTransparency = transBinding,
        Visible = visibleBinding,
        
        BackgroundColor3 = Atoms.Style.Colors.Background.Surface,
        BorderSizePixel = 0,
        ZIndex = 10
    }, {
        Corner = e("UICorner", { CornerRadius = UDim.new(0, 12) }),
        Header = e("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, LayoutOrder = 1 }, {
            Padding = e("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 8) }),
            Layout = e("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Right }),
            TitleContainer = e("Frame", { Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1 }, {
                Layout = e("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Center }),
                Label = e(Atoms.Text, { Content = props.Title, Variant = "Header", Align = Enum.TextXAlignment.Left })
            }),
            CloseBtn = e(Atoms.Button, { Text = "", Variant = "Ghost", Size = UDim2.fromOffset(32, 32), OnClick = props.OnClose }, {
                Icon = e(Atoms.Icon, { Name = "Close", Size = UDim2.fromOffset(16, 16) })
            })
        }),
        Line = e(Atoms.Divider, { Direction = "Horizontal", LayoutOrder = 2 }),
        Body = e("Frame", { Size = UDim2.new(1, 0, 1, -49), Position = UDim2.fromOffset(0, 49), BackgroundTransparency = 1, LayoutOrder = 3 }, {
            Padding = e("UIPadding", { PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) }),
            Content = React.createElement(React.Fragment, nil, props.children)
        })
    })
end
