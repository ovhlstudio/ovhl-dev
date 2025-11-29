--!strict
-- @Core: SharedConfigLoader (Sanitized)
-- @Role: Load & Validate Module Configs
local RS = game:GetService("ReplicatedStorage")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Schema = Loader.Get("Schema")
local SmartLogger = Loader.Get("Logger")

local ConfigLoader = {}

function ConfigLoader.Load(moduleName)
    local Log = SmartLogger.New("CONFIG")
    local root = RS.OVHL.Modules
    local moduleFolder = root:FindFirstChild(moduleName)
    
    if not moduleFolder then
        Log:Warn("ModuleMissing", { Module = moduleName })
        return {}
    end
    
    local configFile = moduleFolder:FindFirstChild("SharedConfig")
    if not configFile then return {} end
    
    local success, data = pcall(require, configFile)
    if not success then
        Log:Error("SyntaxError", { Module = moduleName, Err = tostring(data) })
        return {}
    end
    
    -- Validasi Schema (Passing Logger biar Schema bisa log error)
    Schema.Validate(data, moduleName)
    
    return data
end

return ConfigLoader
