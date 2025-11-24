--!strict
-- @Foundation: MotionPresets v2.0 (Directional)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Get("Fusion")
local Motion = Loader.Get("Motion")

local Presets = {}

-- [HELPER]
local function bind(scope, state, valTrue, valFalse, motionType)
    local target = Fusion.Computed(scope, function(use)
        return use(state) and valTrue or valFalse
    end)
    return motionType(scope, target)
end

-- ==========================================
-- 1. BASIC ANIMATIONS
-- ==========================================

-- POP UP (Zoom In + Fade)
function Presets.PopUp(scope, isVisible)
    return {
        Scale = bind(scope, isVisible, 1, 0.8, Motion.Bouncy),
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- FADE (Alpha Only)
function Presets.Fade(scope, isVisible)
    return {
        Scale = 1,
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- ==========================================
-- 2. DIRECTIONAL SLIDES (OFF-SCREEN ENTRY)
-- ==========================================

-- SLIDE FROM BOTTOM (Naik ke atas)
-- Cocok untuk: Inventory, Shop, Mobile Cards
function Presets.SlideFromBottom(scope, isVisible)
    return {
        Scale = 1,
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring),
        -- Visible: Tengah (0.5, 0.5). Hidden: Bawah Layar (0.5, 1.5)
        Position = bind(scope, isVisible, UDim2.fromScale(0.5, 0.5), UDim2.fromScale(0.5, 1.5), Motion.Bouncy),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- SLIDE FROM TOP (Turun ke bawah)
-- Cocok untuk: Settings, Notifications
function Presets.SlideFromTop(scope, isVisible)
    return {
        Scale = 1,
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring),
        -- Visible: Tengah. Hidden: Atas Layar (0.5, -0.5)
        Position = bind(scope, isVisible, UDim2.fromScale(0.5, 0.5), UDim2.fromScale(0.5, -0.5), Motion.Bouncy),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- SLIDE FROM LEFT (Masuk dari kiri)
-- Cocok untuk: Sidebar Menu, Navigation
function Presets.SlideFromLeft(scope, isVisible)
    return {
        Scale = 1,
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring), -- Optional: set 0 kalau mau solid terus
        -- Visible: Kiri Tengah (Atur posisi sesuai kebutuhan, misal Sidebar biasanya nempel kiri)
        -- Disini kita buat ke tengah layar dulu biar konsisten sama SmartWindow
        Position = bind(scope, isVisible, UDim2.fromScale(0.5, 0.5), UDim2.fromScale(-0.5, 0.5), Motion.Bouncy),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- SLIDE FROM RIGHT (Masuk dari kanan)
-- Cocok untuk: Details Panel, Inspect
function Presets.SlideFromRight(scope, isVisible)
    return {
        Scale = 1,
        Transparency = bind(scope, isVisible, 0, 1, Motion.Spring),
        -- Hidden: Kanan Layar (1.5)
        Position = bind(scope, isVisible, UDim2.fromScale(0.5, 0.5), UDim2.fromScale(1.5, 0.5), Motion.Bouncy),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
end

-- ==========================================
-- 3. ALIASES (Shortcuts)
-- ==========================================
Presets.Slide = Presets.SlideFromBottom -- Default "Slide" = Bottom
Presets.SlideBottom = Presets.SlideFromBottom
Presets.SlideTop = Presets.SlideFromTop
Presets.SlideLeft = Presets.SlideFromLeft
Presets.SlideRight = Presets.SlideFromRight

return table.freeze(Presets)
