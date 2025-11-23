--!strict
local fs = require("@lune/fs")

local PATCHES = {}

-- =============================================================================
-- 🧠 OVHL FRAMEWORK CORE FIX (SMART CONFIG LOADER)
-- =============================================================================
-- Problem: Factory cuma nyari config di Modules/.../SharedConfig.
-- Solusi: Tambah fallback search ke folder Config/Global.
-- =============================================================================

PATCHES["src/ReplicatedStorage/OVHL/Core/Framework.luau"] = [=[
--!strict
-- @Core: Framework (Central Factory - V2.1 Config Fix)
-- @Role: Dependency Injector & Standardizer
local RS = game:GetService("ReplicatedStorage")

-- Internal Dependencies
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Core("SmartLogger")
local ActionGuard = Loader.UI.Foundation.ActionGuard
local Bridge = Loader.Core.Networking.Bridge

local Framework = {}

function Framework.CreateController(def)
    local ctrl = def or {}
    local name = ctrl.Name or "UnknownController"
    
    -- 1. Auto-Inject Logger & Tools
    ctrl.Logger = SmartLogger.New(name:upper())
    ctrl.Bridge = Bridge.New()
    ctrl.Guard = ActionGuard
    
    -- 2. Auto-Load Config (SMART LOADER PATCH)
    if ctrl.ConfigName then
        local loadedConfig = nil
        local loadSource = "None"

        -- [STRATEGY A] Cek di Module Feature (Inventory, Shop)
        local successA, resA = pcall(function() 
            return Loader.Module(ctrl.ConfigName).SharedConfig 
        end)
        if successA and resA then
            loadedConfig = resA
            loadSource = "Module"
        else
            -- [STRATEGY B] Cek di Global Config Folder (SystemPanelConfig)
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
            ctrl.Logger:Debug("ConfigLoaded", {Source=loadSource, Name=ctrl.ConfigName})
        else
            -- CRITICAL ERROR: Jangan diam saja kalau config hilang!
            ctrl.Logger:Error("ConfigCritical", "FAILED TO LOAD CONFIG: " .. ctrl.ConfigName)
            -- Kita kasih table kosong biar gak error nil index, tapi tetep bakal malfungsi logicnya
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

    return ctrl
end

return Framework
]=]

print("\n🧠 PATCHING FRAMEWORK FACTORY...")
for path, content in pairs(PATCHES) do
	fs.writeFile(path, content)
	print("✅ FIXED: " .. path)
end
print("\n✨ FRAMEWORK NOW SEARCHES BOTH 'MODULES' AND 'CONFIG' FOLDERS.")
