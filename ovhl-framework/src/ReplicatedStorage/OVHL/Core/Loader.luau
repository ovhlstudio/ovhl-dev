--!strict
-- @Core: Loader v5.2 (Stable & Forgiving)
-- @Role: Central Dependency Registry
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Loader = {}

-- [0] DEBUGGER
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
		print(string.format("🔍 %s %s", prefix, msg))
	end
end

-- [1] ROOT REFERENCES
local ROOTS = {
	OVHL = ReplicatedStorage:WaitForChild("OVHL"),
	Packages = ReplicatedStorage:WaitForChild("Packages"),
}

-- [HELPER] Wally Package Finder (Fixed)
local function findPkg(pkgName: string)
	local exact = ROOTS.Packages:FindFirstChild(pkgName)
	if exact then
		return exact
	end

	local lowerName = pkgName:lower()
	for _, child in ipairs(ROOTS.Packages:GetChildren()) do
		local cName = child.Name:lower()
		if
			cName:find("_" .. lowerName .. "@", 1, true)
			or cName:find("^" .. lowerName .. "@")
			or cName:find(lowerName, 1, true)
		then
			return child
		end
	end
	return nil
end

-- [2] ALIAS REGISTRY
local ALIAS_MAP = {
	-- CORE
	["Framework"] = ROOTS.OVHL.Core.Framework,
	["Context"] = ROOTS.OVHL.Core.Context,
	["Logger"] = ROOTS.OVHL.Core.SmartLogger,
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

	-- UI
	["API"] = ROOTS.OVHL.UI.Foundation.API,
	["Theme"] = ROOTS.OVHL.UI.Foundation.OVHLTheme,
	["Assets"] = ROOTS.OVHL.UI.Foundation.Assets,
	["ActionGuard"] = ROOTS.OVHL.UI.Foundation.ActionGuard,
	["SafeLoader"] = ROOTS.OVHL.UI.Foundation.SafeLoader,
	["Util"] = ROOTS.OVHL.UI.Foundation.Util,
	["Motion"] = ROOTS.OVHL.UI.Foundation.Motion,
	["MotionPresets"] = ROOTS.OVHL.UI.Foundation.MotionPresets,
	["Topbar"] = ROOTS.OVHL.UI.Foundation.Bridges.Topbar,

	-- PACKAGES
	["Onyx"] = findPkg("onyx-ui"),
	["TestEZ"] = findPkg("TestEZ"),
	["Fusion"] = findPkg("Fusion"),
	["Trove"] = findPkg("Trove"),
	["Promise"] = findPkg("Promise"),
	["Signal"] = findPkg("Signal"),
	["ProfileService"] = findPkg("ProfileService"),
}

-- [3] FUZZY SEARCH
local function getDidYouMean(badName: string, validNames: { string })
	local bestMatch = nil
	local bestScore = 999
	for _, name in ipairs(validNames) do
		local score = math.abs(#name - #badName)
		if name:lower():match(badName:lower()) then
			score = score - 2
		end
		if score < 3 and score < bestScore then
			bestScore = score
			bestMatch = name
		end
	end
	return bestMatch
end

-- [4] PUBLIC API
function Loader.Get(aliasName: string)
	local target = ALIAS_MAP[aliasName]
	if target then
		return require(target)
	end

	log("Alias '" .. aliasName .. "' not in Registry. Hunting in Packages...", "WARN")
	local pkg = findPkg(aliasName)
	if pkg then
		log("✅ Auto-detected Package: " .. pkg.Name)
		return require(pkg)
	end

	local keys = {}
	for k in pairs(ALIAS_MAP) do
		table.insert(keys, k)
	end
	local suggestion = getDidYouMean(aliasName, keys)
	local msg = string.format("\n🛑 [OVHL-LOADER] Fatal Error: Module '%s' not found!", aliasName)
	if suggestion then
		msg = msg .. string.format("\n💡 Did you mean: '%s'?", suggestion)
	end
	log("❌ " .. msg, "ERROR")
	error(msg, 2)
end

-- [5] LEGACY & COMPATIBILITY
local function createFolderProxy(folder)
	return setmetatable({}, {
		__index = function(_, key)
			local target = folder:FindFirstChild(key)
			if not target then
				error("❌ '" .. key .. "' not found in " .. folder.Name)
			end
			if target:IsA("ModuleScript") then
				return require(target)
			end
			return createFolderProxy(target)
		end,
		__call = function(_, pathStr)
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
Loader.Module = function(featureName)
	return ROOTS.OVHL.Modules:FindFirstChild(featureName) or error("Module not found")
end

-- [SAFETY NET] Biar kode lama yang lolos refactor gak crash
Loader.Pkg = setmetatable({}, {
	__call = function(_, name)
		if name == "onyx-ui" then
			return Loader.Get("Onyx")
		end
		return Loader.Get(name)
	end,
})

if RunService:IsServer() then
	local ServerRoot = ServerScriptService:WaitForChild("OVHL")
	Loader.Server = function(pathStr)
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
