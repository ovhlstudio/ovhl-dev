--!strict
-- @System: TestRunner (Server Side)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then return end

task.defer(function()
	task.wait(2)
    local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
    local Logger = Loader.Get("Logger").New("TEST")
	Logger:Info("Init", "🧪 SERVER TEST RUNNER STARTING...")

	local TesEZ
	pcall(function() TesEZ = Loader.Get("TestEZ") end)
	if not TesEZ then Logger:Warn("Missing", "TestEZ not found.") return end

	local testRoots = { ReplicatedStorage:WaitForChild("Tests", 10), ServerScriptService:WaitForChild("Tests", 10) }
	local validRoots = {}
	for _, folder in ipairs(testRoots) do if folder then table.insert(validRoots, folder) end end

	if #validRoots == 0 then Logger:Warn("Empty", "No Test Folders.") return end
	local results = TesEZ.TestBootstrap:run(validRoots)

	if results.failureCount > 0 then Logger:Error("FAIL", results.failureCount .. " tests failed.")
	else Logger:Info("PASS", "✅ All Systems Operational.") end
end)
