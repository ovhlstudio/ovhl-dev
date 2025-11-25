--!strict
-- @Core: Framework (Central Factory - v0.3.0)
-- @Role: Dependency Injector & Enterprise Standardizer
-- @Feature: Context-Aware Action Guard (Auto-ID Generation)

local RS = game:GetService("ReplicatedStorage")

-- Internal Dependencies
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local Bridge = Loader.Get("Bridge")
local Trove = Loader.Get("Trove")
local ActionGuard = Loader.Get("ActionGuard") -- [NEW] Core Dependency

local Framework = {}

function Framework.CreateController(def)
	local ctrl = def or {}
	local name = ctrl.Name or "UnknownController"

	-- 1. Auto-Inject Logger & Tools
	ctrl.Logger = SmartLogger.New(name:upper())
	ctrl.Bridge = Bridge.New()
	ctrl.Trove = Trove.new()

	-- [ENTERPRISE FEATURE] Context-Aware Guard Injection
	-- Menyuntikkan ActionGuard dengan kemampuan Auto-ID berdasarkan nama Controller.
	-- Ini mencegah bentrok lock antar modul (misal: Inventory vs Shop).
	ctrl.Guard = ActionGuard

	-- Helper: self:SafeRun("Equip", item.Id, func)
	-- Otomatis ID: "NamaController:Equip:ItemId"
	function ctrl:SafeRun(actionName, uniqueParam, callback)
		local autoId = string.format("%s:%s:%s", name, actionName, tostring(uniqueParam or "Global"))
		ActionGuard.Run({
			Id = autoId,
			Debounce = 0.5, -- Default debounce
		}, callback)
	end

	-- Helper: self:SafeRunEx({Action="Buy", Key=id, Debounce=1, Confirm=...}, func)
	-- Untuk kontrol lebih granular (Custom Debounce / Confirmation)
	function ctrl:SafeRunEx(opts, callback)
		local action = opts.Action or "General"
		local key = opts.Key or "Global"
		local autoId = string.format("%s:%s:%s", name, action, tostring(key))

		-- Clone opts agar tidak merusak table asli, lalu inject ID
		local guardOpts = table.clone(opts)
		guardOpts.Id = autoId

		ActionGuard.Run(guardOpts, callback)
	end

	-- 2. Auto-Load Config (PRESERVED LOGIC)
	if ctrl.ConfigName then
		local loadedConfig = nil
		local loadSource = "None"

		-- [STRATEGY A] Cek di Module Feature
		local successA, resA = pcall(function()
			return require(Loader.Module(ctrl.ConfigName).SharedConfig)
		end)
		if successA and resA then
			loadedConfig = resA
			loadSource = "Module"
		else
			-- [STRATEGY B] Cek di Global Config Folder
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

	-- 3. Lifecycle Wrapper (PRESERVED LOGIC)
	local originalInit = ctrl.Init
	function ctrl:Init(ctx)
		if originalInit then
			local s, err = pcall(originalInit, self, ctx)
			if not s then
				ctrl.Logger:Error("InitCrash", err)
			end
		end
	end

	-- Auto Cleanup Method
	function ctrl:Destroy()
		if self.Shutdown then
			self:Shutdown()
		end
		if self.Trove then
			self.Trove:Destroy()
			self.Trove = nil
		end
	end

	return ctrl
end

return Framework
