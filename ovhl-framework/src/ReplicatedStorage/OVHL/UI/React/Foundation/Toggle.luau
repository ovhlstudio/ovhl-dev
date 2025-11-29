--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Style = Loader.Get("Style"); local Telemetry = Loader.Get("Telemetry")
local e = React.createElement
export type Props = { IsOn: boolean, OnToggle: (boolean) -> (), Disabled: boolean?, LayoutOrder: number? }
return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("Toggle") end, {})
    local trackColor = props.IsOn and Style.Colors.Action.Primary.Default or Style.Colors.Background.Surface
    return e("TextButton", {
        Text = "", Size = UDim2.fromOffset(44, 24), BackgroundColor3 = trackColor, AutoButtonColor = false, LayoutOrder = props.LayoutOrder,
        [React.Event.Activated] = function() if not props.Disabled then logger:Interact("Switch", props.IsOn and "OFF" or "ON"); props.OnToggle(not props.IsOn) end end
    }, {
        Corner = e("UICorner", { CornerRadius = UDim.new(1, 0) }),
        Padding = e("UIPadding", { PaddingLeft = UDim.new(0,2), PaddingRight = UDim.new(0,2), PaddingTop = UDim.new(0,2), PaddingBottom = UDim.new(0,2) }),
        Knob = e("Frame", { Size = UDim2.fromOffset(20, 20), Position = props.IsOn and UDim2.fromScale(1, 0.5) or UDim2.fromScale(0, 0.5), AnchorPoint = props.IsOn and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Style.Colors.Text.Main }, { Corner = e("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    })
end
