--!strict
-- @View: NotificationView v0.4.1 (Active Sink Fix)
-- @Role: Render Toast Stack using Enterprise Tokens

local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.Get("API")
local SmartLogger = Loader.Get("Logger")
local Children = UI.Children

-- Telemetry
local UXLog = SmartLogger.New("UX")

-- Default Config
local DEFAULTS = {
	Position = "BottomRight",
	MaxStack = 5,
	ToastWidth = 320,
	Gap = 8,
}

-- [1] EXTRACT THEME TOKENS (WITH SAFETY NET)
local T = UI.Theme
local C = T.Colors
	or {
		Base = { Main = Color3.fromHex("18181b") },
		Primary = { Main = Color3.fromHex("10b981") },
		Error = { Main = Color3.fromHex("ef4444") },
		Neutral = { Main = Color3.fromHex("27272a") },
		BaseContent = { Main = Color3.fromHex("ffffff") },
	}
local R = T.CornerRadius or { Small = 4, Base = 8 }
local S = T.Spacing or {}
local SPACING = {
	Small = S.Small or 4,
	Medium = S.Medium or 8,
	Large = S.Large or 12,
}

return function(scope, props)
	local State = props.State
	local Config = props.Config or {}

	local COLOR_MAP = {
		Success = C.Primary.Main,
		Error = C.Error.Main,
		Warning = C.BaseContent.Main, -- Fallback
		Info = C.Neutral.Main,
	}

	-- Icon Map (Bisa diganti Image ID)
	local ICON_MAP = { Success = "✅", Error = "⛔", Warning = "⚠️", Info = "ℹ️" }

	local function ToastItem(innerScope, data)
		local isVisible = innerScope:Value(false)
		task.spawn(function()
			isVisible:set(true)
			UXLog:Debug("ToastShow", { Type = data.Type, Msg = data.Msg })
		end)

		local typeKey = data.Type or "Info"
		local accent = COLOR_MAP[typeKey] or C.Neutral.Main
		local anim = UI.MotionPresets.SlideRight(innerScope, isVisible)

		return innerScope:New("Frame")({
			Name = "Toast_" .. data.Id,

			-- Layout
			Size = UDim2.fromOffset(Config.ToastWidth or DEFAULTS.ToastWidth, 0),
			AutomaticSize = Enum.AutomaticSize.Y,

			-- Motion
			AnchorPoint = anim.AnchorPoint,
			Position = anim.Position,
			BackgroundTransparency = 1,
			Transparency = anim.Transparency,

			-- [CRITICAL FIX] TOAST SOLIDITY
			-- Agar klik di atas notifikasi tidak tembus ke tombol admin di belakangnya
			Active = true,

			[Children] = {
				-- Card Container
				innerScope:New("Frame")({
					Name = "Card",
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = C.Base.Main,
					BackgroundTransparency = 0.05,

					[Children] = {
						innerScope:New("UICorner")({ CornerRadius = UDim.new(0, R.Base) }),
						innerScope:New("UIStroke")({ Color = accent, Transparency = 0.6, Thickness = 1 }),
						innerScope:New("UIPadding")({
							PaddingTop = UDim.new(0, SPACING.Medium),
							PaddingBottom = UDim.new(0, SPACING.Medium),
							PaddingLeft = UDim.new(0, SPACING.Medium),
							PaddingRight = UDim.new(0, SPACING.Medium),
						}),

						innerScope:New("UIListLayout")({
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, SPACING.Medium),
							VerticalAlignment = Enum.VerticalAlignment.Center,
						}),

						-- Strip Indikator
						innerScope:New("Frame")({
							Name = "Strip",
							Size = UDim2.new(0, 4, 1, 0),
							BackgroundColor3 = accent,
							[Children] = { innerScope:New("UICorner")({ CornerRadius = UDim.new(1, 0) }) },
						}),

						-- Text Content
						innerScope:New("Frame")({
							Size = UDim2.new(1, -12, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							[Children] = {
								innerScope:New("UIListLayout")({
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 2),
								}),
								innerScope:SmartText({
									Text = string.upper(typeKey),
									Variant = "Caption",
									Color = "Neutral",
								}),
								innerScope:SmartText({
									Text = data.Msg or "...",
									Variant = "Body",
									Color = "BaseContent",
									TextWrapped = true,
								}),
							},
						}),
					},
				}),
			},
		})
	end

	-- [ROOT WRAPPER]
	-- Pastikan Layout.luau sudah dibuat agar UI.Layout berfungsi
	-- Jika belum, gunakan fallback UDim2 manual.
	local layoutPos = UDim2.new(1, -24, 1, -24)
	local layoutAnchor = Vector2.new(1, 1)

	if UI.Layout then
		-- Gunakan Layout Helper jika tersedia
		local l = UI.Layout.Place(Config.Position or DEFAULTS.Position, 24)
		layoutPos = l.Position
		layoutAnchor = l.AnchorPoint
	end

	return scope:ScreenWrapper({
		Name = "NotificationLayer",
		Enabled = true,
		Order = 200,

		[Children] = {
			scope:New("Frame")({
				Name = "Container",
				Position = layoutPos,
				AnchorPoint = layoutAnchor,

				Size = UDim2.fromOffset(Config.ToastWidth or DEFAULTS.ToastWidth, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,

				[Children] = {
					scope:New("UIListLayout")({
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, Config.Gap or DEFAULTS.Gap),
					}),

					UI.ForValues(scope, State.Toasts, function(_, innerScope, item)
						return ToastItem(innerScope, item)
					end),
				},
			}),
		},
	})
end
