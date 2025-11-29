--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Title: string, LayoutOrder: number?, children: any }
return function(props: Props)
    return e("Frame", { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.fromScale(1, 0), LayoutOrder = props.LayoutOrder }, {
        Layout = e("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = Style.Metrics.Padding.Small }),
        Header = e("Frame", { Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1 }, {
            Layout = e("UIListLayout", { Padding = UDim.new(0, 4) }),
            Label = e(Atoms.Text, { Content = props.Title, Variant = "Caption", Color = "Muted" }),
            Div = e(Atoms.Divider, { Direction = "Horizontal" })
        }),
        Content = e("Frame", { Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2 }, {
            Layout = e("UIListLayout", { Padding = Style.Metrics.Padding.Small, SortOrder = Enum.SortOrder.LayoutOrder }),
            Body = React.createElement(React.Fragment, nil, props.children)
        })
    })
end
