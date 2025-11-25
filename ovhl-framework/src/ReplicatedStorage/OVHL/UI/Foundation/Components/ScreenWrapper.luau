--!strict
-- @Component: ScreenWrapper
-- @Standard: Explicit API Usage
return function(API)
	local Themer = API.Themer
	local Theme = API.Theme
	-- [FIX] Ambil AutoScaler langsung dari Onyx, jangan via scope
	local AutoScaler = API.Onyx.Components.AutoScaler or API.Onyx.AutoScaler

	return function(scope, props)
		local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

		return API.New(scope, "ScreenGui")({
			Name = props.Name or "OVHL_Screen",
			Parent = PlayerGui,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = props.Order or 10,
			Enabled = props.Enabled,

			[API.Children] = {
				-- [FIX] Explicit Call: AutoScaler(scope, props)
				-- Onyx components biasanya dipanggil sebagai fungsi: Component(scope, props)
				AutoScaler(scope, {
					Name = "ResponsiveCanvas",
					BaseResolution = Vector2.new(1280, 720),
					MinScale = 0.5,
					MaxScale = 1.5,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,

					[API.Children] = {
						Themer.Theme:is(Theme):during(function()
							return API.New(scope, "Frame")({
								Name = "ProviderScope",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								Active = false,
								[API.Children] = props[API.Children],
							})
						end),
					},
				}),
			},
		})
	end
end
