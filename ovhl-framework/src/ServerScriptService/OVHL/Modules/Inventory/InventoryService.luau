-- @Service: InventoryService
-- @Standard: OVHL v0.1.1 (Correct Bridge API)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Cfg = Loader.Module("Inventory", "SharedConfig")

local Hub = {}

local MOCK_ITEMS = {
	{ Id = 1, Name = "ini pedang mahal", Rarity = "Epic", Count = 1 },
	{ Id = 2, Name = "Health Potion", Rarity = "Common", Count = 5 },
	{ Id = 3, Name = "Mana Crystal", Rarity = "Rare", Count = 2 },
	{ Id = 4, Name = "Legendary Orb", Rarity = "Legendary", Count = 1 },
	{ Id = 5, Name = "Scrap Metal", Rarity = "Common", Count = 10 },
	{ Id = 6, Name = "Mythic Crown", Rarity = "Mythic", Count = 1 },
}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("INVENTORY")
	self.Network = ctx.Network
	self.RateLimitCache = {}

	-- Register Handler using Bridge v0.1.1 API
	self.Handler = self.Network:Register("Inventory", {})

	self.Handler.OnInvoke(function(player, requestName, ...)
		if requestName == "GetItems" then
			return self:GetItems(player)
		end
		return { Success = false, Error = "Unknown Request" }
	end)

	self.Logger:Info("System", "Inventory Network Active.")
end

function Hub:Start() end

function Hub:GetItems(player)
	local userId = player.UserId
	local currentTime = os.time()
	local lastFetch = self.RateLimitCache[userId] or 0
	local rateLimitSeconds = 1

	if currentTime - lastFetch < rateLimitSeconds then
		return { Success = false, Error = "RateLimited", Wait = rateLimitSeconds - (currentTime - lastFetch) }
	end

	self.RateLimitCache[userId] = currentTime

	self.Logger:Info("Data", { User = player.Name, Action = "FetchItems" })

	return { Success = true, Data = MOCK_ITEMS }
end

return Hub
