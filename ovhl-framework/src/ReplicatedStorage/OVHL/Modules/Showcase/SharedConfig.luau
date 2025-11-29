--!strict
-- @Config: Showcase v3.0 (True SSOT)
-- @Role: Mengendalikan SELURUH aspek Visual & Logic Module
return {
	Meta = {
		Name = "Showcase",
		Version = "3.0.0",
	},

	-- [1] ENTRY POINT
	Topbar = {
		Enabled = true,
		Text = "SHOWCASE",
		Icon = "rbxassetid://11422153282",
		Order = 999,
		Permission = 0,
		Shortcut = Enum.KeyCode.F4, -- [NEW] Keybind
	},

	-- [2] WINDOW PHYSICS
	Layout = {
		DefaultSize = { X = 1000, Y = 800 }, -- [NEW] Setup Size disini
		MinSize = { X = 500, Y = 500 },
		StartAnchor = "Center", -- Mengacu pada LayoutUtil preset
		Transition = "Bouncy", -- Mengacu pada MotionUtil preset
		Resizable = true,
	},

	-- [3] UI TEXT & THEME
	UI = {
		Title = "OVHL ENTERPRISE SUITE",
		Subtitle = "Component Gallery & System Monitor",
	},

	-- [4] NAVIGATION DATA (View Generation Source)
	-- HomeView akan me-looping table ini untuk membuat Menu Grid
	Navigation = {
		{ Id = "Dashboard", Label = "Dashboard", Icon = "Settings", Desc = "Sidebar & Data", Order = 1 },
		{ Id = "Grid", Label = "Inventory", Icon = "Inventory", Desc = "Grid & Scrolling", Order = 2 },
		{ Id = "Form", Label = "Input Form", Icon = "Edit", Desc = "Validation", Order = 3 },
		{ Id = "Split", Label = "Trading", Icon = "Search", Desc = "Layout Split", Order = 4 },
		{ Id = "Feedback", Label = "UX Labs", Icon = "Success", Desc = "Toasts & Modals", Order = 5 },
		{ Id = "Physics", Label = "Layout", Icon = "Home", Desc = "9-Slice Anchor", Order = 6 },
	},

	-- [5] SECURITY LOGIC
	Security = {
		ButtonSpamLimit = { Max = 5, Interval = 1 },
	},
}
