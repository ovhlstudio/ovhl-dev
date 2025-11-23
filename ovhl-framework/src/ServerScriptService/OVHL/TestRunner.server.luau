--!strict
-- @System: TestRunner (Studio Only)
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then return end

task.defer(function()
	task.wait(1)
	print("\n🧪 OVHL UNIT TESTS STARTING...")
	
	-- Try Load TestEZ via Loader OR Direct Path
	local Loader = require(RS.OVHL.Core.Loader)
	local TestEZ
    pcall(function() TestEZ = Loader.Pkg("TestEZ") end)
    if not TestEZ then 
        -- Fallback for old Loader or direct usage
        pcall(function() TestEZ = require(RS.Packages.TestEZ) end)
    end

	if TestEZ then
		local results = TestEZ.TestBootstrap:run({ RS.OVHL, SS.OVHL })
		if results.failureCount > 0 then warn("❌ TESTS FAILED: "..results.failureCount)
		else print("✅ ALL TESTS PASSED") end
	else
		warn("⚠️ TestEZ not found. Run 'wally install'.")
	end
end)
