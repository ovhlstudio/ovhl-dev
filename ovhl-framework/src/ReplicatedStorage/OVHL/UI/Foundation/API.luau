--!strict
-- @UI: API (Motion System Integrated)
-- @Standard: Enterprise Dependency Injection
-- @Status: ✅ ANTI-NIGHTMARE CERTIFIED & UPDATED (Layout + ModalWrapper)

local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- [1] External Libs
local Fusion = Loader.Get("Fusion")
local Onyx = Loader.Get("Onyx")

-- [2] Internal Tools
local Assets = Loader.Get("Assets")
local Motion = Loader.Get("Motion")
local MotionPresets = Loader.Get("MotionPresets")
local Theme = Loader.Get("Theme")
local Util = Loader.Get("Util")
local SafeLoader = Loader.Get("SafeLoader")
local Layout = Loader.Get("Layout") -- [NEW] Layout Helper (Pastikan file Layout.luau ada)

-- [3] Base Construction (Native Speed)
local API = table.clone(Fusion)

-- [4] Inject Dependencies
API.Fusion = Fusion
API.Onyx = Onyx
API.Theme = Theme
API.Motion = Motion
API.MotionPresets = MotionPresets
API.Assets = Assets
API.Util = Util
API.SafeLoader = SafeLoader
API.Layout = Layout -- [NEW] Inject Layout ke API agar bisa dipanggil via UI.Layout
API.Themer = Onyx.Themer

function API.New(scope, class)
	return Fusion.New(scope, class)
end

-- [5] COMPONENT REGISTRY (THE FACTORY)
-- Kita menyuntikkan 'API' ke dalam komponen.
-- Komponen WAJIB menggunakan struktur: return function(API) ... end

local Components = {
	AsyncButton = Loader.UI.Foundation.Components.AsyncButton(API),
	SmartText = Loader.UI.Foundation.Components.SmartText(API),
	SmartWindow = Loader.UI.Foundation.Components.SmartWindow(API),
	GridContainer = Loader.UI.Foundation.Components.GridContainer(API),
	ScreenWrapper = Loader.UI.Foundation.Components.ScreenWrapper(API),
	ItemSlot = Loader.UI.Foundation.Components.ItemSlot(API),

	-- [NEW] Anti-Ghost Overlay (Pastikan file Components/ModalWrapper.luau SUDAH ADA)
	ModalWrapper = Loader.UI.Foundation.Components.ModalWrapper(API),
}

API.Components = Components

function API.NewScope()
	return Fusion.scoped(Fusion, Util, Components)
end

return table.freeze(API)
