--!strict
-- @Core: RateLimiter v1.0
-- @Algo: Token Bucket (Allows Burst, Throttles Sustained)
local RateLimiter = {}
RateLimiter.__index = RateLimiter

-- Cache Structure:
-- _buckets[PlayerId][ActionKey] = { Tokens = number, LastUpdate = os.time() }

function RateLimiter.New()
    local self = setmetatable({
        _buckets = {}
    }, RateLimiter)
    return self
end

function RateLimiter:Check(player, actionKey, maxTokens, interval)
    -- 1. Validasi Input
    if not player or not actionKey then return false end
    maxTokens = maxTokens or 10
    interval = interval or 1
    
    local userId = player.UserId
    local now = os.clock() -- Gunakan clock untuk presisi sub-detik
    
    -- 2. Init Player Cache
    if not self._buckets[userId] then
        self._buckets[userId] = {}
    end
    
    -- 3. Init Action Bucket
    local bucket = self._buckets[userId][actionKey]
    if not bucket then
        bucket = {
            Tokens = maxTokens,
            LastUpdate = now
        }
        self._buckets[userId][actionKey] = bucket
    end
    
    -- 4. Refill Logic (Token regeneration)
    local delta = now - bucket.LastUpdate
    local refillRate = maxTokens / interval -- Token per detik
    local tokensToAdd = delta * refillRate
    
    bucket.Tokens = math.min(maxTokens, bucket.Tokens + tokensToAdd)
    bucket.LastUpdate = now
    
    -- 5. Consumption Logic
    if bucket.Tokens >= 1 then
        bucket.Tokens = bucket.Tokens - 1
        return true -- Allowed
    else
        return false -- Rate Limited
    end
end

-- Optional: Cleanup mechanism for disconnected players could go here
function RateLimiter:Cleanup(player)
    self._buckets[player.UserId] = nil
end

return RateLimiter
