--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Content: string, Variant: string?, Color: string?, Align: Enum.TextXAlignment?, Size: UDim2?, RichText: boolean?, LayoutOrder: number? }
return function(props: Props)
    local variant = props.Variant or "Body"; local colorKey = props.Color or "Main"
    local font, textSize = Style.Fonts.Body, Style.TextSize.Body
    if variant == "Header" or variant == "H1" then font, textSize = Style.Fonts.Header, Style.TextSize.H1 elseif variant == "H2" then font, textSize = Style.Fonts.Header, Style.TextSize.H2 elseif variant == "Caption" then font, textSize = Style.Fonts.Caption, Style.TextSize.Caption end
    local textColor = Style.Colors.Text[colorKey] or Style.Colors.Text.Main
    return e("TextLabel", { Text = props.Content, Font = font, TextSize = textSize, TextColor3 = textColor, BackgroundTransparency = 1, Size = props.Size or UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, TextXAlignment = props.Align or Enum.TextXAlignment.Left, RichText = props.RichText, LayoutOrder = props.LayoutOrder })
end
