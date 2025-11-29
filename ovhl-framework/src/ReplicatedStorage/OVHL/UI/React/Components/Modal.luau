--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Title: string, Size: UDim2?, OnClose: () -> (), OnAction: (() -> ())?, ActionLabel: string?, children: any }
return function(props: Props)
    return e("Frame", { Name = "ModalOverlay", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Style.Colors.Background.Overlay, BackgroundTransparency = Style.Opacity.Dim, ZIndex = Style.ZIndex.Modal, Active = true }, {
        Container = e(Atoms.Surface, {
            Tag = "Surface", Size = props.Size or UDim2.fromOffset(400, 250), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
            CornerRadius = Style.Metrics.Corner.Large, Padding = Style.Metrics.Padding.Medium, Layout = Enum.FillDirection.Vertical
        }, {
            Header = e(Atoms.Text, { Content = props.Title, Variant = "H2", Align = Enum.TextXAlignment.Center, LayoutOrder = 1 }),
            Divider = e(Atoms.Divider, { Direction = "Horizontal", LayoutOrder = 2 }),
            Content = e("Frame", { Size = UDim2.new(1, 0, 1, -100), BackgroundTransparency = 1, LayoutOrder = 3 }, {
                Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = Style.Metrics.Padding.Small }), Body = React.createElement(React.Fragment, nil, props.children)
            }),
            Actions = e("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, LayoutOrder = 4 }, {
                Layout = e("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = Style.Metrics.Padding.Medium, VerticalAlignment = Enum.VerticalAlignment.Bottom }),
                CancelBtn = e(Atoms.Button, { Text = "Cancel", Variant = "Ghost", OnClick = props.OnClose }),
                ActionBtn = props.OnAction and e(Atoms.Button, { Text = props.ActionLabel or "Confirm", Variant = "Primary", OnClick = props.OnAction })
            })
        })
    })
end
