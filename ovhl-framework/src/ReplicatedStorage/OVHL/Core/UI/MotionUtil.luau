--!strict
-- @Core: MotionUtil v3.1 (Tuned)
-- @Role: Shared Physics Constants & Solver

local MotionUtil = {}

MotionUtil.Presets = {
    -- [TUNED] Pop effect yang pas, tidak terlalu liar
    Bouncy = { Damping = 15, Stiffness = 160, Mass = 1 },
    
    -- [TUNED] Relaxed Stiff - Responsif tapi tidak Teleport
    -- Damping dinaikkan sedikit, Stiffness diturunkan
    Stiff  = { Damping = 18, Stiffness = 120, Mass = 0.8 },
    
    -- Cinematic Slow
    Smooth = { Damping = 20, Stiffness = 80, Mass = 1 },
    
    -- Micro Interactions
    Snappy = { Damping = 30, Stiffness = 300, Mass = 0.6 }
}

function MotionUtil.Get(name: string?)
    return MotionUtil.Presets[name or "Smooth"] or MotionUtil.Presets.Smooth
end

function MotionUtil.SolveSpring(current, target, velocity, config, dt)
    local k = config.Stiffness or 170
    local d = config.Damping or 26
    local m = config.Mass or 1
    
    local displacement = current - target
    local springForce = -k * displacement
    local dampingForce = -d * velocity
    local acceleration = (springForce + dampingForce) / m
    
    local newVelocity = velocity + (acceleration * dt)
    local newPosition = current + (newVelocity * dt)
    
    return newPosition, newVelocity
end

return table.freeze(MotionUtil)
