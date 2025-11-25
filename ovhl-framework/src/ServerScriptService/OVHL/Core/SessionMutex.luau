--!strict
-- @Core: SessionMutex v0.2.0
-- @Role: Transaction Locker (Prevent Race Conditions)
-- @Mandate: Mandat 5 (Data Integrity)

local SessionMutex = {}
local _locks = {} :: { [number]: boolean } -- [UserId] = isLocked

-- [[ API ]]

-- Menjalankan fungsi kritis dengan penguncian
-- Jika User sedang dikunci (busy), action ini akan langsung gagal (Fast Fail)
-- return: (Success: boolean, Result: any)
function SessionMutex.Run(userId: number, callback: () -> any)
	if _locks[userId] then
		return false, "Transaction Busy: Please wait."
	end

	-- 1. LOCK
	_locks[userId] = true

	-- 2. EXECUTE (Safely)
	local success, result = pcall(callback)

	-- 3. UNLOCK (Always runs)
	_locks[userId] = nil

	if not success then
		return false, result -- Result is error message here
	end

	return true, result
end

-- Cek status lock (untuk debugging/UI hint)
function SessionMutex.IsLocked(userId: number)
	return _locks[userId] == true
end

-- Force Unlock (Hanya dipanggil saat Player Leaving/Cleanup)
function SessionMutex.ForceUnlock(userId: number)
	_locks[userId] = nil
end

return SessionMutex
