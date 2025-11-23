--!strict
-- @Module: DataMigrator
-- @Role: Menangani perubahan struktur data antar versi
local DataMigrator = {}

-- [CONFIG] Versi Data Saat Ini
DataMigrator.LATEST_VERSION = 1

-- [LOGIC] Daftar Migrasi (Fungsi untuk naik kelas)
local MIGRATIONS = {
    -- Contoh Migrasi ke V2 nanti:
    -- [2] = function(data)
    --     data.Pets = {} 
    --     return data
    -- end
}

function DataMigrator.Migrate(profile, logger)
    local data = profile.Data
    local currentVer = data._SchemaVersion or 0
    
    -- Jika data baru (kosong), langsung cap versi terbaru
    if currentVer == 0 and not next(data) then
        data._SchemaVersion = DataMigrator.LATEST_VERSION
        return
    end

    -- Loop migrasi dari versi lama ke terbaru
    if currentVer < DataMigrator.LATEST_VERSION then
        logger:Warn("Migrator", string.format("Migrating Data v%d -> v%d", currentVer, DataMigrator.LATEST_VERSION))
        
        for v = currentVer + 1, DataMigrator.LATEST_VERSION do
            local migrationFunc = MIGRATIONS[v]
            if migrationFunc then
                -- Jalankan fungsi migrasi
                local success, err = pcall(function()
                    data = migrationFunc(data)
                end)
                
                if not success then
                    logger:Error("MigrationFail", { Version = v, Error = err })
                    break -- Stop migrasi jika gagal, biarkan load apa adanya (safety)
                end
            end
        end
        
        -- Update versi di data
        data._SchemaVersion = DataMigrator.LATEST_VERSION
        logger:Info("Migrator", "Migration Complete.")
    end
end

return DataMigrator
