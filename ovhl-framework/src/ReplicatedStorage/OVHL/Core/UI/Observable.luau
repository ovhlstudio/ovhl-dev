--!strict
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Signal = Loader.Get("Signal")
local SmartLogger = Loader.Get("Logger")

local Observable = {}
Observable.__index = Observable

function Observable.New(val: any, debugTag: string?)
    local self = setmetatable({}, Observable)
    self._value = val
    self._signal = Signal.new()
    self._tag = debugTag
    if debugTag then self._logger = SmartLogger.New("STATE") end
    return self
end

function Observable:Set(val)
    if self._value ~= val then
        local old = self._value
        self._value = val
        self._signal:Fire(val, old)
        if self._logger then
            self._logger:Debug("Change", { Var = self._tag, From = tostring(old), To = tostring(val) })
        end
    end
end

function Observable:Get() return self._value end
function Observable:Subscribe(cb) task.spawn(cb, self._value); return self._signal:Connect(cb) end
function Observable:Log(tagName: string) self._tag = tagName; self._logger = SmartLogger.New("STATE"); return self end
return Observable
