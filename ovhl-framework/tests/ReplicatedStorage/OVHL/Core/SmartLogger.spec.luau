--!strict
return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local SmartLogger = Loader.Get("Logger")

	describe("SmartLogger", function()
		it("should create new instance", function()
			local log = SmartLogger.New("UNIT_TEST")
			expect(log).to.be.ok()
			expect(log._rawDomain).to.equal("UNIT_TEST")
		end)

		it("should handle logging without error", function()
			local log = SmartLogger.New("TEST")
			expect(function()
				log:Info("Info Check")
				log:Warn("Warn Check")
			end).never.to.throw()
		end)

		it("should accept data table", function()
			local log = SmartLogger.New("TEST")
			expect(function()
				log:Info("Data Check", { Value = 123 })
			end).never.to.throw()
		end)
	end)
end
