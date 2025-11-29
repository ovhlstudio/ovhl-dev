--!strict
-- @Hook: useActionGuard
-- @Role: Wraps any function with RateLimit & Visual Feedback
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local RateLimiter = Loader.Get("RateLimiter")
local Telemetry = Loader.Get("Telemetry")

-- Shared Limiter Instance (Singleton per hook usage isn't enough, we need persistent keys)
-- But for simplicity in Hook, we instantiate per component use-case.
-- In strict production, this might use a central limiter cache.

return function(actionFn: () -> (), config: {Max: number, Interval: number}, feedbackFn: ((string, string) -> ())?)
    local logger = React.useMemo(function() return Telemetry.New("ActionGuard") end, {})
    local limiter = React.useMemo(function() return RateLimiter.New() end, {})
    
    local isLocked, setLocked = React.useState(false)
    
    -- Re-enable logic (Cooldown visual)
    React.useEffect(function()
        if isLocked then
            -- Visual Cooldown: Disable button for a short graphical feedback
            -- (Actual limiter logic is math-based, but visual feedback needs time)
            local t = task.delay(0.5, function() 
                setLocked(false) 
            end)
            return function() task.cancel(t) end
        end
    end, {isLocked})

    local trigger = function()
        -- 1. Check Limiter
        if limiter:Check("ClientUser", "Guard", config.Max, config.Interval) then
            -- PASS: Execute Action
            actionFn()
        else
            -- FAIL: Visual Feedback & Logger
            setLocked(true)
            logger:Interact("Block", "RateLimit Hit")
            if feedbackFn then
                feedbackFn("Whoa! Too fast! Cooldown active.", "Error")
            end
        end
    end

    return trigger, isLocked
end
