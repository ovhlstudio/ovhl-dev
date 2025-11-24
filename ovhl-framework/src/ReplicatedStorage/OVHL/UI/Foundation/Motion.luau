--!strict
-- @Foundation: Motion (Scope Safe)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Get("Fusion")

local Motion = {}

-- Fusion 0.3 Spring
local SPEED_BASE = 25
local DAMP_BASE = 1
local SPEED_BOUNCY = 30
local DAMP_BOUNCY = 0.6

function Motion.Spring(scope, targetValue)
    return Fusion.Spring(scope, targetValue, SPEED_BASE, DAMP_BASE)
end

function Motion.Bouncy(scope, targetValue)
    return Fusion.Spring(scope, targetValue, SPEED_BOUNCY, DAMP_BOUNCY)
end

-- [FIXED] Hover Scale Logic without Scope Leak
function Motion.HoverScale(scope, isHoveredState)
    -- Kita buat spring terpisah yang mengikuti boolean
    local target = Fusion.Computed(scope, function(use)
        return use(isHoveredState) and 1.05 or 1
    end)
    return Fusion.Spring(scope, target, SPEED_BASE, DAMP_BASE)
end

return Motion
