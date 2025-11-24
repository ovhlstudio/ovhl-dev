--!strict
-- @Service: DataManager v2.4 (FINAL AUDIT FIX)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local Loader = require(RS.OVHL.Core.Loader)
local ProfileService = Loader.Get("ProfileService")
local Env = Loader.Get("Env")
local DataMigrator = require(SS.OVHL.Core.DataMigrator)

local DataManager = {}
local ProfileStore = nil
local Profiles = {}

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

	-- Setup Store
	if Env.MockDataStore() then
		ProfileStore = ProfileService.GetProfileStore({ Name = storeName, Scope = "Mock" }, DATA_TEMPLATE)
		ProfileStore = ProfileStore.Mock
	else
		ProfileStore = ProfileService.GetProfileStore(storeName, DATA_TEMPLATE)
	end

	-- Bind Cleanup
	game:BindToClose(function()
		self:Shutdown()
	end)
end

function DataManager:Start()
	-- Listeners
	Players.PlayerAdded:Connect(function(p)
		task.spawn(function()
			self:OnJoin(p)
		end)
	end)
	Players.PlayerRemoving:Connect(function(p)
		self:OnQuit(p)
	end)

	-- Handle existing
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			self:OnJoin(player)
		end)
	end
end

function DataManager:Shutdown()
	-- CLEANUP WITHOUT WAIT (ProfileService handles sync internally on Close)
	for player, profile in pairs(Profiles) do
		if profile then
			profile:Release()
		end
	end
end

function DataManager:OnJoin(player)
	if Profiles[player] then
		return
	end

	-- NO MANUAL RETRY/WAIT HERE - Rely on ProfileService auto-retry logic
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		DataMigrator.Migrate(profile, self.Logger)

		profile:ListenToRelease(function()
			Profiles[player] = nil
			pcall(function()
				player:Kick("Session End")
			end)
		end)

		if player:IsDescendantOf(Players) then
			Profiles[player] = profile
			-- Init timestamps
			local d = profile.Data
			if d.Meta.FirstJoin == 0 then
				d.Meta.FirstJoin = os.time()
			end
			d.Meta.LastLogin = os.time()
			self.Logger:Info("LoadOK", { User = player.Name })
		else
			profile:Release()
		end
	else
		self.Logger:Error("LoadFail", "DataStore Critical Failure: " .. player.Name)
		pcall(function()
			player:Kick("Data Load Failed. Please Rejoin.")
		end)
	end
end

function DataManager:OnQuit(player)
	local profile = Profiles[player]
	if profile then
		profile:Release()
	end
	Profiles[player] = nil
end

function DataManager:Get(player)
	local profile = Profiles[player]
	return profile and profile.Data
end

return DataManager
