-- @Component: ScreenWrapper (Correctly Centered AutoScaler)
return function(API)
	local Themer = API.Themer
	local Theme = API.Theme

	return function(scope, props)
		local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

		return scope:New("ScreenGui")({
			Name = props.Name or "OVHL_Screen",
			Parent = PlayerGui,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = props.Order or 10,
			Enabled = props.Enabled,

			[API.Children] = {
				scope:AutoScaler({
					Name = "ResponsiveCanvas",
					BaseResolution = Vector2.new(1280, 720),
					MinScale = 0.5,
					MaxScale = 1.5,

					-- [CRITICAL FIX]
					-- AutoScaler SENDIRI harus di-center ke layar.
					-- Jika tidak, saat scale < 1, dia akan lari ke pojok kiri atas.
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),

					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,

					[API.Children] = {
						Themer.Theme:is(Theme):during(function()
							return scope:New("Frame")({
								Name = "ProviderScope",
								-- Child juga center (redundant tapi aman)
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
