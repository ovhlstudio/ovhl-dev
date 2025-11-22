-- @UI: OVHLTheme (Smart Object)
-- @Standard: Onyx Native Spec + Pre-processed Assets
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Pkg("Fusion")
local Onyx = Loader.Pkg("onyx-ui")
local Util = Loader.UI("Foundation/Util")

local Scope = Fusion.scoped(Fusion)

-- Zinc & Emerald Palette
local P = {
    Zinc900 = Color3.fromHex("18181b"),
    Zinc800 = Color3.fromHex("27272a"),
    Zinc700 = Color3.fromHex("3f3f46"),
    Emerald500 = Color3.fromHex("10b981"),
    Red500 = Color3.fromHex("ef4444"),
    White = Color3.fromHex("ffffff")
}

-- Create Native Onyx Theme with SMART ASSETS
local OVHLTheme = Onyx.Themer.NewTheme(Scope, {
    Colors = {
        Base = { Main = P.Zinc900 },
        BaseContent = { Main = P.White },
        Primary = { Main = P.Emerald500 },
        Neutral = { Main = P.Zinc800 },
        Error = { Main = P.Red500 },
    },
    CornerRadius = {
        Base = 8
    },
    StrokeThickness = {
        Base = 1
    },
    Font = {
        -- [SMART] Langsung return Font Object, bukan string!
        Body = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
        Heading = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    }
})

return OVHLTheme
