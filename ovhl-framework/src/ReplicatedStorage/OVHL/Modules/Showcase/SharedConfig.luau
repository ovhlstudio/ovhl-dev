--!strict
-- @Config: Showcase v3.1 (Ping Request)
return {
    Meta = { Name = "Showcase", Version = "3.1.0" },
    
    Topbar = {
        Enabled = true, Text = "SHOWCASE", Icon = "rbxassetid://11422153282",
        Order = 999, Permission = 0, Shortcut = Enum.KeyCode.F4
    },

    Layout = {
        DefaultSize = { X = 1000, Y = 800 },
        MinSize = { X = 500, Y = 500 },
        StartAnchor = "Center", Transition = "Bouncy", Resizable = true
    },

    UI = {
        Title = "OVHL ENTERPRISE SUITE",
        Subtitle = "Component Gallery & System Monitor"
    },

    Navigation = {
        { Id = "Dashboard", Label = "Dashboard", Icon = "Settings",  Desc = "Sidebar & Data", Order = 1 },
        { Id = "Grid",      Label = "Inventory", Icon = "Inventory", Desc = "Grid & Scrolling", Order = 2 },
        { Id = "Form",      Label = "Input Form",Icon = "Edit",      Desc = "Validation",     Order = 3 },
        { Id = "Split",     Label = "Trading",   Icon = "Search",    Desc = "Layout Split",   Order = 4 },
        { Id = "Feedback",  Label = "UX Labs",   Icon = "Success",   Desc = "Toasts & Modals",Order = 5 },
        { Id = "Physics",   Label = "Layout",    Icon = "Home",      Desc = "9-Slice Anchor", Order = 6 },
    },

    Security = {
        -- Client-side debounce (Visual only)
        ButtonSpamLimit = { Max = 5, Interval = 1 } 
    },
    
    -- [NETWORK RULES]
    Network = {
        Requests = {
            -- Kita ubah Ping jadi Request dengan Limit KETAT
            -- Max 1 kali per 2 detik. Jika spam, Server akan tolak (429).
            Ping = { 
                RateLimit = { Max = 1, Interval = 2 },
                Args = {} 
            }
        },
        Events = {}
    }
}
