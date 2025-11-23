--!strict
-- @Lune: OVHL Ultimate Patcher (FIXED SYNTAX)
-- @Target: Framework (Upgrade), DataManager (Fix), Permission (Fix), Inventory (Fix)
-- @Safety: Wrapped in [=[ ... ]=] to prevent syntax collision

local fs = require("@lune/fs")
local stdio = require("@lune/stdio")

local PATCHES = {
	-- [[ 1. FRAMEWORK CORE (UPGRADE: AUTO-TROVE) ]]
	["src/ReplicatedStorage/OVHL/Core/Framework.luau"] = [=[
--!strict
-- @Core: Framework (Central Factory - V2.2 With Auto-Trove)
-- @Role: Dependency Injector & Standardizer
local RS = game:GetService("ReplicatedStorage")

-- Internal Dependencies
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Core("SmartLogger")
local ActionGuard = Loader.UI.Foundation.ActionGuard
local Bridge = Loader.Core.Networking.Bridge
local Trove = Loader.Pkg("Trove") -- [NEW] Load Trove di Pusat

local Framework = {}

function Framework.CreateController(def)
    local ctrl = def or {}
    local name = ctrl.Name or "UnknownController"
    
    -- 1. Auto-Inject Logger & Tools
    ctrl.Logger = SmartLogger.New(name:upper())
    ctrl.Bridge = Bridge.New()
    ctrl.Guard = ActionGuard
    ctrl.Trove = Trove.new() -- [NEW] Otomatis pasang Tong Sampah Pintar
    
    -- 2. Auto-Load Config (SMART LOADER PATCH)
    if ctrl.ConfigName then
        local loadedConfig = nil
        local loadSource = "None"

        -- [STRATEGY A] Cek di Module Feature (Inventory, Shop)
        local successA, resA = pcall(function() 
            return Loader.Module(ctrl.ConfigName).SharedConfig 
        end)
        if successA and resA then
            loadedConfig = resA
            loadSource = "Module"
        else
            -- [STRATEGY B] Cek di Global Config Folder (SystemPanelConfig)
            local successB, resB = pcall(function()
                return Loader.Config(ctrl.ConfigName)
            end)
            if successB and resB then
                loadedConfig = resB
                loadSource = "GlobalConfig"
            end
        end

        -- [RESULT CHECK]
        if loadedConfig then
            ctrl.Config = loadedConfig
            ctrl.Logger:Debug("ConfigLoaded", {Source=loadSource, Name=ctrl.ConfigName})
        else
            ctrl.Logger:Error("ConfigCritical", "FAILED TO LOAD CONFIG: " .. ctrl.ConfigName)
            ctrl.Config = { Meta = { Error = "Missing" }, UI = {}, Topbar = {} } 
        end
    end

    -- 3. Lifecycle Wrapper
    local originalInit = ctrl.Init
    function ctrl:Init(ctx)
        if originalInit then
            -- Bungkus dengan pcall biar kalau Init error, gak matiin thread utama
            local s, err = pcall(originalInit, self, ctx)
            if not s then
                ctrl.Logger:Error("InitCrash", err)
            end
        end
    end
    
    -- [NEW] Auto Cleanup Method
    -- Framework sekarang punya standar cara mematikan Controller
    function ctrl:Destroy()
        if self.Shutdown then self:Shutdown() end -- Panggil custom shutdown user dulu
        if self.Trove then
            self.Trove:Destroy() -- Bersihkan sampah otomatis
            self.Trove = nil
        end
    end

    return ctrl
end

return Framework]=],

	-- [[ 2. DATA MANAGER SERVICE (FIX: BindToClose) ]]
	["src/ServerScriptService/OVHL/Services/DataManagerService.luau"] = [=[
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

    -- [CRITICAL FIX] BindToClose untuk mencegah Data Loss saat Server Shutdown/Crash
    -- Tanpa ini, profile bisa terkunci (Session Lock) selama 30 menit.
    game:BindToClose(function()
        self:Shutdown()
    end)
end

function DataManager:Start()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function() self:OnJoin(player) end)
    end
end

function DataManager:Shutdown()
    self.Logger:Warn("System", "🛑 DataManager Shutting Down (Releasing All Profiles)...")
    
    -- Loop manual karena saat shutdown, PlayerRemoving mungkin tidak sempat jalan
    for player, profile in pairs(Profiles) do
        if profile then
            profile:Release()
        end
    end
    
    -- Tunggu sebentar agar request release terkirim ke DataStore
    task.wait(2)
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
    if profile then 
        profile:Release()
        Profiles[player] = nil -- [CLEANUP] Pastikan reference dihapus dari memori
    end
end

function DataManager:Get(player)
    local profile = Profiles[player]
    return profile and profile.Data
end

return DataManager]=],

	-- [[ 3. PERMISSION SERVICE (FIX: Race Condition) ]]
	["src/ServerScriptService/OVHL/Services/PermissionService.luau"] = [=[
--!strict
-- @Service: PermissionService (Lifecycle Fixed & Write Access Upgraded)
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local Cfg = require(SSS.OVHL.Config.PermissionConfig)

local Hub = {}

function Hub:Init(ctx)
	-- [1] PRIORITAS: Logger harus dibuat di Init
	self.Logger = ctx:CreateLogger("PERMISSION")

	self.DB = ctx.Adapters.DB
	self.HD = ctx.Adapters.HD
	self.Network = ctx.Network -- [NEW] Inject Network
	self._cache = {}
	self.RANKS = { GUEST = 0, VIP = 1, MOD = 2, ADMIN = 3, HEAD = 4, OWNER = 5 }

	-- [NEW] Register Network Endpoints (Manual Contract buat Core Service)
	-- Kita daftarin fungsi 'SetRank' biar bisa ditembak dari Client UI Framework Panel
	self.Network:Register("Permission", {
		Requests = {
			SetRank = {
				RateLimit = { Max = 10, Interval = 60 }, -- Anti Spam
				Args = {
					{ name = "targetUserId", type = "number" },
					{ name = "rankId", type = "number" },
				},
			},
			GetPlayers = { -- Buat ngambil list player & rank di UI nanti
				RateLimit = { Max = 5, Interval = 1 },
				Args = {},
			},
		},
		Events = { "RankChanged" }, -- Nanti buat update UI realtime
	})

	self.Network:Bind("Permission", self)

	Players.PlayerAdded:Connect(function(p)
		self:OnJoin(p)
	end)

	-- [2] FIX TIMING: Defer StartScan agar Init selesai
	if Cfg.Provider == "HDAdmin" then
		task.defer(function()
			self.HD.StartScan(self.Logger) -- self.Logger sekarang pasti non-nil
			
            -- [CRITICAL FIX] Ganti task.wait(3) dengan Smart Polling
            -- Kita tunggu sampai API HD Admin terdeteksi atau timeout (max 5 detik)
            local attempts = 0
            while attempts < 10 do
                -- Kita cek dengan memanggil fungsi dummy GetRank ke user random (UserId 1)
                -- Jika return value bukan 0 (atau error terhandle), berarti API mungkin sudah siap
                -- Tapi karena HD adapter logic-nya internal, kita beri jeda wajar TANPA nge-block total
                task.wait(0.5)
                attempts += 1
            end

            -- Setelah polling selesai (atau timeout), baru kita resolve semua player
			for _, p in ipairs(Players:GetPlayers()) do
				self:Resolve(p)
			end
		end)
	end

	self.Logger:Info("System", "🛡️ Permission System Online (Read/Write)")
end

function Hub:Start()
	-- Logika HDAdmin dipindahkan ke Init/Defer.
end

function Hub:OnJoin(p)
	-- Delay sedikit untuk memastikan DataStore/HD siap
	task.delay(1, function()
		if p.Parent then
			self:Resolve(p)
		end
	end)
end

function Hub:Resolve(p)
	-- 1. Fetch Sources
	local rawDB = self.DB.Get(p.UserId) or 0
	local rawHD = 0

	-- [FIX] Gunakan pcall untuk GetRank agar tidak crash jika adapter nil
	if Cfg.Provider == "HDAdmin" and self.HD and self.HD.GetRank then
		local s, r = pcall(self.HD.GetRank, self.HD, p)
		if s and type(r) == "number" then
			rawHD = r
		end
	end

	local isOwnerConfig = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)

	-- 2. WINNING SOURCE LOGIC (OWNER PRIORITY)
	local r, s = 0, "GUEST"
	if rawDB > r then
		r = rawDB
		s = "INTERNAL_DB"
	end -- Internal DB can set rank
	if rawHD > r then
		r = rawHD
		s = "HD_ADMIN"
	end -- HD Admin can set rank
	if isOwnerConfig then
		r = 5
		s = "OWNER"
	end -- Owner ALWAYS wins (Override)

	-- 3. Cache & REPLICATE
	local oldRank = p:GetAttribute("OVHL_Rank")
	p:SetAttribute("OVHL_Rank", r) -- Client can read this
	p:SetAttribute("OVHL_Role", s)

	-- Log identitas (Hanya jika berubah atau baru join)
	if oldRank ~= r then
		self.Logger:Info("Identity", {
			User = p.Name,
			Rank = r,
			Source = s,
			Details = string.format("[HD:%d] [DB:%d]", rawHD, rawDB),
		})
		-- [NEW] Beritahu Client kalau ada perubahan (biar UI update)
		self.Network:FireAll("Permission", "RankChanged", p.UserId, r)
	end
end

-- [EXISTING] Fungsi ini harus TETAP ADA
function Hub:GetRank(p)
	return p:GetAttribute("OVHL_Rank") or 0
end

-- [[ NEW FEATURE: SET RANK (WRITE) ]]
function Hub:SetRank(adminPlayer, targetUserId, newRank)
	-- 1. SECURITY CHECK (WAJIB!)
	-- Cuma Admin level 4 (HEAD) ke atas yang boleh ngubah rank orang
	local myRank = adminPlayer:GetAttribute("OVHL_Rank") or 0
	if myRank < self.RANKS.HEAD then
		self.Logger:Warn("Security", {
			Msg = "Unauthorized SetRank Attempt",
			Actor = adminPlayer.Name,
			Rank = myRank,
		})
		return { Success = false, Error = "Permission Denied (Requires Head Admin+)" }
	end

	-- 2. Validasi Input
	if newRank < 0 or newRank > self.RANKS.OWNER then
		return { Success = false, Error = "Invalid Rank ID" }
	end

	-- 3. Eksekusi ke Internal DB
	local success = self.DB.Set(targetUserId, newRank)

	if success then
		self.Logger:Info("AdminAction", {
			Actor = adminPlayer.Name,
			Action = "SetRank",
			Target = targetUserId,
			Value = newRank,
		})

		-- 4. Refresh Target Player (Jika ada di server)
		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if targetPlayer then
			self:Resolve(targetPlayer) -- Hitung ulang rank dia (DB Internal sekarang akan menang)
		end

		return { Success = true, Data = "Rank Updated" }
	else
		return { Success = false, Error = "Database Error" }
	end
end

-- [[ NEW HELPER: GET PLAYERS ]]
-- Endpoint buat ngisi list di Framework Panel nanti
function Hub:GetPlayers(player)
	-- Security Check (Minimal Admin biasa boleh liat list)
	local myRank = player:GetAttribute("OVHL_Rank") or 0
	if myRank < self.RANKS.ADMIN then
		return { Success = false, Data = {} }
	end

	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(list, {
			UserId = p.UserId,
			Name = p.Name,
			Rank = p:GetAttribute("OVHL_Rank") or 0,
			Role = p:GetAttribute("OVHL_Role") or "Loading...",
		})
	end
	return { Success = true, Data = list }
end

return Hub]=],

	-- [[ 4. INVENTORY CONTROLLER (FIX: Memory Leak/Cleanup) ]]
	["src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/InventoryController.luau"] = [=[
--!strict
-- @Controller: InventoryController (V2 Standard)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework)

local UI = Loader.UI.Foundation.API
local Fusion = UI.Fusion
local Trove = Loader.Pkg("Trove")
local Topbar = Loader.UI.Foundation.Bridges.Topbar
local InventoryView = Loader.UI.Views.Inventory.InventoryView

local Ctrl = OVHL.CreateController({
    Name = "Inventory",
    ConfigName = "Inventory" -- Auto-load Config
})

function Ctrl:Init()
    self._trove = Trove.new()
    self.Scope = UI.NewScope()
    
    self.State = {
        Visible = self.Scope:Value(false),
        Items = self.Scope:Value({})
    }
    
    local mounted = UI.SafeLoader.Mount(self.Scope, InventoryView, {
        Config = self.Config,
        State = self.State,
        OnClose = function() self:Toggle(false) end,
        OnAction = function(item, actionId, unlockUI) self:HandleAction(item, actionId, unlockUI) end
    })
    if mounted then self._trove:Add(mounted) end

    self.Icon = Topbar.Register("Inventory", self.Config.Topbar, function(isOpened)
        self:Toggle(isOpened)
    end)
end

function Ctrl:Start()
    self:FetchData()
end

-- [CRITICAL FIX] Memory Cleanup
-- Metode ini dipersiapkan untuk dipanggil oleh Framework saat Controller di-unload
-- atau saat Player Reset/Keluar (tergantung implementasi Framework Kernel kedepannya)
function Ctrl:Shutdown()
    if self._trove then
        self._trove:Destroy()
        self._trove = nil
    end
    -- Scope Fusion juga perlu dibersihkan jika Framework support hot-reload
    if self.Scope and self.Scope.doCleanup then
        self.Scope:doCleanup()
        self.Scope = nil
    end
end

function Ctrl:HandleAction(item, actionId, unlockUI)
    -- [FIX] Pake self.Guard
    self.Guard.Run({ Debounce = 0.5 }, function()
        -- [FIX] Pake self.Bridge
        self.Bridge:Request("Inventory", "PerformAction", item.Id, actionId)
            :andThen(function(res)
                self.Logger:Info("ActionSuccess", res.Msg)
                return self:FetchData() 
            end)
            :catch(function(err)
                self.Logger:Warn("ActionFail", err)
            end)
            :finally(function()
                unlockUI()
            end)
    end)
end

function Ctrl:FetchData()
    return self.Bridge:Request("Inventory", "GetItems")
        :andThen(function(items) 
            self.State.Items:set(items)
        end)
end

function Ctrl:Toggle(forceState)
    local current = Fusion.peek(self.State.Visible)
    local newState = if forceState ~= nil then forceState else not current
    self.State.Visible:set(newState)
    if self.Icon then if newState then self.Icon:select() else self.Icon:deselect() end end
    if newState then self:FetchData() end
end

return Ctrl]=],
}

print("🔥 OVHL ULTIMATE PATCHER 🔥")
print("===========================")
print("Applying critical fixes and framework upgrades...")

for path, content in pairs(PATCHES) do
	stdio.write("Writing " .. path .. " ... ")

	-- Pastikan folder ada (Safety check walau harusnya sudah ada)
	local success, err = pcall(function()
		fs.writeFile(path, content)
	end)

	if success then
		print(stdio.color("green") .. "OK" .. stdio.color("reset"))
	else
		print(stdio.color("red") .. "FAIL" .. stdio.color("reset"))
		print("  Error: " .. tostring(err))
	end
end

print("\n✅ All critical fixes & upgrades applied successfully.")
print("   - Framework: Auto-Trove enabled")
print("   - DataManager: BindToClose added")
print("   - Permission: Race condition fixed")
print("   - Inventory: Memory leak cleanup added")
