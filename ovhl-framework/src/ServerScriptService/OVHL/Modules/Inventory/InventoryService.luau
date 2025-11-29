--!strict
-- @Service: InventoryService v1.0 (Database Driven)
-- @Role: Inventory Logic with Centralized Data
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

local SessionMutex = Loader.Get("SessionMutex") 
local Cfg = require(Loader.Module("Inventory").SharedConfig)
local ItemDB = Loader.Get("ItemDB") -- [NEW] Connect to Database

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

-- Helper: Membuat Item Object dari ID
function Hub:_createItem(id)
    local def = ItemDB[id]
    if not def then return nil end
    
    return {
        Id = id,
        Name = def.Name,
        Rarity = def.Rarity,
        Icon = def.Icon,
        Equipped = false,
        UniqueId = game:GetService("HttpService"):GenerateGUID(false) -- Unique instance ID
    }
end

function Hub:GetItems(player)
	local inv = self:_getInv(player)
	if not inv then return { Success = false, Error = "Data not ready" } end
    
    -- [ZERO HARDCODE] Logic Starter Item
	if #inv == 0 then
        self.Logger:Info("Init", "Giving Starter Items to " .. player.Name)
        
        -- Berikan Item ID 1 (Starter Sword) dari Database
		local starterItem = self:_createItem(1) 
        if starterItem then table.insert(inv, starterItem) end
        
        -- Bonus: Kasih Potion (ID 101) buat test
        local potion = self:_createItem(101)
        if potion then table.insert(inv, potion) end
	end
    
	return { Success = true, Data = inv }
end

function Hub:PerformAction(player, itemId, action)
	local lockSuccess, lockResult = SessionMutex.Run(player.UserId, function()
		local inv = self:_getInv(player)
		if not inv then error("Inventory data unavailable") end

		local targetItem
		for _, v in ipairs(inv) do
            -- Cek ID (Instance ID atau Base ID? Di mock data lama kita pakai Base ID sebagai referensi)
            -- Untuk Enterprise, sebaiknya pakai UniqueId. Tapi untuk backward compatibility UI sekarang,
            -- Kita asumsikan UI mengirim Base ID (angka).
			if v.Id == itemId then targetItem = v; break end
		end

		if not targetItem then error("Item not found") end

		if action == "Equip" then
            -- Logic: Unequip yang lain jika weapon? (Nanti)
			targetItem.Equipped = not targetItem.Equipped
			return { Msg = targetItem.Equipped and "Equipped " .. targetItem.Name or "Unequipped" }
            
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
