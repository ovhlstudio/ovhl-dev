--!strict
-- @System: TestRunner (Client Side)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	return
end

task.defer(function()
	task.wait(3) -- Client biasanya butuh waktu lebih lama buat loading UI

	print("\n🧪 [CLIENT] STARTING TEST RUNNER...")

	-- 1. Load TesEZ
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local TesEZ

	pcall(function()
		TesEZ = Loader.Get("TestEZ")
	end)

	if not TesEZ then
		return
	end -- Silent fail kalau gak ada (biasanya udah teriak di server)

	-- 2. Cari Folder Test di PlayerScripts
	local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	local ClientTests = PlayerScripts:WaitForChild("Tests", 10)

	local testRoots = {}
	if ClientTests then
		table.insert(testRoots, ClientTests)
	end

	-- Optional: Kalau mau ngetes Shared Logic (ReplicatedStorage) di client juga
	-- table.insert(testRoots, ReplicatedStorage:WaitForChild("Tests"))

	if #testRoots == 0 then
		return -- Gak ada test client, skip aja
	end

	-- 3. JALANIN TES!
	local results = TesEZ.TestBootstrap:run(testRoots)

	if results.failureCount > 0 then
		warn("❌ [CLIENT] FAILED: " .. results.failureCount .. " tests broken.")
	else
		print("✅ [CLIENT] SUCCESS: UI & Controllers secure.")
	end
end)
