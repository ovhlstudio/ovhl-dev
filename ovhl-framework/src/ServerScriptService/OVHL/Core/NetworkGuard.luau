--!strict
-- @Core: NetworkGuard v1.1 (With CCTV)
-- @Role: Firewall with Logging Capabilities
local RS = game:GetService("ReplicatedStorage")
-- [FIX] Manual Path for internal core usage prevents circular dep issues in Loader
local SmartLogger = require(RS.OVHL.Core.SmartLogger) 

local NetworkGuard = {}
local Logger = SmartLogger.New("SECURITY")

local MAX_DEPTH = 10
local SENSITIVE_KEYS = {
    "token", "api_key", "secret", "password", "auth", "private"
}

-- [[ INBOUND: CLIENT -> SERVER ]]
function NetworkGuard.CleanIn(val, depth, player)
    depth = depth or 0
    if depth > MAX_DEPTH then 
        Logger:Warn("Overflow", {Msg="Recursion depth exceeded", Plr=tostring(player)})
        return nil 
    end
    
    local t = typeof(val)
    
    -- 1. Block Instances (CRITICAL LOG)
    if t == "Instance" then
        Logger:Warn("ExploitAttempt", {
            Msg = "Instance type dropped from request",
            Val = tostring(val),
            Plr = tostring(player)
        })
        return nil 
    end
    
    -- 2. Sanitize Strings
    if t == "string" then
        if #val > 2048 then 
            return string.sub(val, 1, 2048) 
        end
        return val
    end
    
    -- 3. Recursively Clean Tables
    if t == "table" then
        local clean = {}
        for k, v in pairs(val) do
            if type(k) == "string" or type(k) == "number" then
                local cleanVal = NetworkGuard.CleanIn(v, depth + 1, player)
                if cleanVal ~= nil then
                    clean[k] = cleanVal
                end
            end
        end
        return clean
    end
    
    return val
end

-- [[ OUTBOUND: SERVER -> CLIENT ]]
function NetworkGuard.SanitizeOutbound(val, depth)
    depth = depth or 0
    if depth > MAX_DEPTH then return nil end
    
    local t = typeof(val)
    
    if t == "table" then
        local clean = {}
        for k, v in pairs(val) do
            local isSafe = true
            
            -- Redact Sensitive Keys (AUDIT LOG)
            if type(k) == "string" then
                local lowerKey = k:lower()
                for _, badWord in ipairs(SENSITIVE_KEYS) do
                    if lowerKey:find(badWord) then
                        clean[k] = "[REDACTED]"
                        isSafe = false
                        -- Kita log di Debug level aja biar gak spam kalau emang intentional
                        Logger:Debug("Redacted", {Key=k})
                        break
                    end
                end
            end
            
            if isSafe then
                clean[k] = NetworkGuard.SanitizeOutbound(v, depth + 1)
            end
        end
        return clean
    end
    
    return val
end

return NetworkGuard
