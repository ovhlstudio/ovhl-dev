--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Telemetry = Loader.Get("Telemetry"); local Style = Loader.Get("Style")
local Players = game:GetService("Players"); local e = React.createElement; local useState = React.useState
export type Props = { Text: string, Variant: string?, Size: UDim2?, OnClick: (() -> ())?, Disabled: boolean?, LayoutOrder: number?, Permission: number? }
return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("Button") end, {})
    local hover, setHover = useState(false); local press, setPress = useState(false)
    local myRank = Players.LocalPlayer:GetAttribute("OVHL_Rank") or 0; local isLocked = myRank < (props.Permission or 0)
    local isDisabled = props.Disabled or isLocked
    local variant = props.Variant or "Primary"; local actionGroup = Style.Colors.Action; local palette = actionGroup[variant] or actionGroup.Primary
    local bgColor = palette.Default
    if isDisabled then bgColor = Style.Colors.Background.Surface elseif press then bgColor = palette.Press elseif hover then bgColor = palette.Hover end
    return e("TextButton", {
        Text = isLocked and "🔒 " .. props.Text or props.Text, Font = Style.Fonts.Header, TextSize = Style.TextSize.Body,
        TextColor3 = isDisabled and Style.Colors.Text.Muted or palette.Content, Size = props.Size or UDim2.fromOffset(140, 44),
        BackgroundColor3 = bgColor, BackgroundTransparency = (variant == "Ghost" and not hover) and 1 or 0, AutoButtonColor = false, LayoutOrder = props.LayoutOrder,
        [React.Event.Activated] = function() if isLocked then logger:Interact(props.Text, {Res="Denied"}) return end; if not isDisabled then logger:Interact(props.Text, "Click"); if props.OnClick then props.OnClick() end end end,
        [React.Event.MouseEnter] = function() if not isDisabled then setHover(true) end end, [React.Event.MouseLeave] = function() setHover(false); setPress(false) end,
        [React.Event.MouseButton1Down] = function() if not isDisabled then setPress(true) end end, [React.Event.MouseButton1Up] = function() setPress(false) end
    }, { Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Medium }), Padding = e("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4) }) })
end
