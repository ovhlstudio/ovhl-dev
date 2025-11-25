--!strict
-- @Component: SmartWindow v0.3.0 (Input Hardened)
-- @Role: Standard Window with Input Sink (Anti-Ghost)

-- [DI PATTERN] Menerima API via Parameter (Anti Circular Dependency)
return function(API)
	local Theme = API.Theme
	local Assets = API.Assets
	local MotionPresets = API.MotionPresets
	local Children = API.Children

	local function New(scope, class)
		return API.New(scope, class)
	end

	return function(scope, props)
		local isVisible = props.Visible
		if isVisible == nil then
			isVisible = scope:Value(true)
		end

		local styleName = props.Transition or "PopUp"
		local presetFunc = MotionPresets[styleName] or MotionPresets.PopUp
		local animProps = presetFunc(scope, isVisible)

		local isRendering = API.Computed(scope, function(use)
			return use(animProps.Transparency) < 0.99
		end)

		-- [[ ROOT WINDOW ]]
		return New(scope, "Frame")({
			Name = "WindowFrame",
			AnchorPoint = animProps.AnchorPoint,
			Position = animProps.Position,
			Size = props.Size or UDim2.fromOffset(500, 400),

			-- [CRITICAL FIX] ROOT INPUT SINK
			-- Menjadikan seluruh area window 'padat' terhadap raycast mouse.
			-- Mencegah klik tembus ke objek di belakang (World/UI Lain).
			Active = true,

			BackgroundTransparency = 1,
			Visible = isRendering,

			[Children] = {
				New(scope, "UIScale")({ Scale = animProps.Scale }),

				-- VISUAL LAYER
				New(scope, "CanvasGroup")({
					Name = "Canvas",
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Theme.Colors.Base.Main,
					GroupTransparency = animProps.Transparency,

					-- Active dimatikan di CanvasGroup untuk menghindari bug engine Roblox
					-- Kita mengandalkan Active di WindowFrame (Parent)
					Active = false,
					ZIndex = 2,

					[Children] = {
						New(scope, "UICorner")({ CornerRadius = UDim.new(0, Theme.CornerRadius.Large) }),
						New(scope, "UIStroke")({ Color = Theme.Colors.Neutral.Main, Thickness = 1 }),

						-- [[ HEADER ]]
						New(scope, "Frame")({
							Name = "Header",
							Size = UDim2.new(1, 0, 0, 48),
							BackgroundTransparency = 1,

							[Children] = {
								New(scope, "UIPadding")({
									PaddingLeft = UDim.new(0, 16),
									PaddingRight = UDim.new(0, 16),
								}),
								New(scope, "UIListLayout")({
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Right,
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),

								-- TITLE
								New(scope, "Frame")({
									Name = "TitleContainer",
									Size = UDim2.new(1, -30, 1, 0),
									BackgroundTransparency = 1,
									LayoutOrder = 1,
									[Children] = {
										New(scope, "UIListLayout")({ VerticalAlignment = Enum.VerticalAlignment.Center }),
										scope:SmartText({
											Variant = "Header",
											Text = props.Title or "Window",
											Size = 20,
										}),
									},
								}),

								-- CLOSE BUTTON
								New(scope, "ImageButton")({
									Name = "CloseButton",
									LayoutOrder = 2,
									Size = UDim2.fromOffset(24, 24),
									BackgroundTransparency = 1,
									Image = Assets.Icons.Close,
									ImageColor3 = Theme.Colors.BaseContent.Main,
									[API.OnEvent("Activated")] = props.OnClose,
								}),
							},
						}),

						-- [[ BODY ]]
						New(scope, "Frame")({
							Name = "Body",
							Position = UDim2.fromOffset(0, 48),
							Size = UDim2.new(1, 0, 1, -48),
							BackgroundTransparency = 1,
							[Children] = props[Children],
						}),
					},
				}),
			},
		})
	end
end
