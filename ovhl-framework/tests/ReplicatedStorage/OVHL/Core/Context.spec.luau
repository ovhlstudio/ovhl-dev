return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local Context = Loader.Get("Context")

	describe("Context (DI Container)", function()
		it("should inject services into self", function()
			local mockServices = {
				AuthService = { Name = "Auth" },
				DataService = { Name = "Data" },
			}
			local ctx = Context.New(mockServices)

			expect(ctx).to.be.ok()
			expect(ctx.AuthService).to.be.ok()
			expect(ctx.DataService).to.be.ok()
			expect(ctx.AuthService.Name).to.equal("Auth")
		end)

		it("should provide CreateLogger helper", function()
			local ctx = Context.New({})
			expect(ctx.CreateLogger).to.be.a("function")

			local log = ctx:CreateLogger("TEST_DOMAIN")
			expect(log).to.be.ok()
			-- Pastikan logger punya method standar
			expect(log.Info).to.be.a("function")
		end)
	end)
end
