--!strict
-- @Mock: DataStore
local MockDS = {}
MockDS.__index = MockDS
function MockDS.new() return setmetatable({_d={}}, MockDS) end
function MockDS:GetAsync(k) return self._d[k] end
function MockDS:SetAsync(k, v) self._d[k] = v end
function MockDS:UpdateAsync(k, cb) 
    local v = cb(self._d[k])
    if v~=nil then self._d[k]=v end
    return v
end
return MockDS
