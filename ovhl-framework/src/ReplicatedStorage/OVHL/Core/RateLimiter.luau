--!strict
-- @Core: RateLimiter v1.1 (Shared)
-- @Algo: Token Bucket (Allows Burst, Throttles Sustained)
-- @Scope: Client (Debounce) & Server (Security)

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.New()
    local self = setmetatable({
        _buckets = {} -- Cache: [Key] -> {Tokens, LastUpdate}
    }, RateLimiter)
    return self
end

function RateLimiter:Check(context: any, actionKey: string, maxTokens: number, interval: number)
    -- context bisa Player (Server) atau nil/string (Client)
    local contextId = "Global"
    if typeof(context) == "Instance" and context:IsA("Player") then
        contextId = tostring(context.UserId)
    elseif type(context) == "string" then
        contextId = context
    end

    maxTokens = maxTokens or 10
    interval = interval or 1
    
    local now = os.clock()
    
    -- Init Context Group
    if not self._buckets[contextId] then
        self._buckets[contextId] = {}
    end
    
    -- Init Action Bucket
    local bucket = self._buckets[contextId][actionKey]
    if not bucket then
        bucket = {
            Tokens = maxTokens,
            LastUpdate = now
        }
        self._buckets[contextId][actionKey] = bucket
    end
    
    -- Refill Logic
    local delta = now - bucket.LastUpdate
    local refillRate = maxTokens / interval
    local tokensToAdd = delta * refillRate
    
    bucket.Tokens = math.min(maxTokens, bucket.Tokens + tokensToAdd)
    bucket.LastUpdate = now
    
    -- Consume Logic
    if bucket.Tokens >= 1 then
        bucket.Tokens = bucket.Tokens - 1
        return true -- Allowed
    else
        return false -- Limited
    end
end

return RateLimiter
