--!strict
-- @System: TestRunner (Server Side)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- Cuma jalan di Studio biar gak ganggu Production game
if not RunService:IsStudio() then
	return
end

task.defer(function()
	-- Tunggu sebentar biar loading game/plugin selesai dulu
	task.wait(2)

	print("\n🧪 [SERVER] STARTING TEST RUNNER...")

	-- 1. Load TesEZ (Pake Loader framework lu biar konsisten)
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local TesEZ

	pcall(function()
		TesEZ = Loader.Get("TestEZ") -- Atau require(ReplicatedStorage.Packages.TestEZ)
	end)

	if not TesEZ then
		warn("⚠️ [SERVER] TesEZ not found! Please run 'wally install'.")
		return
	end

	-- 2. Tentukan Folder Target (Sesuai Mapping Rojo yang baru)
	-- Kita pake WaitForChild biar aman kalau loadingnya telat dikit
	local testRoots = {
		ReplicatedStorage:WaitForChild("Tests", 10), -- Shared Tests
		ServerScriptService:WaitForChild("Tests", 10), -- Server Tests
	}

	-- Filter kalau foldernya ternyata kosong/gak ke-sync
	local validRoots = {}
	for _, folder in ipairs(testRoots) do
		if folder then
			table.insert(validRoots, folder)
		else
			warn("⚠️ [SERVER] Missing Test Folder (Check Rojo Mapping)")
		end
	end

	if #validRoots == 0 then
		warn("⚠️ [SERVER] No tests found to run.")
		return
	end

	-- 3. JALANIN TES!
	print("📂 [SERVER] Scanning folders: " .. #validRoots)
	local results = TesEZ.TestBootstrap:run(validRoots)

	-- 4. Laporan
	if results.failureCount > 0 then
		warn("❌ [SERVER] FAILED: " .. results.failureCount .. " tests broken.")
	else
		print("✅ [SERVER] SUCCESS: All systems normal.")
	end
end)
