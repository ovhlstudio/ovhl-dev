--!strict
-- @Core: DeviceUtil
-- @Role: Platform Detection & UI Scaling Logic
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local DeviceUtil = {}

function DeviceUtil.GetMetrics()
    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    
    -- Heuristic Detection
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local isConsole = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled
    
    local deviceType = "Desktop"
    local scale = 1.0
    
    if isMobile then 
        deviceType = "Mobile" 
        -- Logika Scaling sederhana berdasarkan lebar layar
        scale = math.clamp(viewport.X / 1000, 0.6, 1.0)
    elseif isConsole then
        deviceType = "Console"
        scale = 1.5 -- TV usually needs bigger UI
    end
    
    return {
        Type = deviceType,
        Viewport = viewport,
        Scale = scale,
        Inset = GuiService:GetGuiInset()
    }
end

function DeviceUtil.LogMetrics()
    local log = SmartLogger.New("DEVICE")
    local m = DeviceUtil.GetMetrics()
    log:Info("Detect", {
        Type = m.Type,
        Resolution = string.format("%dx%d", m.Viewport.X, m.Viewport.Y),
        ScaleFactor = m.Scale,
        SafeInsetTop = m.Inset.Y
    })
end

return DeviceUtil
