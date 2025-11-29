--!strict
-- @Data: ItemDatabase
-- @Role: Central Definition of All Game Items
-- @Usage: Shared by Server (Logic) and Client (UI/Icons)

return {
    -- [1] STARTER ITEMS
    [1] = {
        Name = "Starter Sword",
        Rarity = "Common",
        Type = "Weapon",
        Icon = "rbxassetid://13006407439",
        Description = "A rusty sword for beginners.",
        MaxStack = 1
    },
    
    -- [2-10] WEAPONS
    [2] = {
        Name = "Iron Broadsword",
        Rarity = "Uncommon",
        Type = "Weapon",
        Icon = "rbxassetid://13006407439", -- Placeholder asset
        Description = "Standard issue soldier weapon.",
        MaxStack = 1
    },
    
    -- [100+] CONSUMABLES
    [101] = {
        Name = "Health Potion",
        Rarity = "Common",
        Type = "Consumable",
        Icon = "rbxassetid://13006407439",
        Description = "Restores 50 HP.",
        MaxStack = 99
    }
}
