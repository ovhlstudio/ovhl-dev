--!strict
-- @Core: NetworkGuard v0.2.0 (Hardened)
-- @Role: Deep Inspection & Data Sanitization
-- @Mandate: Mandat 3 (Security Optimization)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")

local NetworkGuard = {}
local Logger = SmartLogger.New("SECURITY")

-- [SECURITY CONSTANTS]
local MAX_DEPTH = 8 -- Mencegah Stack Overflow (Table dalam Table dalam Table...)
local MAX_STRING_LEN = 4096 -- Mencegah Memory Exhaustion (String super panjang)
local SENSITIVE_KEYS = {
	"token",
	"api_key",
	"secret",
	"password",
	"auth",
	"private",
	"ip_address",
}

-- [[ INBOUND: CLIENT -> SERVER ]]
-- Membersihkan data kotor dari Client sebelum disentuh logic game
function NetworkGuard.CleanIn(val: any, depth: number?, player: Player?)
	local d = depth or 0
	if d > MAX_DEPTH then
		-- Jangan log tiap iterasi, cukup return nil (Silent Block)
		return nil
	end

	local t = typeof(val)

	-- 1. Block Instances (CRITICAL)
	-- Mencegah Client mengirim referensi Part/GUI/Script ke Server logic
	if t == "Instance" then
		if d == 0 then -- Hanya log jika ini root level attempt biar gak spam
			Logger:Warn("ExploitAttempt", {
				Msg = "Instance injection blocked",
				Plr = player and player.Name or "Unknown",
			})
		end
		return nil
	end

	-- 2. Sanitize Strings (Buffer Overflow Protection)
	if t == "string" then
		if #val > MAX_STRING_LEN then
			return string.sub(val, 1, MAX_STRING_LEN) -- Potong paksa
		end
		return val
	end

	-- 3. Sanitize Numbers (NaN / Inf Protection)
	if t == "number" then
		-- Cek apakah angka valid (bukan NaN dan bukan Infinity)
		if val ~= val or val == math.huge or val == -math.huge then
			return 0 -- Default ke 0 yang aman
		end
		return val
	end

	-- 4. Recursively Clean Tables
	if t == "table" then
		local clean = {}
		for k, v in pairs(val) do
			-- Key juga harus aman (String/Number only)
			local keyType = typeof(k)
			if keyType == "string" or keyType == "number" then
				-- Rekursi
				local cleanVal = NetworkGuard.CleanIn(v, d + 1, player)
				if cleanVal ~= nil then
					-- [Sanitasi Key] Potong key string yang kepanjangan
					if keyType == "string" and #k > 64 then
						k = string.sub(k, 1, 64)
					end
					clean[k] = cleanVal
				end
			end
		end
		return clean
	end

	-- Allow Booleans, nil
	return val
end

-- [[ OUTBOUND: SERVER -> CLIENT ]]
-- Menyensor data sensitif sebelum dikirim balik ke Client
function NetworkGuard.SanitizeOutbound(val: any, depth: number?)
	local d = depth or 0
	if d > MAX_DEPTH then
		return nil
	end

	local t = typeof(val)

	if t == "table" then
		local clean = {}
		for k, v in pairs(val) do
			local isSafe = true

			-- Redact Sensitive Keys (Privacy Shield)
			if type(k) == "string" then
				local lowerKey = k:lower()
				for _, badWord in ipairs(SENSITIVE_KEYS) do
					if lowerKey:find(badWord) then
						clean[k] = "[REDACTED]"
						isSafe = false
						break
					end
				end
			end

			if isSafe then
				clean[k] = NetworkGuard.SanitizeOutbound(v, d + 1)
			end
		end
		return clean
	end

	return val
end

return NetworkGuard
