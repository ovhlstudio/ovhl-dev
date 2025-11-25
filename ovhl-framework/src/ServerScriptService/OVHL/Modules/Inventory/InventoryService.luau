--!strict
-- @Service: InventoryService v0.2.0 (Secured)
-- @Role: Inventory Logic with Mutex & DataStore
-- @Mandate: Mandat 5 (Data Integrity)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local SessionMutex = require(ServerScriptService.OVHL.Core.SessionMutex)

-- Load Config
local Cfg = require(Loader.Module("Inventory").SharedConfig)

local Hub = {}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("INVENTORY")
	self.Network = ctx.Network

	-- Dependency ke DataManager (Pastikan DataManagerService sudah di-load Kernel)
	-- Kita akses via Context Services
	self.DataManager = ctx.Services.DataManagerService

	if not self.DataManager then
		self.Logger:Error("Dependency", "DataManagerService Not Found!")
	end

	-- Register Routes
	self.Network:Register("Inventory", Cfg.Network)
	self.Network:Bind("Inventory", self)

	self.Logger:Info("System", "Inventory Logic Online (Secured)")
end

function Hub:Start()
	-- Event Listeners if needed
end

-- [[ HELPER ]]
function Hub:_getInv(player)
	if not self.DataManager then
		return nil
	end
	local data = self.DataManager:Get(player)
	if not data then
		return nil
	end

	-- Pastikan tabel Inventory ada
	if not data.Inventory then
		data.Inventory = {}
	end
	return data.Inventory
end

-- [[ API METHODS ]]

function Hub:GetItems(player)
	local inv = self:_getInv(player)
	if not inv then
		return { Success = false, Error = "Data not ready" }
	end

	-- [DEBUG ONLY] Jika inventory kosong, kasih starter pack (untuk tes v0.2.0)
	if #inv == 0 then
		table.insert(
			inv,
			{ Id = 1, Name = "Starter Sword", Rarity = "Common", Equipped = false, Icon = "rbxassetid://13006407439" }
		)
		table.insert(
			inv,
			{ Id = 2, Name = "Apple", Rarity = "Common", Equipped = false, Icon = "rbxassetid://12905487363" }
		)
		self.Logger:Warn("Debug", "Gave Starter Items to " .. player.Name)
	end

	return { Success = true, Data = inv }
end

function Hub:PerformAction(player, itemId, action)
	-- 1. MUTEX LOCK (Anti-Spam / Race Condition Guard)
	local lockSuccess, lockResult = SessionMutex.Run(player.UserId, function()
		-- A. Validasi Data
		local inv = self:_getInv(player)
		if not inv then
			error("Inventory data unavailable")
		end

		local targetItem
		for _, v in ipairs(inv) do
			if v.Id == itemId then
				targetItem = v
				break
			end
		end

		if not targetItem then
			error("Item not found in inventory")
		end

		-- B. Logika Bisnis
		if action == "Equip" then
			targetItem.Equipped = not targetItem.Equipped
			self.Logger:Info("Action", { User = player.Name, Type = action, Item = targetItem.Name })
			return { Msg = targetItem.Equipped and "Equipped" or "Unequipped" }
		elseif action == "Drop" then
			-- Hapus item dari table (harus cari index lagi untuk safety)
			for i, v in ipairs(inv) do
				if v.Id == itemId then
					table.remove(inv, i)
					break
				end
			end
			self.Logger:Info("Action", { User = player.Name, Type = action, Item = targetItem.Name })
			return { Msg = "Item dropped" }
		else
			error("Unknown Action: " .. tostring(action))
		end
	end)

	-- 2. RETURN RESULT
	if lockSuccess then
		return { Success = true, Data = lockResult }
	else
		-- Lock failed (Busy) atau Error di dalam logic
		self.Logger:Warn("ActionFail", { User = player.Name, Err = lockResult })
		return { Success = false, Error = tostring(lockResult) }
	end
end

return Hub
