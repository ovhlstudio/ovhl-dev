--!strict
-- @Foundation: SafeLoader (With Telemetry)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Fusion = Loader.Pkg("Fusion")
local SmartLogger = Loader.Core("SmartLogger")

local SafeLoader = {}
local Logger = SmartLogger.New("USER_INTERFACE")

function SafeLoader.Mount(scope, componentFunc, props)
    local viewName = "UnknownView"
    if props.Config and props.Config.Meta then
        viewName = props.Config.Meta.Name .. "View"
    end

    local success, result = xpcall(function()
        return componentFunc(scope, props)
    end, debug.traceback)

    if success then
        Logger:Info("MountSuccess", { -- Pakai Info agar pasti muncul
            View = viewName,
            Screen = props.Name or "Screen"
        })
        return result
    else
        Logger:Error("MountFailed", { View = viewName, Error = result })
        
        return scope:New "Frame" {
            Name = "ErrorBoundary",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(40, 0, 0),
            ZIndex = 9999,
            [Fusion.Children] = {
                scope:New "TextLabel" {
                    Text = "UI ERROR: " .. tostring(result),
                    TextColor3 = Color3.new(1,0.5,0.5),
                    Size = UDim2.fromScale(1,1),
                    BackgroundTransparency = 0.5
                }
            }
        }
    end
end

return SafeLoader
