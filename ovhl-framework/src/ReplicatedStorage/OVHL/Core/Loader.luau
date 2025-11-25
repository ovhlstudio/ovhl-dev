--!strict
-- @Core: Loader v0.2.0 (Optimized & Deterministic)
-- @Role: Central Dependency Registry with Caching
-- @Mandate: Mandat 2 (Performance & Determinism)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Loader = {}

-- [0] DEBUGGER & OBSERVABILITY
local DEBUG_MODE = RunService:IsStudio()

local function log(msg: string, level: string?)
	if not DEBUG_MODE then
		return
	end

	local prefix = "[OVHL-LOADER]"
	if level == "ERROR" then
		warn(string.format("🔴 %s %s", prefix, msg))
	elseif level == "WARN" then
		warn(string.format("⚠️ %s %s", prefix, msg))
	else
		-- [AI OBSERVABILITY] Verbose log hanya muncul saat dev
		print(string.format("⚡ %s %s", prefix, msg))
	end
end

-- [1] ROOT REFERENCES
local ROOTS = {
	OVHL = ReplicatedStorage:WaitForChild("OVHL"),
	Packages = ReplicatedStorage:WaitForChild("Packages"),
}

-- [2] PACKAGE CACHE (Optimization)
-- Menyimpan referensi package yang sudah ditemukan agar tidak looping folder lagi
local _packageCache: { [string]: Instance } = {}

local function findPkg(pkgName: string): Instance?
	-- 1. Cek Cache (O(1))
	if _packageCache[pkgName] then
		return _packageCache[pkgName]
	end

	-- 2. Cek Exact Match
	local exact = ROOTS.Packages:FindFirstChild(pkgName)
	if exact then
		_packageCache[pkgName] = exact
		return exact
	end

	-- 3. Scan Wally Format (O(n) - Only runs once per package per session)
	local lowerName = pkgName:lower()
	for _, child in ipairs(ROOTS.Packages:GetChildren()) do
		local cName = child.Name:lower()
		-- Logika standar Wally: author_repo@version atau index folder
		if
			cName:find("_" .. lowerName .. "@", 1, true)
			or cName:find("^" .. lowerName .. "@")
			or cName:find(lowerName, 1, true)
		then
			_packageCache[pkgName] = child -- Simpan ke cache!
			log("Package Cached: " .. pkgName .. " -> " .. child.Name)
			return child
		end
	end

	return nil
end

-- [3] ALIAS REGISTRY (Preserved from v0.1.0)
local ALIAS_MAP = {
	-- CORE
	["Framework"] = ROOTS.OVHL.Core.Framework,
	["Context"] = ROOTS.OVHL.Core.Context,
	["Logger"] = ROOTS.OVHL.Core.SmartLogger,

	-- [NETWORKING PREP] Nanti file ini akan direwrite di Fase 2, tapi reference tetap aman
	["Bridge"] = ROOTS.OVHL.Core.Networking.Bridge,
	["Enums"] = ROOTS.OVHL.Core.Networking.NetworkEnums,
	["Middleware"] = ROOTS.OVHL.Core.Networking.Middleware,

	["Signals"] = ROOTS.OVHL.Core.Signals,
	["Constants"] = ROOTS.OVHL.Core.Constants,
	["Manifest"] = ROOTS.OVHL.Core.Manifest,
	["Env"] = ROOTS.OVHL.Core.Env,
	["Schema"] = ROOTS.OVHL.Core.ConfigSchema,
	["ConfigLoader"] = ROOTS.OVHL.Core.SharedConfigLoader,
	["TypeValidator"] = ROOTS.OVHL.Core.TypeValidator,

	-- UI FOUNDATION
	["API"] = ROOTS.OVHL.UI.Foundation.API,
	["Theme"] = ROOTS.OVHL.UI.Foundation.OVHLTheme,
	["Assets"] = ROOTS.OVHL.UI.Foundation.Assets,
	["ActionGuard"] = ROOTS.OVHL.UI.Foundation.ActionGuard,
	["SafeLoader"] = ROOTS.OVHL.UI.Foundation.SafeLoader,
	["Util"] = ROOTS.OVHL.UI.Foundation.Util,
	["Motion"] = ROOTS.OVHL.UI.Foundation.Motion,
	["MotionPresets"] = ROOTS.OVHL.UI.Foundation.MotionPresets,
	["Topbar"] = ROOTS.OVHL.UI.Foundation.Bridges.Topbar,
	["Layout"] = ROOTS.OVHL.UI.Foundation.Layout,

	-- PACKAGES (Lazy Loaded via Cache if not explicit)
	["Onyx"] = findPkg("onyx-ui"),
	["TestEZ"] = findPkg("TestEZ"),
	["Fusion"] = findPkg("Fusion"),
	["Trove"] = findPkg("Trove"),
	["Promise"] = findPkg("Promise"),
	["Signal"] = findPkg("Signal"),
	["ProfileService"] = findPkg("ProfileService"),
}

-- [4] PUBLIC API
function Loader.Get(aliasName: string)
	-- A. Cek Alias Map
	local target = ALIAS_MAP[aliasName]
	if target then
		return require(target)
	end

	-- B. Cek Cache / Packages (Fallback)
	-- Hanya lakukan ini jika tidak ada di Alias Map.
	local pkg = findPkg(aliasName)
	if pkg then
		return require(pkg)
	end

	-- C. Strict Error (No Fuzzy Search)
	local msg = string.format("🛑 [OVHL-LOADER] Fatal: Module '%s' not found in Registry or Packages.", aliasName)
	log(msg, "ERROR")
	error(msg, 2)
end

-- [5] PROXY & LEGACY SUPPORT (Proxies preserved)
local function createFolderProxy(folder: Instance)
	return setmetatable({}, {
		__index = function(_, key: string)
			local target = folder:FindFirstChild(key)
			if not target then
				error("❌ '" .. key .. "' not found in " .. folder.Name)
			end
			if target:IsA("ModuleScript") then
				return require(target)
			end
			return createFolderProxy(target)
		end,
		__call = function(_, pathStr: string)
			local current = folder
			for _, seg in ipairs(string.split(pathStr, "/")) do
				current = current:FindFirstChild(seg)
				if not current then
					error("Path '" .. seg .. "' missing in " .. folder.Name)
				end
			end
			return if current:IsA("ModuleScript") then require(current) else current
		end,
	})
end

Loader.UI = createFolderProxy(ROOTS.OVHL.UI)
Loader.Config = createFolderProxy(ROOTS.OVHL.Config)

-- Helper Module Loader (Feature Modules)
Loader.Module = function(featureName: string)
	local target = ROOTS.OVHL.Modules:FindFirstChild(featureName)
	if not target then
		error("Module Feature '" .. featureName .. "' not found in OVHL.Modules")
	end
	return target
end

-- Compatibility Helper (Backward Compat)
Loader.Pkg = setmetatable({}, {
	__call = function(_, name)
		if name == "onyx-ui" then
			return Loader.Get("Onyx")
		end
		return Loader.Get(name)
	end,
})

-- Server Side Pathing (Only exposed on Server)
if RunService:IsServer() then
	local ServerRoot = ServerScriptService:WaitForChild("OVHL")
	Loader.Server = function(pathStr: string)
		local current = ServerRoot
		for _, seg in ipairs(string.split(pathStr, "/")) do
			current = current:FindFirstChild(seg)
			if not current then
				error("Server Path '" .. pathStr .. "' not found")
			end
		end
		return require(current)
	end
end

return Loader
