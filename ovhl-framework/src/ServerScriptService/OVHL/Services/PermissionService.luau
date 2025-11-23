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
			-- Re-scan players setelah HD connect
			task.wait(3)
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

return Hub
