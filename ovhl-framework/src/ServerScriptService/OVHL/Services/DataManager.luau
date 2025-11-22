-- @Service: DataManager
-- @Standard: Enterprise (Retry Mechanism & Env Aware)
local Players = game:GetService("Players")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local ProfileService = Loader.Pkg("ProfileService")
local Env = Loader.Core("Env")

local DataManager = {}
local ProfileStore = nil
local Profiles = {}

local DATA_TEMPLATE = {
    Coins = 0,
    Level = 1,
    Inventory = {},
    Meta = { FirstJoin = 0, LastLogin = 0 },
}

function DataManager:Init(ctx)
    self.Logger = ctx:CreateLogger("DATA")

    local storeName = Env.IsStudio() and "OVHL_Dev_01" or "OVHL_Prod_01"
    if Env.MockDataStore() then
        self.Logger:Warn("⚠️ USING MOCK DATASTORE")
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
    self.Logger:Warn("🛑 DataManager Shutting Down...")
    for _, profile in pairs(Profiles) do
        profile:Release()
    end
end

function DataManager:OnJoin(player)
    if Profiles[player] then return end

    local profile = nil
    local attempts = 0
    local maxAttempts = 3
    
    while attempts < maxAttempts and player:IsDescendantOf(Players) do
        attempts += 1
        profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
        
        if profile then
            break 
        else
            self.Logger:Warn("LoadRetry", { User = player.Name, Attempt = attempts })
            task.wait(2) 
        end
    end

    if profile then
        profile:AddUserId(player.UserId)
        profile:Reconcile()

        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick("Session Released")
        end)

        if player:IsDescendantOf(Players) then
            Profiles[player] = profile
            self.Logger:Info("Profile Loaded", { User = player.Name })
        else
            profile:Release()
        end
    else
        self.Logger:Error("LoadFail", { User = player.Name, Attempts = attempts })
        player:Kick("Critical Data Error: Failed to load profile after retries.")
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
