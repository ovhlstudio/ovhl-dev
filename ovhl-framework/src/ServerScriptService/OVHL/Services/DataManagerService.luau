--!strict
-- @Service: DataManager v3.2 (Kernel Managed)
-- @Role: Handle Data Lifecycle (Controlled by ServerKernel ONLY)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local ProfileService = Loader.Get("ProfileService")
local Env = Loader.Get("Env")
local DataMigrator = Loader.Get("DataMigrator")

local DataManager = {}
local ProfileStore = nil
local Profiles = {}

DataManager._isShuttingDown = false

local DATA_TEMPLATE = {
	_SchemaVersion = 1,
	Coins = 0,
	Level = 1,
	Inventory = {},
	Meta = { FirstJoin = 0, LastLogin = 0 },
}

function DataManager:Init(ctx)
	self.Logger = ctx:CreateLogger("DATA")
	local storeName = Env.IsStudio() and "OVHL_Dev_01" or "OVHL_Prod_01"
	
    if Env.MockDataStore() then
		ProfileStore = ProfileService.GetProfileStore({ Name = storeName, Scope = "Mock" }, DATA_TEMPLATE)
		ProfileStore = ProfileStore.Mock
	else
		ProfileStore = ProfileService.GetProfileStore(storeName, DATA_TEMPLATE)
	end
    
    -- [FIX] HAPUS BindToClose LOKAL. 
    -- Biarkan ServerKernel yang memanggil Shutdown() kita.
    -- Ini mencegah Race Condition (Double Save).
end

function DataManager:Start()
	Players.PlayerAdded:Connect(function(p) task.spawn(function() self:OnJoin(p) end) end)
	Players.PlayerRemoving:Connect(function(p) self:OnQuit(p) end)
	for _, player in ipairs(Players:GetPlayers()) do task.spawn(function() self:OnJoin(player) end) end
end

function DataManager:Shutdown()
    if self._isShuttingDown then return end
    self._isShuttingDown = true

    self.Logger:Warn("Save", "🛑 Saving all active profiles...")
	for _, profile in pairs(Profiles) do profile:Release() end
end

function DataManager:OnJoin(player)
    if self._isShuttingDown then return end
	if Profiles[player] then return end
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		DataMigrator.Migrate(profile, self.Logger)
		
		profile:ListenToRelease(function()
			Profiles[player] = nil
            self.Logger:Info("Save", { Msg="Profile Released (Saved)", User=player.Name })
			pcall(function() player:Kick("Session End") end)
		end)
        
		if player:IsDescendantOf(Players) then
			Profiles[player] = profile
            local d = profile.Data
			if d.Meta.FirstJoin == 0 then d.Meta.FirstJoin = os.time() end
			d.Meta.LastLogin = os.time()
			self.Logger:Info("LoadOK", { User = player.Name })
		else
			profile:Release()
		end
	else
		self.Logger:Error("LoadFail", "DataStore Failure: " .. player.Name)
		pcall(function() player:Kick("Data Load Failed.") end)
	end
end

function DataManager:OnQuit(player)
	local profile = Profiles[player]
	if profile then 
        self.Logger:Info("Save", { Msg="Closing Session...", User=player.Name })
        profile:Release() 
    end
end

function DataManager:Get(player)
	local profile = Profiles[player]
	return profile and profile.Data
end

return DataManager
