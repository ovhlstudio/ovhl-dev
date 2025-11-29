--!strict
-- @Core: LayoutUtil v5.1 (Telemetry)
-- @Role: Layout Math with Detailed Logging for AI Analysis

local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
-- Lazy load logger inside functions to avoid cyclic dep during init
local DeviceUtil = Loader.Get("DeviceUtil")

local LayoutUtil = {}

local ANCHORS = {
    TopLeft      = Vector2.new(0, 0),   TopCenter    = Vector2.new(0.5, 0),   TopRight    = Vector2.new(1, 0),
    MiddleLeft   = Vector2.new(0, 0.5), Center       = Vector2.new(0.5, 0.5), MiddleRight = Vector2.new(1, 0.5),
    BottomLeft   = Vector2.new(0, 1),   BottomCenter = Vector2.new(0.5, 1),   BottomRight = Vector2.new(1, 1),
}

local POSITIONS = {
    TopLeft      = UDim2.fromScale(0, 0),   TopCenter    = UDim2.fromScale(0.5, 0),   TopRight    = UDim2.fromScale(1, 0),
    MiddleLeft   = UDim2.fromScale(0, 0.5), Center       = UDim2.fromScale(0.5, 0.5), MiddleRight = UDim2.fromScale(1, 0.5),
    BottomLeft   = UDim2.fromScale(0, 1),   BottomCenter = UDim2.fromScale(0.5, 1),   BottomRight = UDim2.fromScale(1, 1),
}

function LayoutUtil.Get(config)
    local key = config.Position or "Center"
    local margin = config.Margin or 0
    local fineX = config.OffsetX or 0
    local fineY = config.OffsetY or 0
    
    local anchor = ANCHORS[key] or ANCHORS.Center
    local basePos = POSITIONS[key] or POSITIONS.Center
    
    local moveX, moveY = 0, 0
    if string.find(key, "Left") then moveX = margin elseif string.find(key, "Right") then moveX = -margin end
    if string.find(key, "Top") then moveY = margin elseif string.find(key, "Bottom") then moveY = -margin end
    
    local finalPos = basePos + UDim2.fromOffset(moveX + fineX, moveY + fineY)
    
    -- [TELEMETRY] Log pergerakan posisi
    local Logger = Loader.Get("Logger").New("LAYOUT")
    Logger:Debug("CalcPos", {
        Target = key,
        Anchor = string.format("%.1f, %.1f", anchor.X, anchor.Y),
        Pos = string.format("X:%.1f, Y:%.1f", finalPos.X.Scale, finalPos.Y.Scale)
    })
    
    return { AnchorPoint = anchor, Position = finalPos }
end

function LayoutUtil.GetSmartSize(targetSize: Vector2, minSize: Vector2?)
    local Logger = Loader.Get("Logger").New("LAYOUT")
    local metrics = DeviceUtil.GetMetrics()
    local vp = metrics.Viewport
    local scale = metrics.Scale
    
    -- Sanity Check
    if vp.X < 300 or vp.Y < 200 then
        Logger:Warn("SanityCheck", "Viewport too small ("..vp.X.."x"..vp.Y.."), returning raw size.")
        return UDim2.fromOffset(targetSize.X, targetSize.Y)
    end
    
    -- Scaling Logic
    local scaledW = targetSize.X * scale
    local scaledH = targetSize.Y * scale
    local minW = minSize and minSize.X or 200
    local minH = minSize and minSize.Y or 150
    local finalW = math.max(scaledW, minW)
    local finalH = math.max(scaledH, minH)
    
    -- [TELEMETRY] Log Kalkulasi Ukuran Lengkap
    Logger:Info("SmartSize", {
        Screen = string.format("%dx%d", vp.X, vp.Y),
        DeviceScale = string.format("%.2f", scale),
        InputSize = string.format("%dx%d", targetSize.X, targetSize.Y),
        ResultSize = string.format("%dx%d", finalW, finalH),
        Logic = "Scaled & Clamped"
    })
    
    return UDim2.fromOffset(finalW, finalH)
end

return table.freeze(LayoutUtil)
