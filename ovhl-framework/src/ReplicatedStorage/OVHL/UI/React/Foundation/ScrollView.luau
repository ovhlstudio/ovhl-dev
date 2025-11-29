--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader); local React = Loader.Get("React"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Size: UDim2?, ContentPadding: UDim?, children: any? }
return function(props: Props)
    return e("ScrollingFrame", { Size = props.Size or UDim2.fromScale(1, 1), CanvasSize = UDim2.fromScale(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ScrollBarThickness = 6, ScrollBarImageColor3 = Style.Colors.Border, BorderSizePixel = 0, BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png", TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png" }, {
        Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = props.ContentPadding or Style.Metrics.Padding.Small, HorizontalAlignment = Enum.HorizontalAlignment.Center }), Content = React.createElement(React.Fragment, nil, props.children)
    })
end
