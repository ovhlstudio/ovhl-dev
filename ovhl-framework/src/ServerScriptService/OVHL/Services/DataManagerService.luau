--!strict
-- @Service: DataManager v2.0
-- @Standard: Enterprise (Retry, Env Aware, Schema Migration)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local Loader = require(RS.OVHL.Core.Loader)
local ProfileService = Loader.Pkg("ProfileService")
local Env = Loader.Core.Env

-- [NEW] Import Migrator
local DataMigrator = require(SS.OVHL.Core.DataMigrator)

local DataManager = {}
local ProfileStore = nil
local Profiles = {}

-- Template Data Default
local DATA_TEMPLATE = {
    _SchemaVersion = 1, -- Penanda Versi
    Coins = 0,
    Level = 1,
    Inventory = {},
    Meta = { FirstJoin = 0, LastLogin = 0 },
}

function DataManager:Init(ctx)
    self.Logger = ctx:CreateLogger("DATA")

    local storeName = Env.IsStudio() and "OVHL_Dev_01" or "OVHL_Prod_01"
    
    -- Mocking Logic (Preserved from V1)
    if Env.MockDataStore() then
        self.Logger:Warn("Store", "⚠️ USING MOCK DATASTORE")
        ProfileStore = ProfileService.GetProfileStore({ Name = storeName, Scope = "Mock" }, DATA_TEMPLATE)
        ProfileStore = ProfileStore.Mock
    else
        ProfileStore = ProfileService.GetProfileStore(storeName, DATA_TEMPLATE)
    end

    Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
    Players.PlayerRemoving:Connect(function(p) self:OnQuit(p) end)
end

function DataManager:Start()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function() self:OnJoin(player) end)
    end
end

function DataManager:Shutdown()
    self.Logger:Warn("System", "🛑 DataManager Shutting Down...")
    for _, profile in pairs(Profiles) do
        profile:Release()
    end
end

function DataManager:OnJoin(player)
    if Profiles[player] then return end

    local profile = nil
    local attempts = 0
    
    -- Retry Logic (Preserved from V1)
    while attempts < 3 and player:IsDescendantOf(Players) do
        attempts += 1
        profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
        if profile then break end
        self.Logger:Warn("LoadRetry", { User = player.Name, Attempt = attempts })
        task.wait(2)
    end

    if profile then
        profile:AddUserId(player.UserId)
        profile:Reconcile() -- Mengisi field kosong dari Template
        
        -- [NEW] MIGRATION CHECK
        DataMigrator.Migrate(profile, self.Logger)

        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick("Session Released")
        end)

        if player:IsDescendantOf(Players) then
            Profiles[player] = profile
            
            -- Update Meta Logic
            local data = profile.Data
            if data.Meta.FirstJoin == 0 then data.Meta.FirstJoin = os.time() end
            data.Meta.LastLogin = os.time()
            
            self.Logger:Info("LoadSuccess", { User = player.Name })
        else
            profile:Release()
        end
    else
        self.Logger:Error("LoadFail", { User = player.Name })
        player:Kick("Critical Data Error: Failed to load profile.")
    end
end

function DataManager:OnQuit(player)
    local profile = Profiles[player]
    if profile then profile:Release() end
end

function DataManager:Get(player)
    local profile = Profiles[player]
    return profile and profile.Data
end

return DataManager
