--!strict
-- @Controller: SandboxController (DEBUG ONLY - FIXED)
-- @Role: Isolasi Test Masalah "Ghost Click"
-- @Mandate: Pure Fusion 0.3 Compliance.

local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework)

local UI = Loader.Get("API")
local Fusion = UI.Fusion
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local Ctrl = OVHL.CreateController({
	Name = "SandboxDebug",
})

function Ctrl:Init()
	self.Logger:Info("Init", "Starting Sandbox UI Test...")

	local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	-- [FIX] Buat Scope Fusion
	local scope = Fusion.scoped(Fusion)
	self._scope = scope -- Simpan biar gak ke-garbage collect

	-- 1. RAW SCREEN GUI (Tanpa ScreenWrapper)
	local Screen = scope:New("ScreenGui")({
		Name = "OVHL_Sandbox_Debug",
		Parent = PlayerGui,
		DisplayOrder = 20000, -- Paling atas
		ResetOnSpawn = false,

		[Children] = {

			-- 2. RAW FRAME CONTAINER (The Test Subject)
			scope:New("Frame")({
				Name = "TestWindow",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(500, 400),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),

				-- [TEST VARIABLE] Active = true Manual
				Active = true,

				[Children] = {
					-- Debug Text
					scope:New("TextLabel")({
						Text = "AREA KOSONG (HARUSNYA PANAH BIASA)",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						TextColor3 = Color3.new(1, 1, 1),
						TextTransparency = 0.8,
						ZIndex = 1,
					}),

					-- HEADER (Manual)
					scope:New("Frame")({
						Name = "HeaderRaw",
						Size = UDim2.new(1, 0, 0, 50),
						BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- Merah
						Active = true, -- Header Active

						[Children] = {
							scope:New("TextLabel")({
								Text = "DEBUG WINDOW (RAW)",
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								TextColor3 = Color3.new(1, 1, 1),
								Font = Enum.Font.GothamBold,
								TextSize = 24,
							}),

							-- Close Button
							scope:New("TextButton")({
								Name = "CloseBtn",
								Text = "X",
								Size = UDim2.fromOffset(40, 40),
								Position = UDim2.new(1, -45, 0, 5),
								BackgroundColor3 = Color3.new(0, 0, 0),
								TextColor3 = Color3.new(1, 1, 1),

								[OnEvent("Activated")] = function()
									print("Close Clicked (Valid)")
									-- Hapus GUI manual untuk test
									scope:doCleanup()
								end,
							}),
						},
					}),

					-- BODY CONTENT
					scope:New("Frame")({
						Name = "BodyRaw",
						Position = UDim2.fromOffset(0, 50),
						Size = UDim2.new(1, 0, 1, -50),
						BackgroundColor3 = Color3.fromRGB(60, 60, 60),
						Active = true, -- Body Active

						[Children] = {
							scope:New("UIListLayout")({
								Padding = UDim.new(0, 20),
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),

							-- Tombol Test
							scope:New("TextButton")({
								Name = "TestButton1",
								Text = "SAYA TOMBOL (HARUS TANGAN)",
								Size = UDim2.fromOffset(200, 50),
								BackgroundColor3 = Color3.fromRGB(0, 255, 0),
							}),

							-- Gambar Test
							scope:New("ImageButton")({
								Name = "TestImage1",
								Size = UDim2.fromOffset(100, 100),
								BackgroundColor3 = Color3.fromRGB(0, 0, 255),
								Image = "rbxassetid://13006407439",
							}),
						},
					}),
				},
			}),
		},
	})
end

function Ctrl:Shutdown()
	if self._scope then
		self._scope:doCleanup()
		self._scope = nil
	end
end

return Ctrl
