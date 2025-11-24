--!strict
-- @Core: Signals (Event Bus)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Signal = Loader.Get("Signal")

local Signals = {}
Signals._registry = {}

function Signals:Get(name)
    if not self._registry[name] then
        self._registry[name] = Signal.new()
    end
    return self._registry[name]
end

function Signals:Fire(name, ...)
    local sig = self._registry[name]
    if sig then
        sig:Fire(...)
    end
end

function Signals:Connect(name, callback)
    return self:Get(name):Connect(callback)
end

return Signals
