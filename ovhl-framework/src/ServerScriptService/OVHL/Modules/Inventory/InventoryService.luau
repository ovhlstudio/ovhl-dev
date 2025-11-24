--!strict
-- @Service: InventoryService (REFACTORED: Scoped Data)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

-- [FIX] Tambahkan require() disini!
local Cfg = require(Loader.Module("Inventory").SharedConfig)

local Hub = {}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("INVENTORY")
	self.Network = ctx.Network

	-- [FIX] Move Data from Global to Instance
	self._mockStorage = {
		{ Id = 1, Name = "Excalibur", Rarity = "Epic", Count = 1, Icon = "rbxassetid://13006407439", Equipped = false },
		{
			Id = 2,
			Name = "Health Potion",
			Rarity = "Common",
			Count = 5,
			Icon = "rbxassetid://12905487363",
			Equipped = false,
		},
		{ Id = 3, Name = "Mana Crystal", Rarity = "Rare", Count = 2, Icon = "", Equipped = false },
		{ Id = 4, Name = "God Apple", Rarity = "Legendary", Count = 1, Icon = "", Equipped = false },
		{
			Id = 5,
			Name = "Rusty Dagger",
			Rarity = "Common",
			Count = 1,
			Icon = "rbxassetid://13006407439",
			Equipped = false,
		},
	}

	-- Sekarang Cfg.Network ada isinya, jadi Remote bakal dibuat!
	self.Network:Register("Inventory", Cfg.Network)
	self.Network:Bind("Inventory", self)

	self.Logger:Info("System", "Inventory Active (Mock Storage)")
end

function Hub:Start() end

function Hub:GetItems(player)
	-- Simulated fetch per player
	self.Logger:Debug("Data", { User = player.Name, Op = "Fetch" })
	return { Success = true, Data = self._mockStorage }
end

function Hub:PerformAction(player, itemId, action)
	local targetItem, index
	for i, v in ipairs(self._mockStorage) do
		if v.Id == itemId then
			targetItem = v
			index = i
			break
		end
	end

	if not targetItem then
		-- [FIX] Sanitized Error
		return { Success = false, Error = "Item unavailable" }
	end

	if action == "Equip" then
		targetItem.Equipped = not targetItem.Equipped
		self.Logger:Info("Action", { User = player.Name, Type = action, Item = targetItem.Name })
		return { Success = true, Data = { Msg = targetItem.Equipped and "Equipped" or "Unequipped" } }
	elseif action == "Drop" then
		table.remove(self._mockStorage, index)
		self.Logger:Info("Action", { User = player.Name, Type = action, Item = targetItem.Name })
		return { Success = true, Data = { Msg = "Item dropped" } }
	end

	return { Success = false, Error = "Invalid Action" }
end

return Hub
