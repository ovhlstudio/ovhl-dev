-- @Adapter: InternalDB
-- Menyimpan Rank admin custom (selain HD Admin)
local DataStoreService = game:GetService("DataStoreService")
local Store = DataStoreService:GetDataStore("OVHL_Perms_V1")

local DB = {}

function DB.Get(userId)
    local s, r = pcall(function() return Store:GetAsync(tostring(userId)) end)
    if s and r then return r end
    return 0
end

function DB.Set(userId, rank)
    local key = tostring(userId)
    if rank <= 0 then
        pcall(function() Store:RemoveAsync(key) end)
    else
        pcall(function() Store:SetAsync(key, rank) end)
    end
    return true
end

return DB
