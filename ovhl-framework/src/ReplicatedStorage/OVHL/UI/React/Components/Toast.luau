--!strict
-- @Component: Toast v2.0 (Animated)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local Style = Loader.Get("Style")
local useMotion = require(RS.OVHL.UI.React.Hooks.useMotion)
local UIConfig = require(RS.OVHL.Config.UISystemConfig)

local e = React.createElement

export type Props = { Message: string, Variant: string?, Duration: number?, OnDismiss: () -> () }

return function(props: Props)
    local variant = props.Variant or "Success"
    local iconMap = { Success="Success", Warning="Warning", Error="Error" }
    local color = Style.Colors[variant] or Style.Colors.Action.Primary.Default
    
    -- Animation: Slide Up from bottom (+50px to 0)
    local animPos = useMotion(UDim2.new(0.5, 0, 0.9, 0), UIConfig.Motion.ToastEntrance, UDim2.new(0.5, 0, 1.2, 0))
    
    React.useEffect(function() 
        local t = task.delay(props.Duration or 3, props.OnDismiss)
        return function() task.cancel(t) end 
    end, {})

    return e(Atoms.Surface, { 
        Tag = "Overlay", 
        Size = UDim2.fromOffset(300, 60), 
        Position = animPos,
        AnchorPoint = Vector2.new(0.5, 1),
        
        CornerRadius = Style.Metrics.Corner.Medium, 
        Padding = Style.Metrics.Padding.Small, 
        ZIndex = UIConfig.ZIndex.Toast -- Top Layer
    }, {
        Layout = e("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = Style.Metrics.Padding.Small }),
        Icon = e(Atoms.Icon, { Name = iconMap[variant] or "Info", Color = color, Size = UDim2.fromOffset(24,24) }),
        Text = e(Atoms.Text, { Content = props.Message, Variant = "Body", Size = UDim2.new(1, -30, 1, 0) })
    })
end
