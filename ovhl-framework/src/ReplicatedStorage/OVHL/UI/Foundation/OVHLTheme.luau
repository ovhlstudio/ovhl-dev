--!strict
-- @UI: OVHLTheme (Enterprise Design Tokens)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Get("Fusion")
local Onyx = Loader.Get("Onyx")
local Util = Loader.Get("Util")

local Scope = Fusion.scoped(Fusion)

-- Palet Warna (Zinc & Emerald)
local P = {
    Zinc950 = Color3.fromHex("09090b"), -- Background Gelap
    Zinc900 = Color3.fromHex("18181b"), -- Card Background
    Zinc800 = Color3.fromHex("27272a"), -- Border/Stroke
    Zinc400 = Color3.fromHex("a1a1aa"), -- Text Muted
    White   = Color3.fromHex("ffffff"), -- Text Main
    
    Emerald500 = Color3.fromHex("10b981"), -- Primary Action
    Red500     = Color3.fromHex("ef4444"), -- Destructive
}

local OVHLTheme = Onyx.Themer.NewTheme(Scope, {
    Colors = {
        Base        = { Main = P.Zinc900, Alt = P.Zinc950 },
        BaseContent = { Main = P.White, Muted = P.Zinc400 },
        Primary     = { Main = P.Emerald500 },
        Neutral     = { Main = P.Zinc800 },
        Error       = { Main = P.Red500 },
    },
    CornerRadius = {
        Small  = 4,
        Base   = 8,
        Large  = 12
    },
    StrokeThickness = {
        Base = 1,
        Focus = 2
    },
    -- [NEW] Spacing Tokens (Single Source of Truth)
    Spacing = {
        Small  = 4,
        Medium = 8,
        Large  = 12,
        XLarge = 16
    },
    Font = {
        Body    = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
        Heading = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    }
})

return OVHLTheme
