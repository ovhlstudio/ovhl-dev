--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Style = Loader.Get("Style")
local e = React.createElement
export type Props = { Text: string, Variant: string?, LayoutOrder: number? }
return function(props: Props)
    local variant = props.Variant or "Primary"; local color = Style.Colors.Action[variant] or Style.Colors.Action.Primary
    return e("Frame", { BackgroundColor3 = color.Default, Size = UDim2.fromScale(0, 0), AutomaticSize = Enum.AutomaticSize.XY, LayoutOrder = props.LayoutOrder }, {
        Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Small }),
        Padding = e("UIPadding", { PaddingLeft = Style.Metrics.Padding.Small, PaddingRight = Style.Metrics.Padding.Small, PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2) }),
        Label = e("TextLabel", { Text = props.Text, TextColor3 = Style.Colors.Text.Main, Font = Style.Fonts.Caption, TextSize = Style.TextSize.Small, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY })
    })
end
