--!strict
-- @System: TestRunner (Client Side)
-- @Standard: Observability Compliant (Zero Print)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then return end

task.defer(function()
	task.wait(3) -- Client load buffer

    -- [FIX] Logger Integration
    local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
    local Logger = Loader.Get("Logger").New("TEST")

	Logger:Info("Init", "🧪 CLIENT TEST RUNNER STARTING...")

	local TesEZ
	pcall(function() TesEZ = Loader.Get("TestEZ") end)

	if not TesEZ then 
        Logger:Warn("Skip", "TestEZ not found.")
        return 
    end

	local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	local ClientTests = PlayerScripts:WaitForChild("Tests", 10)

	if not ClientTests then 
        Logger:Info("Skip", "No Client Tests found.")
        return 
    end

	local results = TesEZ.TestBootstrap:run({ClientTests})

	if results.failureCount > 0 then
		Logger:Error("FAIL", results.failureCount .. " client tests failed.")
	else
		Logger:Info("PASS", "✅ Client Systems Secure.")
	end
end)
