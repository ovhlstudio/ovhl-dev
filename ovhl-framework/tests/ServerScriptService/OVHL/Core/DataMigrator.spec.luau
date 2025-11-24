return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local SS = game:GetService("ServerScriptService")

	-- Pake Loader untuk akses file server (jika di setup Loader.Server)
	-- Atau require manual kalau Loader.Server belum ready di test env
	local DataMigrator = require(SS.OVHL.Core.DataMigrator)

	-- Mock Logger sederhana
	local MockLogger = {
		Info = function() end,
		Warn = function() end,
		Error = function() end,
	}

	describe("DataMigrator", function()
		it("should tag new data with latest version", function()
			local profile = { Data = {} }
			DataMigrator.Migrate(profile, MockLogger)

			expect(profile.Data._SchemaVersion).to.equal(DataMigrator.LATEST_VERSION)
		end)

		it("should NOT migrate if version matches", function()
			local profile = { Data = { _SchemaVersion = DataMigrator.LATEST_VERSION, Coins = 100 } }
			DataMigrator.Migrate(profile, MockLogger)

			expect(profile.Data.Coins).to.equal(100) -- Data gak boleh rusak
			expect(profile.Data._SchemaVersion).to.equal(DataMigrator.LATEST_VERSION)
		end)
	end)
end
