--!strict
-- @Service: InventoryService
-- @Standard: OVHL v0.2.2 (Protocol Compliant)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Cfg = Loader.Module("Inventory").SharedConfig

local Hub = {}

-- Mock Database
local MOCK_ITEMS = {
	{ Id = 1, Name = "Excalibur", Rarity = "Epic", Count = 1, Icon = "rbxassetid://13006407439", Equipped = false },
	{ Id = 2, Name = "Health Potion", Rarity = "Common", Count = 5, Icon = "rbxassetid://12905487363", Equipped = false },
	{ Id = 3, Name = "Mana Crystal", Rarity = "Rare", Count = 2, Icon = "", Equipped = false },
	{ Id = 4, Name = "God Apple", Rarity = "Legendary", Count = 1, Icon = "", Equipped = false },
    { Id = 5, Name = "Rusty Dagger", Rarity = "Common", Count = 1, Icon = "rbxassetid://13006407439", Equipped = false },
}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("INVENTORY")
	self.Network = ctx.Network
	
	self.Handler = self.Network:Register("Inventory", Cfg.Network)
    self.Network:Bind("Inventory", self)

	self.Logger:Info("System", "Inventory Network Active.")
end

function Hub:Start() end

function Hub:GetItems(player)
	self.Logger:Info("Data", { User = player.Name, Action = "FetchItems", Count = #MOCK_ITEMS })
	return { Success = true, Data = MOCK_ITEMS }
end

function Hub:PerformAction(player, itemId, action)
    local targetItem, index
    for i, v in ipairs(MOCK_ITEMS) do
        if v.Id == itemId then targetItem = v; index = i; break end
    end
    
    if not targetItem then return { Success = false, Error = "Item not found" } end
    
    -- [FIX] Return harus dibungkus Data = { ... }
    
    if action == "Equip" then
        targetItem.Equipped = not targetItem.Equipped
        self.Logger:Info("Action", { User = player.Name, Act = action, Item = targetItem.Name, State = targetItem.Equipped })
        
        return { 
            Success = true, 
            Data = { Msg = targetItem.Equipped and "Equipped" or "Unequipped" } 
        }
        
    elseif action == "Drop" then
        table.remove(MOCK_ITEMS, index)
        self.Logger:Info("Action", { User = player.Name, Act = action, Item = targetItem.Name })
        
        return { 
            Success = true, 
            Data = { Msg = "Dropped " .. targetItem.Name } 
        }
    end
    
    return { Success = false, Error = "Unknown Action" }
end

return Hub
