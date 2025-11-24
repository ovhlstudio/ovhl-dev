--!strict
-- @Mock: Player
local MockPlayer = {}
MockPlayer.__index = MockPlayer
function MockPlayer.new(userId, name) 
	local self = setmetatable({UserId=userId or 1, Name=name or "TestPlr", Parent=game.Players, _attr={}}, MockPlayer) 
	return self 
end
function MockPlayer:GetAttribute(k) return self._attr[k] end
function MockPlayer:SetAttribute(k, v) self._attr[k] = v end
function MockPlayer:Kick() end
function MockPlayer:IsDescendantOf(p) return self.Parent == p end
return MockPlayer
