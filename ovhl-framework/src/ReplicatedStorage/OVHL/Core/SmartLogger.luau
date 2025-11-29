--!strict
-- @Core: SmartLogger v3.0 (Serializer)
-- @Role: Logging with Advanced Table Dumping
local HttpService = game:GetService("HttpService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Config = Loader.Config("LoggerConfig")
local Env = Loader.Get("Env")

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local CONTEXT_TAG = Env.IsServer() and "[SERVER]" or "[CLIENT]"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    self._rawDomain = domain or "SYSTEM"
    
    local mapped = Config.Domains[self._rawDomain]
    if mapped then self._domainDisplay = mapped
    else self._domainDisplay = string.format("📦 %s", self._rawDomain:upper()) end
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
    
    return self
end

-- [NEW] ADVANCED SERIALIZER
-- Mengubah tabel kompleks menjadi string yang enak dibaca
function SmartLogger:_serialize(val, depth)
    depth = depth or 0
    if depth > 2 then return "..." end -- Limit kedalaman agar tidak spam/crash
    
    local t = typeof(val)
    
    if t == "table" then
        -- Cek apakah array murni atau dictionary
        local isArray = true
        local count = 0
        for k, _ in pairs(val) do
            count = count + 1
            if type(k) ~= "number" then isArray = false break end
        end
        
        -- Jika array panjang, ringkas saja
        if isArray and count > 5 then
            return string.format("[Array with %d items]", count)
        end
        
        local parts = {}
        for k, v in pairs(val) do
            local keyStr = tostring(k)
            local valStr = self:_serialize(v, depth + 1)
            table.insert(parts, keyStr .. ": " .. valStr)
        end
        return "{" .. table.concat(parts, ", ") .. "}"
        
    elseif t == "Instance" then
        return val.Name .. " (" .. val.ClassName .. ")"
    elseif t == "function" then
        return "func()"
    elseif t == "userdata" then
        return tostring(val) -- Vector3, UDim2 aman di tostring
    else
        return tostring(val)
    end
end

function SmartLogger:_safeFormat(level, message, data)
    if not message then return nil end
    local cfg = Config.Levels[level]
    if not cfg then return nil end
    
    local meta = ""
    if data ~= nil then
        -- Coba JSON Encode dulu (paling rapi)
        local success, result = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        
        if success then
            -- Jika data terlalu panjang, potong biar console ga meledak
            if #result > 1000 then result = string.sub(result, 1, 1000) .. "..." end
            meta = " │ " .. result
        else
            -- [FALLBACK] Jika JSON gagal, pakai Serializer manual kita
            meta = " │ [RAW] " .. self:_serialize(data)
        end
    end

    local levelIcon = cfg.Icon or "📝"
    return string.format("%s %s %s\n   └── %s%s", 
        levelIcon, CONTEXT_TAG, self._domainDisplay, message, meta)
end

function SmartLogger:_log(level, message, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end
    
    local logMessage = self:_safeFormat(level, message, data)
    if not logMessage then return end
    
    if level == "ERROR" or level == "CRITICAL" then warn(logMessage)
    else print(logMessage) end
end

function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end

return SmartLogger
