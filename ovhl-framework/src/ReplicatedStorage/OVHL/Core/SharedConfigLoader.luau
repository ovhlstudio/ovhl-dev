-- @Core: SharedConfigLoader
-- Mencari dan memuat SharedConfig dari folder Modules
local RS = game:GetService("ReplicatedStorage")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Schema = Loader.Core("ConfigSchema")

local ConfigLoader = {}

function ConfigLoader.Load(moduleName)
    -- Cari folder module
    local root = RS.OVHL.Modules
    local moduleFolder = root:FindFirstChild(moduleName)
    
    if not moduleFolder then
        warn("[Config] Module not found: " .. moduleName)
        return {}
    end
    
    -- Cari file config
    local configFile = moduleFolder:FindFirstChild("SharedConfig")
    if not configFile then
        return {} -- Config is optional, return empty
    end
    
    -- Require & Validate
    local success, data = pcall(require, configFile)
    if not success then
        warn("[Config] Syntax Error in " .. moduleName .. ": " .. tostring(data))
        return {}
    end
    
    -- Validasi Schema
    Schema.Validate(data, moduleName)
    
    return data
end

return ConfigLoader
