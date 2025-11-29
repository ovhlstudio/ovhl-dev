--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Tag: string?, Size: UDim2?, Position: UDim2?, AnchorPoint: Vector2?, Padding: UDim?, Layout: Enum.FillDirection?, ZIndex: number?, CornerRadius: UDim?, children: any? }
return function(props: Props)
    local bgColor = Style.Colors.Background[props.Tag or "Surface"] or Style.Colors.Background.Surface
    local children = props.children or {}; local layoutChildren = table.clone(children)
    if props.CornerRadius or props.Tag ~= "Main" then layoutChildren.Corner = e("UICorner", { CornerRadius = props.CornerRadius or Style.Metrics.Corner.Medium }) end
    if props.Padding then layoutChildren.Padding = e("UIPadding", { PaddingTop = props.Padding, PaddingBottom = props.Padding, PaddingLeft = props.Padding, PaddingRight = props.Padding }) end
    if props.Layout then layoutChildren.ListLayout = e("UIListLayout", { FillDirection = props.Layout, Padding = Style.Metrics.Padding.Small, SortOrder = Enum.SortOrder.LayoutOrder }) end
    return e("Frame", { Size = props.Size or UDim2.fromScale(1, 1), Position = props.Position, AnchorPoint = props.AnchorPoint, BackgroundColor3 = bgColor, BorderSizePixel = 0, ZIndex = props.ZIndex or Style.ZIndex.Base }, layoutChildren)
end
