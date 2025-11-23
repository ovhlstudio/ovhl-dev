--!strict
-- @Config: SystemPanelConfig
-- @Role: Single Source of Truth untuk Framework Panel
-- @Standard: OVHL Enterprise

return {
	Meta = {
		Name = "FrameworkPanel",
		Version = "1.0.0",
	},

	-- Konfigurasi Topbar Icon
	Topbar = {
		Enabled = true,
		Text = "PANEL",
		Icon = "rbxassetid://6022668961", -- Settings Icon
		Order = 99,
		Permission = 3, -- Minimal Admin (3) untuk melihat tombol ini
		Shortcut = Enum.KeyCode.F4,
	},

	-- Konfigurasi UI Window
	UI = {
		Title = "OVHL COMMAND CENTER",
		Size = { X = 800, Y = 500 },
		SidebarWidth = 200,
		Transition = "SlideFromRight",
	},

	-- Daftar Menu (Data Driven View)
	Menus = {
		{ Id = "Dashboard", Label = "🏠 Dashboard", Order = 1 },
		{ Id = "Permission", Label = "👥 Permission", Order = 2 },
		{ Id = "Logger", Label = "🎛️ Logger", Order = 3 },
		{ Id = "Network", Label = "📡 Network", Order = 4 },
	},
}
