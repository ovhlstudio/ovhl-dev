--!strict
-- @Feature: Inventory Config
-- @Standard: OVHL v0.2.1 (Action Ready)

return {
    Meta = {
        Name = "Inventory",
        Type = "Feature",
        Version = "4.2.0",
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
        Mode = "Grid",
        Grid = {
            CellSize = {X = 150, Y = 230}, 
            Gap = {X = 12, Y = 12},
            Sort = Enum.SortOrder.LayoutOrder
        }
    },

    UI = {
        Title = "MY BACKPACK",
        EmptyState = "No items found.",
        Transition = "PopUp",
        
        RarityColors = {
            Common    = Color3.fromHex("94A3B8"),
            Uncommon  = Color3.fromHex("10B981"),
            Rare      = Color3.fromHex("3B82F6"),
            Epic      = Color3.fromHex("8B5CF6"),
            Legendary = Color3.fromHex("F59E0B"),
            Mythic    = Color3.fromHex("EF4444"),
        },
        
        Actions = {
            { Id = "Equip", Label = "EQUIP", Style = "Primary" },
            { Id = "Drop",  Label = "DROP",  Style = "Danger" }
        }
    },

    Network = {
        Route = "Inventory",
        Requests = {
            GetItems = { 
                RateLimit = { Max = 5, Interval = 1 }, 
                Args = {} 
            },
            -- [NEW] Endpoint untuk Aksi
            PerformAction = {
                RateLimit = { Max = 4, Interval = 1 }, -- Strict Security via Bridge
                Args = { {name="itemId", type="any"}, {name="action", type="string"} }
            }
        },
        Events = {}
    },
}
