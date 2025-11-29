--!strict
-- @Core: Loader v2.7 (DeviceUtil Added)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Loader = {}
local ROOTS = { OVHL = ReplicatedStorage:WaitForChild("OVHL"), Packages = ReplicatedStorage:WaitForChild("Packages") }
local _packageCache = {}
local function findPkg(pkgName)
	if _packageCache[pkgName] then return _packageCache[pkgName] end
	local exact = ROOTS.Packages:FindFirstChild(pkgName)
	if exact then _packageCache[pkgName] = exact; return exact end
    local lower = pkgName:lower()
	for _, child in ipairs(ROOTS.Packages:GetChildren()) do
		if child.Name:lower():find(lower, 1, true) then _packageCache[pkgName] = child; return child end
	end
	return nil
end
local ALIAS_MAP = {
	["Framework"] = ROOTS.OVHL.Core.Framework, ["Context"] = ROOTS.OVHL.Core.Context,
	["Logger"] = ROOTS.OVHL.Core.SmartLogger, ["Signals"] = ROOTS.OVHL.Core.Signals,
    ["Manifest"] = ROOTS.OVHL.Core.Manifest, ["Env"] = ROOTS.OVHL.Core.Env,
    ["ConfigLoader"] = ROOTS.OVHL.Core.SharedConfigLoader, ["Schema"] = ROOTS.OVHL.Core.ConfigSchema,
    ["TypeValidator"] = ROOTS.OVHL.Core.TypeValidator, ["RateLimiter"] = ROOTS.OVHL.Core.RateLimiter,
    ["Bridge"] = ROOTS.OVHL.Core.Networking.Bridge, ["Enums"] = ROOTS.OVHL.Core.Networking.NetworkEnums,
    ["UIManager"] = ROOTS.OVHL.Core.UI.UIManager, ["Observable"] = ROOTS.OVHL.Core.UI.Observable,
    ["Telemetry"] = ROOTS.OVHL.Core.UI.Telemetry, ["LayoutUtil"] = ROOTS.OVHL.Core.UI.LayoutUtil,
    ["SmartFinder"] = ROOTS.OVHL.Core.UI.SmartFinder, ["MotionUtil"] = ROOTS.OVHL.Core.UI.MotionUtil,
    ["DeviceUtil"] = ROOTS.OVHL.Core.UI.DeviceUtil, -- [ADDED HERE]
    ["Style"] = ROOTS.OVHL.UI.React.Foundation.Style, ["Assets"] = ROOTS.OVHL.UI.React.Foundation.Assets,
    ["Atoms"] = ROOTS.OVHL.UI.React.Foundation.Package, ["Molecules"] = ROOTS.OVHL.UI.React.Components.Package,
    ["React"] = findPkg("React"), ["ReactRoblox"] = findPkg("ReactRoblox"), ["Reflex"] = findPkg("Reflex"),
    ["Promise"] = findPkg("Promise"), ["Signal"] = findPkg("Signal"), ["Trove"] = findPkg("Trove"),
    ["TestEZ"] = findPkg("TestEZ"), ["ProfileService"] = findPkg("ProfileService"), ["Topbar"] = findPkg("TopbarPlus"),
}
if RunService:IsServer() then
    local S_OVHL = ServerScriptService:WaitForChild("OVHL"); local S_CORE = S_OVHL:WaitForChild("Core")
    ALIAS_MAP["ServerKernel"] = S_CORE.ServerKernel; ALIAS_MAP["NetworkGuard"] = S_CORE.NetworkGuard
    ALIAS_MAP["SessionMutex"] = S_CORE.SessionMutex; ALIAS_MAP["DataMigrator"] = S_CORE.DataMigrator
    if S_CORE:FindFirstChild("Permissions") then
        ALIAS_MAP["InternalDB"] = S_CORE.Permissions.Adapters.InternalDB; ALIAS_MAP["HDAdmin"] = S_CORE.Permissions.Adapters.HDAdmin
    end
    if S_OVHL:FindFirstChild("Config") then ALIAS_MAP["PermissionConfig"] = S_OVHL.Config.PermissionConfig end
end
function Loader.Get(aliasName)
	local target = ALIAS_MAP[aliasName]
	if target then return require(target) end
	local pkg = findPkg(aliasName)
	if pkg then return require(pkg) end
	error("🛑 [LOADER] Fatal: Module '" .. aliasName .. "' not found.", 2)
end
Loader.Module = function(featureName)
	local target = ROOTS.OVHL.Modules:FindFirstChild(featureName)
    if not target and RunService:IsClient() then
        local Player = game.Players.LocalPlayer; local ClientModules = Player:WaitForChild("PlayerScripts"):WaitForChild("OVHL"):WaitForChild("Modules")
        target = ClientModules:FindFirstChild(featureName)
    end
	if not target then error("Module Feature '" .. featureName .. "' not found") end
	return target
end
Loader.UI = { React = ROOTS.OVHL.UI.React, Native = ROOTS.OVHL.UI.Native, Core = ROOTS.OVHL.Core.UI }
Loader.Config = function(configName)
    local cfgFolder = ROOTS.OVHL.Config; local target = cfgFolder:FindFirstChild(configName)
    if target then return require(target) end
    error("Config '"..configName.."' not found in OVHL.Config")
end
return Loader
