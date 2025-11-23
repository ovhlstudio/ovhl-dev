--!strict
-- @Core: SmartLogger
-- @PortedFrom: Snapshot V4.0
local HttpService = game:GetService("HttpService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Config = Loader.Config("LoggerConfig")
local Env = Loader.Core("Env")

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local CONTEXT_TAG = Env.IsServer() and "[SERVER]" or "[CLIENT]"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    self._rawDomain = domain or "SYSTEM"
    
    local mapped = Config.Domains[self._rawDomain]
    if mapped then
        self._domainDisplay = mapped
    else
        self._domainDisplay = string.format("📦 %s", self._rawDomain:upper())
    end
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
    
    return self
end

function SmartLogger:_safeDump(data, depth)
    depth = depth or 0
    if depth > 2 then return "..." end
    
    local t = type(data)
    if t == "table" then
        local parts = {}
        for k, v in pairs(data) do
            if type(k) == "string" then
                table.insert(parts, k .. "=" .. self:_safeDump(v, depth + 1))
            end
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    elseif t == "userdata" then
        return typeof(data)
    else
        return tostring(data)
    end
end

function SmartLogger:_safeFormat(level, message, data)
    if not message then return nil end
    
    local cfg = Config.Levels[level]
    if not cfg then return nil end
    
    local meta = ""
    if data ~= nil then
        local success, result = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        if success then
            meta = " │ " .. result
        else
            meta = " │ [RAW] " .. self:_safeDump(data)
        end
    end

    local levelIcon = cfg.Icon or "📝"
    -- [SAFE] Lune menangani karakter newline (\n) secara native di sini
    return string.format("%s %s %s\n   └── %s%s", 
        levelIcon, CONTEXT_TAG, self._domainDisplay, message, meta)
end

function SmartLogger:_log(level, message, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end
    
    local logMessage = self:_safeFormat(level, message, data)
    if not logMessage then return end
    
    if level == "ERROR" or level == "CRITICAL" then
        warn(logMessage)
    else
        print(logMessage)
    end
end

function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end

return SmartLogger
