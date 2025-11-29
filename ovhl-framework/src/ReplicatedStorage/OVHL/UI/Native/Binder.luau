--!strict
-- @Native: Binder
-- @Role: Bridge for Studio-Created UI (Fallback Mode)
local Binder = {}

function Binder.Bind(screenName, stateMap, config)
    warn("⚠️ [NativeBinder] Native Mode is currently a placeholder.")
    warn("Please use React Mode (config.Mode = 'Code') for now.")
    return {
        Unmount = function() end
    }
end

return Binder
