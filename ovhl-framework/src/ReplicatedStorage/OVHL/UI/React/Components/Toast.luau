--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local Style = Loader.Get("Style"); local e = React.createElement
export type Props = { Message: string, Variant: string?, Duration: number?, OnDismiss: () -> () }
return function(props: Props)
    local variant = props.Variant or "Success"; local iconMap = { Success="Success", Warning="Warning", Error="Error" }; local iconName = iconMap[variant] or "Info"; local color = Style.Colors[variant] or Style.Colors.Action.Primary.Default
    React.useEffect(function() local t = task.delay(props.Duration or 3, props.OnDismiss); return function() task.cancel(t) end end, {})
    return e(Atoms.Surface, { Tag = "Overlay", Size = UDim2.fromOffset(300, 60), CornerRadius = Style.Metrics.Corner.Medium, Padding = Style.Metrics.Padding.Small, ZIndex = Style.ZIndex.Toast }, {
        Layout = e("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = Style.Metrics.Padding.Small }),
        Icon = e(Atoms.Icon, { Name = iconName, Color = color, Size = UDim2.fromOffset(24,24) }),
        Text = e(Atoms.Text, { Content = props.Message, Variant = "Body", Size = UDim2.new(1, -30, 1, 0) })
    })
end
