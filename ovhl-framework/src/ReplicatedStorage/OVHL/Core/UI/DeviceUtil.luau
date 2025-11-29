--!strict
-- @Core: DeviceUtil v2.0 (True Scaling)
-- @Role: Platform Detection & Scale Calculation
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local DeviceUtil = {}

-- [CONFIG] Standar Desain kita di PC (FHD)
local REF_RES = Vector2.new(1920, 1080)

function DeviceUtil.GetMetrics()
    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize or REF_RES
    
    -- Safety Check jika Viewport ngaco (0x0)
    if viewport.X < 1 or viewport.Y < 1 then viewport = REF_RES end
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local isConsole = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled
    
    -- [CORE LOGIC] Scale Factor Calculation
    -- Kita cari rasio terkecil agar UI muat di lebar DAN tinggi (Fit)
    local scaleX = viewport.X / REF_RES.X
    local scaleY = viewport.Y / REF_RES.Y
    
    -- Ambil scale terkecil agar tidak ada yang kepotong
    -- Contoh: Di HP Portrait, scaleX kecil (0.2), scaleY besar. Kita ikut scaleX.
    local scale = math.min(scaleX, scaleY)
    
    -- Clamp Scale: Jangan terlalu kecil (< 0.3) dan jangan terlalu besar (> 1.2 di 4K)
    -- Agar text tetap terbaca
    scale = math.clamp(scale, 0.4, 1.5)
    
    local deviceType = "Desktop"
    if isMobile then deviceType = "Mobile" 
    elseif isConsole then deviceType = "Console" end

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
        ScaleFactor = string.format("%.2f", m.Scale)
    })
end

return DeviceUtil
