-- @Feature: Inventory Config
-- @Standard: OVHL v0.1.1

return {
    Meta = {
        Name = "Inventory",
        Type = "Feature",
        Version = "3.2.0",
    },

    Topbar = {
        Enabled = true,
        Text = "BAG",
        Icon = "rbxassetid://96226541857519",
        Shortcut = Enum.KeyCode.B,
        Order = 1,
        Permission = 0,
    },

    Layout = {
        Mode = "Grid", -- Options: "Grid" | "List"
        
        Grid = {
            CellSize = {X = 100, Y = 120},
            Gap = {X = 10, Y = 10},
            Sort = Enum.SortOrder.LayoutOrder
        },
        
        List = {
            Height = 60,
            Gap = 5,
            Padding = 8
        }
    },

    UI = {
        Title = "MY BACKPACK",
        EmptyState = "No items found.",
        MaxSlots = 50,

        RarityColors = {
            Common = Color3.fromHex("94A3B8"),
            Uncommon = Color3.fromHex("10B981"),
            Rare = Color3.fromHex("3B82F6"),
            Epic = Color3.fromHex("8B5CF6"),
            Legendary = Color3.fromHex("F59E0B"),
            Mythic = Color3.fromHex("EF4444"),
        },
    },

    Network = {
        Route = "Inventory",
        Requests = {},
    },
}
