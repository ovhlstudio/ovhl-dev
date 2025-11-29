--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local e = React.createElement
export type Props = { Title: string, Size: UDim2?, OnClose: (() -> ())?, _OverridePos: UDim2?, _OverrideAnchor: Vector2?, children: any? }
return function(props: Props)
    return e(Atoms.Surface, {
        Tag = "Surface", Size = props.Size or UDim2.fromOffset(400, 300),
        Position = props._OverridePos or UDim2.fromScale(0.5, 0.5), AnchorPoint = props._OverrideAnchor or Vector2.new(0.5, 0.5),
        CornerRadius = UDim.new(0, 12), Layout = Enum.FillDirection.Vertical, Padding = UDim.new(0, 0)
    }, {
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
        Body = e("Frame", { Size = UDim2.new(1, 0, 1, -49), BackgroundTransparency = 1, LayoutOrder = 3 }, {
            Padding = e("UIPadding", { PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) }),
            Content = React.createElement(React.Fragment, nil, props.children)
        })
    })
end
