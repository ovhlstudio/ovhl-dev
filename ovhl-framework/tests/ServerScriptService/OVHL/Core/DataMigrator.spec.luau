--!strict
return function()
    local SS = game:GetService("ServerScriptService")
    local DataMigrator = require(SS.OVHL.Core.DataMigrator)
    
    -- Mock Logger untuk menangkap output
    local MockLogger = {
        Warn = function() end,
        Info = function() end,
        Error = function() end
    }

    describe("DataMigrator", function()
        it("should auto-tag new data with latest version", function()
            local profile = { Data = {} }
            DataMigrator.Migrate(profile, MockLogger)
            expect(profile.Data._SchemaVersion).to.equal(DataMigrator.LATEST_VERSION)
        end)
        
        it("should skip migration if version matches", function()
            local profile = { Data = { _SchemaVersion = DataMigrator.LATEST_VERSION } }
            -- Kita tidak bisa mudah detect 'skip' tanpa spy, 
            -- tapi setidaknya pastikan tidak error dan versi tidak berubah
            DataMigrator.Migrate(profile, MockLogger)
            expect(profile.Data._SchemaVersion).to.equal(DataMigrator.LATEST_VERSION)
        end)
    end)
end
