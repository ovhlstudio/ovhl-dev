--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Style = Loader.Get("Style"); local Telemetry = Loader.Get("Telemetry")
local e = React.createElement
export type Props = { Value: number, OnChanged: (number) -> (), LayoutOrder: number? }
return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("Slider") end, {})
    local function update(rbx, input)
        local alpha = math.clamp((input.Position.X - rbx.AbsolutePosition.X) / rbx.AbsoluteSize.X, 0, 1)
        props.OnChanged(alpha); logger:Interact("Drag", { Val=alpha })
    end
    return e("TextButton", {
        Text = "", Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Style.Colors.Background.Surface, AutoButtonColor = false, LayoutOrder = props.LayoutOrder,
        [React.Event.InputBegan] = function(rbx, input) if input.UserInputType == Enum.UserInputType.MouseButton1 then update(rbx, input) end end
    }, {
        Corner = e("UICorner", { CornerRadius = UDim.new(1,0) }),
        Fill = e("Frame", { Size = UDim2.fromScale(props.Value, 1), BackgroundColor3 = Style.Colors.Action.Primary.Default }, { Corner = e("UICorner", { CornerRadius = UDim.new(1,0) }) })
    })
end
