--!strict
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local ReactBootstrapper = require(RS.OVHL.UI.React.Bootstrapper)

local UIManager = {}
local _handles = {}

function UIManager.Render(viewName, stateMap, config)
    local Log = SmartLogger.New("UI_ENGINE")
    local screenName = config.TargetScreen or (viewName .. "Screen")
    
    local cam = workspace.CurrentCamera
    local viewSize = cam and cam.ViewportSize or Vector2.new(0,0)
    
    Log:Info("Mount", { 
        View = viewName, Screen = screenName, Mode = config.Mode or "Code",
        Viewport = string.format("%dx%d", viewSize.X, viewSize.Y),
        ConfigAnim = config.UI and config.UI.Animation or "None"
    })

    if _handles[screenName] then UIManager.Unmount(screenName) end

    if (config.Mode or "Code") == "Code" then
        local ViewModule = config.View
        if not ViewModule then Log:Critical("MissingView", "No View module provided") return end
        _handles[screenName] = ReactBootstrapper.Mount(screenName, ViewModule, {
            State = stateMap, Config = config, _Meta = { MountTime = os.time(), Viewport = viewSize }
        })
    end
end

function UIManager.Unmount(name)
    if _handles[name] then
        if _handles[name].Unmount then _handles[name].Unmount() end
        _handles[name] = nil
    end
end
return UIManager
