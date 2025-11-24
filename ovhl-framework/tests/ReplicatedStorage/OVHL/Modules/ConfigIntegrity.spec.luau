return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

	-- Helper untuk scan folder modules
	local ModulesRoot = ReplicatedStorage.OVHL.Modules

	describe("SharedConfig Integrity", function()
		for _, moduleFolder in ipairs(ModulesRoot:GetChildren()) do
			if moduleFolder:IsA("Folder") then
				it("should have valid SharedConfig in " .. moduleFolder.Name, function()
					local configFile = moduleFolder:FindFirstChild("SharedConfig")
					expect(configFile).to.be.ok()

					local config = require(configFile)

					-- Validasi Wajib
					expect(config.Meta).to.be.a("table")
					expect(config.Meta.Name).to.be.a("string")

					-- Validasi Network (Jika ada)
					if config.Network then
						expect(config.Network.Requests).to.be.a("table")
					end
				end)
			end
		end
	end)
end
