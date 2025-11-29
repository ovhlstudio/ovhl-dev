--!strict
local MotionUtil = {}
MotionUtil.Presets = {
    Bouncy = { Damping = 12, Stiffness = 180 },
    Stiff  = { Damping = 20, Stiffness = 300 },
    Smooth = { Damping = 30, Stiffness = 120 },
    SlideIn = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
    Fade    = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
}
function MotionUtil.Get(name: string) return MotionUtil.Presets[name] or MotionUtil.Presets.Smooth end
return table.freeze(MotionUtil)
