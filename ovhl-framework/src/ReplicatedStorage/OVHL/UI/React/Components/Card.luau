--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local Style = Loader.Get("Style"); local Telemetry = Loader.Get("Telemetry")
local e = React.createElement; local useState = React.useState
export type Props = { Title: string?, Subtitle: string?, Icon: string?, Size: UDim2?, OnClick: (() -> ())?, LayoutOrder: number?, children: any? }
return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("Card") end, {})
    local hover, setHover = useState(false)
    local bgColor = hover and Style.Colors.Background.Surface:Lerp(Color3.new(1,1,1), 0.05) or Style.Colors.Background.Surface
    local scale = hover and 1.02 or 1
    return e("TextButton", {
        Text = "", Size = props.Size or UDim2.fromOffset(150, 180), BackgroundColor3 = bgColor, AutoButtonColor = false, LayoutOrder = props.LayoutOrder,
        [React.Event.MouseEnter] = function() setHover(true) end, [React.Event.MouseLeave] = function() setHover(false) end,
        [React.Event.Activated] = function() if props.OnClick then logger:Interact("Card", props.Title or "Unknown"); props.OnClick() end end
    }, {
        Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Medium }), Scale = e("UIScale", { Scale = scale }),
        Padding = e("UIPadding", { PaddingTop = Style.Metrics.Padding.Medium, PaddingBottom = Style.Metrics.Padding.Medium, PaddingLeft = Style.Metrics.Padding.Medium, PaddingRight = Style.Metrics.Padding.Medium }),
        Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = Style.Metrics.Padding.Small, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center }),
        Icon = props.Icon and e(Atoms.Icon, { Name = props.Icon, Size = UDim2.fromOffset(40,40), LayoutOrder=1 }),
        Title = props.Title and e(Atoms.Text, { Content = props.Title, Variant = "Body", Align=Enum.TextXAlignment.Center, LayoutOrder=2 }),
        Sub = props.Subtitle and e(Atoms.Text, { Content = props.Subtitle, Variant = "Caption", Color="Muted", Align=Enum.TextXAlignment.Center, LayoutOrder=3 }),
        Body = React.createElement(React.Fragment, nil, props.children)
    })
end
