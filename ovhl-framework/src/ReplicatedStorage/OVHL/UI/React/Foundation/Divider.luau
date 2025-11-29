--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader); local React = Loader.Get("React"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Direction: string?, LayoutOrder: number? }
return function(props: Props)
    local isVert = props.Direction == "Vertical"
    return e("Frame", { Size = isVert and UDim2.new(0, 1, 1, 0) or UDim2.new(1, 0, 0, 1), BackgroundColor3 = Style.Colors.Border, BorderSizePixel = 0, LayoutOrder = props.LayoutOrder })
end
