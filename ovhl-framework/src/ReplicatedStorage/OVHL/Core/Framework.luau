--!strict
-- @Core: Framework (Central Factory - V2.2 With Auto-Trove)
-- @Role: Dependency Injector & Standardizer
local RS = game:GetService("ReplicatedStorage")

-- Internal Dependencies
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local ActionGuard = Loader.Get("ActionGuard")
local Bridge = Loader.Get("Bridge")
local Trove = Loader.Get("Trove") -- [NEW] Load Trove di Pusat

local Framework = {}

function Framework.CreateController(def)
	local ctrl = def or {}
	local name = ctrl.Name or "UnknownController"

	-- 1. Auto-Inject Logger & Tools
	ctrl.Logger = SmartLogger.New(name:upper())
	ctrl.Bridge = Bridge.New()
	ctrl.Guard = ActionGuard
	ctrl.Trove = Trove.new() -- [NEW] Otomatis pasang Tong Sampah Pintar

	-- 2. Auto-Load Config (SMART LOADER PATCH)
	if ctrl.ConfigName then
		local loadedConfig = nil
		local loadSource = "None"

		-- [STRATEGY A] Cek di Module Feature (Inventory, Shop)
		local successA, resA = pcall(function()
			-- [FIXED] Tambahkan require() di sini!
			return require(Loader.Module(ctrl.ConfigName).SharedConfig)
		end)
		if successA and resA then
			loadedConfig = resA
			loadSource = "Module"
		else
			-- [STRATEGY B] Cek di Global Config Folder (SystemPanelConfig)
			-- Note: Loader.Config sudah otomatis require di dalam Proxy-nya, jadi ini aman.
			local successB, resB = pcall(function()
				return Loader.Config(ctrl.ConfigName)
			end)
			if successB and resB then
				loadedConfig = resB
				loadSource = "GlobalConfig"
			end
		end

		-- [RESULT CHECK]
		if loadedConfig then
			ctrl.Config = loadedConfig
			ctrl.Logger:Debug("ConfigLoaded", { Source = loadSource, Name = ctrl.ConfigName })
		else
			ctrl.Logger:Error("ConfigCritical", "FAILED TO LOAD CONFIG: " .. ctrl.ConfigName)
			ctrl.Config = { Meta = { Error = "Missing" }, UI = {}, Topbar = {} }
		end
	end

	-- 3. Lifecycle Wrapper
	local originalInit = ctrl.Init
	function ctrl:Init(ctx)
		if originalInit then
			-- Bungkus dengan pcall biar kalau Init error, gak matiin thread utama
			local s, err = pcall(originalInit, self, ctx)
			if not s then
				ctrl.Logger:Error("InitCrash", err)
			end
		end
	end

	-- [NEW] Auto Cleanup Method
	-- Framework sekarang punya standar cara mematikan Controller
	function ctrl:Destroy()
		if self.Shutdown then
			self:Shutdown()
		end -- Panggil custom shutdown user dulu
		if self.Trove then
			self.Trove:Destroy() -- Bersihkan sampah otomatis
			self.Trove = nil
		end
	end

	return ctrl
end

return Framework
