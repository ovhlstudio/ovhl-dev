return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	-- Kita require manual cuma sekali buat entry point
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

	describe("Loader System (v5.2)", function()
		it("should load Core modules via Registry", function()
			local Signals = Loader.Get("Signals")
			expect(Signals).to.be.ok()
			expect(type(Signals)).to.equal("table")
		end)

		it("should auto-detect Packages (Wally)", function()
			-- TestEZ harusnya ada karena kita lagi jalanin tes ini
			local TestEZ = Loader.Get("TestEZ")
			expect(TestEZ).to.be.ok()
		end)

		it("should handle aliases case-insensitively if configured", function()
			-- Tergantung implementasi fuzzy match, tapi kita test direct match dulu
			local context = Loader.Get("Context")
			expect(context).to.be.ok()
		end)

		it("should throw meaningful error on missing module", function()
			expect(function()
				Loader.Get("ModuleYangTidakMungkinAda123")
			end).to.throw()
		end)
	end)
end
