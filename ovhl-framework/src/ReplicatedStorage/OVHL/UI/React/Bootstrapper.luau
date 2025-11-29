--!strict
-- @React: Bootstrapper
-- @Role: React Root Handler & ScreenGui Management

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local ReactRoblox = Loader.Get("ReactRoblox")

local Bootstrapper = {}

function Bootstrapper.Mount(screenName: string, Component: any, props: table)
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local screen = playerGui:FindFirstChild(screenName)
    if not screen then
        screen = Instance.new("ScreenGui")
        screen.Name = screenName
        screen.Parent = playerGui
        screen.ResetOnSpawn = false
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Apply Config Display Order if exists
        if props.Config and props.Config.Order then
            screen.DisplayOrder = props.Config.Order
        end
    end

    local root = ReactRoblox.createRoot(screen)
    
    root:render(React.createElement(React.StrictMode, nil, 
        React.createElement(Component, props)
    ))

    return {
        Unmount = function()
            root:unmount()
            if screen then screen:Destroy() end
        end,
        Screen = screen
    }
end

return Bootstrapper
