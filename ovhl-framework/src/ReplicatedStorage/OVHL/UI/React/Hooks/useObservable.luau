--!strict
-- @Hook: useObservable
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")

return function(observable)
    local val, setVal = React.useState(observable:Get())
    React.useEffect(function()
        local conn = observable:Subscribe(setVal)
        return function() conn:Disconnect() end
    end, {observable})
    return val
end
