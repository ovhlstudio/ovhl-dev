--!strict
-- @Service: InventoryService v0.2.2 (Clean Loader)
-- @Role: Inventory Logic

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

-- [CLEAN IMPORT] via Loader
local SessionMutex = Loader.Get("SessionMutex") 
local Cfg = require(Loader.Module("Inventory").SharedConfig)

local Hub = {}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("INVENTORY")
	self.Network = ctx.Network
	self.DataManager = ctx.Services.DataManagerService

	if not self.DataManager then self.Logger:Error("Dependency", "DataManagerService Not Found!") end

	self.Network:Register("Inventory", Cfg.Network)
	self.Network:Bind("Inventory", self)
end

function Hub:Start() end

function Hub:_getInv(player)
	if not self.DataManager then return nil end
	local data = self.DataManager:Get(player)
	if not data then return nil end
	if not data.Inventory then data.Inventory = {} end
	return data.Inventory
end

function Hub:GetItems(player)
	local inv = self:_getInv(player)
	if not inv then return { Success = false, Error = "Data not ready" } end
    -- Debug Starter Items
	if #inv == 0 then
		table.insert(inv, { Id = 1, Name = "Starter Sword", Rarity = "Common", Equipped = false, Icon = "rbxassetid://13006407439" })
	end
	return { Success = true, Data = inv }
end

function Hub:PerformAction(player, itemId, action)
    -- Using SessionMutex from Loader
	local lockSuccess, lockResult = SessionMutex.Run(player.UserId, function()
		local inv = self:_getInv(player)
		if not inv then error("Inventory data unavailable") end

		local targetItem
		for _, v in ipairs(inv) do
			if v.Id == itemId then targetItem = v; break end
		end

		if not targetItem then error("Item not found") end

		if action == "Equip" then
			targetItem.Equipped = not targetItem.Equipped
			return { Msg = targetItem.Equipped and "Equipped" or "Unequipped" }
		elseif action == "Drop" then
			for i, v in ipairs(inv) do
				if v.Id == itemId then table.remove(inv, i); break end
			end
			return { Msg = "Item dropped" }
		else
			error("Unknown Action")
		end
	end)

	if lockSuccess then
		return { Success = true, Data = lockResult }
	else
		return { Success = false, Error = tostring(lockResult) }
	end
end

return Hub
