--!strict
-- @Core: SmartFinder v2.1 (Sanitized)
-- @Role: Recursive Lookup with Telemetry
local CollectionService = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

-- [FIX] Logger Integration
local SmartLogger = Loader.Get("Logger") 

local SmartFinder = {}
local _cache = {}

function SmartFinder.Find(root: Instance, query: string): Instance?
    local cacheKey = root:GetDebugId() .. ":" .. query
    if _cache[cacheKey] then return _cache[cacheKey] end

    -- 1. Direct Attribute (O(1))
    for _, child in ipairs(root:GetDescendants()) do
        if child:GetAttribute("OVHL_ID") == query then
            _cache[cacheKey] = child
            return child
        end
    end

    -- 2. Recursive Name Match
    local found = root:FindFirstChild(query, true)
    if found then
        _cache[cacheKey] = found
        return found
    end

    -- 3. Tag Match
    local tagged = CollectionService:GetTagged(query)
    for _, obj in ipairs(tagged) do
        if obj:IsDescendantOf(root) then
            _cache[cacheKey] = obj
            return obj
        end
    end

    -- [FIX] Dynamic Logging
    local log = SmartLogger.New("UI_FINDER")
    log:Warn("ElementMissing", {
        Query = query,
        Root = root.Name,
        Strategy = "Attribute > Name > Tag"
    })
    
    return nil
end

return SmartFinder
