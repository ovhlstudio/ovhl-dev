return function()
	local Players = game:GetService("Players")
	local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	local ClientKernel = require(PlayerScripts.OVHL.Core.ClientKernel)

	describe("Client Kernel", function()
		it("should exist and have Boot method", function()
			expect(ClientKernel).to.be.ok()
			expect(ClientKernel.Boot).to.be.a("function")
		end)

		-- Hati-hati ngetes Boot() beneran karena bisa double-init sama game asli.
		-- Cukup pastikan structure-nya benar.
	end)
end
