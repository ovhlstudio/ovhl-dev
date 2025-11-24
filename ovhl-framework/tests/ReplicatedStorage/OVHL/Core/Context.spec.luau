--!strict
return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local Context = Loader.Core("Context")

	describe("Context", function()
		it("should inject services", function()
			local mockServices = {
				AuthService = { Name = "Auth" },
				DataService = { Name = "Data" }
			}
			local ctx = Context.New(mockServices)
			
			expect(ctx).to.be.ok()
			expect(ctx.AuthService).to.be.ok()
			expect(ctx.DataService).to.be.ok()
		end)

		it("should provide CreateLogger helper", function()
			local ctx = Context.New({})
			expect(ctx.CreateLogger).to.be.a("function")
			
			local log = ctx:CreateLogger("CTX_TEST")
			expect(log).to.be.ok()
		end)
        
        it("should expose shared libs", function()
            local ctx = Context.New({})
            expect(ctx.Signals).to.be.ok()
            expect(ctx.Manifest).to.be.ok()
        end)
	end)
end
