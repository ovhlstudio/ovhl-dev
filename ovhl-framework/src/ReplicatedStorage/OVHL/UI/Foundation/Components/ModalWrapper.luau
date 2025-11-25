--!strict
-- @Component: ModalWrapper v1.0
-- @Role: Fullscreen Overlay & Input Sink (Mencegah Click-Through)
-- @Standard: Factory Pattern (Dependency Injection)

return function(API)
	local function New(scope, class)
		return API.New(scope, class)
	end

	return function(scope, props)
		local zIndex = props.ZIndex or 100 -- Default tinggi agar di atas UI lain
		local color = props.Color or Color3.new(0, 0, 0)
		local transparency = props.Transparency or 0.6

		return New(scope, "Frame")({
			Name = props.Name or "ModalOverlay",

			-- Fullscreen
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),

			BackgroundColor3 = color,
			BackgroundTransparency = transparency,
			ZIndex = zIndex,

			-- [CRITICAL FIX] Input Sinking
			-- Membuat frame ini 'padat' bagi mouse, sehingga klik tidak tembus ke belakang
			Active = true,
			Interactable = true,

			-- Opsional: Tutup modal saat overlay diklik (Klik luar window)
			[API.OnEvent("Activated")] = function()
				if props.OnOverlayClick then
					props.OnOverlayClick()
				end
			end,

			[API.Children] = props[API.Children],
		})
	end
end
