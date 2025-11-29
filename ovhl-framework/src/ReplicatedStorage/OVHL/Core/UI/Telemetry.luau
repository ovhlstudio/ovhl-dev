--!strict
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local Telemetry = {}
Telemetry.__index = Telemetry
function Telemetry.New(context)
    local self = setmetatable({}, Telemetry)
    self._log = SmartLogger.New("UX")
    self._ctx = context or "UI"
    return self
end
function Telemetry:Interact(elem, action)
    self._log:Info("Interact", { Context=self._ctx, Element=elem, Action=action })
end
return Telemetry
