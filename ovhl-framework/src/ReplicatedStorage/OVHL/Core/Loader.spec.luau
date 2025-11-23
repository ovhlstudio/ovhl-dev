--!strict
return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

	describe("Loader V2", function()
		it("should support Dot Syntax (Loader.Core.Module)", function()
			local Signals = Loader.Core.Signals
			expect(Signals).to.be.ok()
		end)

		it("should support Legacy Call Syntax (Loader.Core('Module'))", function()
			expect(function()
                local Signals = Loader.Core("Signals")
                expect(Signals).to.be.ok()
            end).never.to.throw()
		end)
        
        it("should list available files on error", function()
            local ok, err = pcall(function() return Loader.Core.Ngawur end)
            expect(ok).to.equal(false)
            expect(string.find(tostring(err), "Available:")).to.be.ok()
        end)
	end)
end
