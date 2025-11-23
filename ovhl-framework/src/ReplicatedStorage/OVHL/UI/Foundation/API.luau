--!strict
-- @UI: API (Motion System Integrated)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Fusion = Loader.Pkg("Fusion")
local Onyx = Loader.Pkg("onyx-ui")

local Assets = Loader.UI.Foundation.Assets
local Motion = Loader.UI.Foundation.Motion
local MotionPresets = Loader.UI.Foundation.MotionPresets
local Theme = Loader.UI.Foundation.OVHLTheme
local Util = Loader.UI.Foundation.Util
local SafeLoader = Loader.UI.Foundation.SafeLoader

local API = {}

for k,v in pairs(Fusion) do API[k] = v end

API.Fusion = Fusion
API.Onyx = Onyx
API.Theme = Theme
API.Motion = Motion
API.MotionPresets = MotionPresets
API.Assets = Assets
API.Util = Util
API.SafeLoader = SafeLoader
API.Themer = Onyx.Themer

function API.New(scope, class) return Fusion.New(scope, class) end

local Components = {
    AsyncButton = Loader.UI.Foundation.Components.AsyncButton(API),
    SmartText = Loader.UI.Foundation.Components.SmartText(API),
    SmartWindow = Loader.UI.Foundation.Components.SmartWindow(API),
    GridContainer = Loader.UI.Foundation.Components.GridContainer(API),
    ScreenWrapper = Loader.UI.Foundation.Components.ScreenWrapper(API),
    ItemSlot = Loader.UI.Foundation.Components.ItemSlot(API)
}
API.Components = Components

function API.NewScope()
    return Fusion.scoped(Fusion, Util, Components)
end

return table.freeze(API)
