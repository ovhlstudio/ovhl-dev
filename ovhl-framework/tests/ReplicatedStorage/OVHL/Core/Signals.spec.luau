return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local Signals = Loader.Get("Signals")

	describe("Signals (Event Bus)", function()
		it("should create new signal on Get", function()
			local sig = Signals:Get("UnitTestSignal")
			expect(sig).to.be.ok()
		end)

		it("should fire and connect events", function()
			local result = 0
			local sigName = "MathTest"

			local connection = Signals:Connect(sigName, function(num)
				result = num * 2
			end)

			Signals:Fire(sigName, 10)

			-- Signal biasanya asynchronous di frame yang sama atau next frame
			-- Tapi library Signal modern biasanya direct invoke.
			-- Kita asumsi direct invoke untuk tes ini.
			expect(result).to.equal(20)

			connection:Disconnect()
		end)
	end)
end
