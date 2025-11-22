-- @UI: API (Foundation Wrapper)
-- @Responsibility: Expose Fusion, Onyx, and Core Components via a single require.
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- [DEPENDENCIES]
local Fusion = Loader.Pkg("Fusion")
local Onyx = Loader.Pkg("onyx-ui")
local OVHLUtil = Loader.UI("Foundation/Util") -- Custom helper (ToFont, etc)
local OVHLTheme = Loader.UI("Foundation/OVHLTheme")
local SafeLoader = Loader.UI("Foundation/SafeLoader")

-- [UTIL MERGE STRATEGY]
-- Kita gabungkan Onyx.Util (UDim, Vector2, Spring, dll) dengan Custom Util kita.
local CombinedUtil = {}

-- 1. Copy Onyx Utils
for k, v in pairs(Onyx.Util) do
    CombinedUtil[k] = v
end

-- 2. Copy/Override with OVHL Utils
for k, v in pairs(OVHLUtil) do
    CombinedUtil[k] = v
end

local API = {}

-- [1] FUSION EXPORTS (Explicit)
API.New = Fusion.New
API.Value = Fusion.Value
API.Computed = Fusion.Computed
API.ForValues = Fusion.ForValues
API.ForPairs = Fusion.ForPairs
API.ForKeys = Fusion.ForKeys
API.Children = Fusion.Children
API.OnEvent = Fusion.OnEvent
API.OnChange = Fusion.OnChange
API.Out = Fusion.Out
API.Observer = Fusion.Observer
API.cleanup = Fusion.doCleanup

-- [2] LIBRARIES
API.Fusion = Fusion
API.Onyx = Onyx
API.Themer = Onyx.Themer
API.Util = CombinedUtil -- Gunakan yang sudah di-merge
API.Theme = OVHLTheme
API.SafeLoader = SafeLoader

-- [3] CUSTOM COMPONENTS
-- We require them here to avoid circular dependency issues during initialization
local Components = {
    ScreenWrapper = Loader.UI("Foundation/Components/ScreenWrapper")(API),
    SmartButton = Loader.UI("Foundation/Components/SmartButton")(API),
    Window = Loader.UI("Foundation/Components/Window")(API)
}
API.Components = Components

-- [4] SCOPE GENERATOR
function API.NewScope()
    -- Merge Onyx and Custom Components into the scope metatable
    local methods = {}
    for k, v in pairs(Onyx.Components) do methods[k] = v end
    for k, v in pairs(Components) do methods[k] = v end
    
    -- Pass CombinedUtil here so scope:UDim() works!
    return Fusion.scoped(Fusion, CombinedUtil, methods)
end

return table.freeze(API)
