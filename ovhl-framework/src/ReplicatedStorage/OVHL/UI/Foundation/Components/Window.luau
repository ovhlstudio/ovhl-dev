--!strict
-- @Component: Window (Standard Offset)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Core("SmartLogger")

local Logger = SmartLogger.New("UI_LAYOUT")

return function(API)
    return function(scope, props)
        local defaultSize = UDim2.fromOffset(500, 400) -- Sedikit diperlebar
        local targetSize = props.Size or defaultSize
        
        Logger:Debug("WindowInit", {
            Title = props.Title,
            Size = tostring(targetSize),
            Note = "Centered in Scaled Canvas"
        })
    
        return scope:Card {
            Name = "WindowFrame",
            
            -- [CRITICAL FIX] Pastikan Window juga Centered di dalam Canvas
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = targetSize,
            
            List = { FillDirection = Enum.FillDirection.Vertical, Padding = scope:UDim(0, 0) },
            Padding = { All = scope:UDim(0, 0) },
            
            [API.Children] = {
                scope:TitleBar {
                    Content = { props.Title or "Window" },
                    OnClose = props.OnClose,
                    CloseButtonDisabled = (props.OnClose == nil)
                },
                scope:Frame {
                    Name = "Body",
                    Size = UDim2.new(1, 0, 1, -48),
                    BackgroundTransparency = 1,
                    Padding = { All = scope:UDim(0, 16) },
                    [API.Children] = props[API.Children]
                }
            }
        }
    end
end
