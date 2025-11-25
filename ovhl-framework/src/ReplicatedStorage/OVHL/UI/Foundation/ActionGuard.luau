--!strict
-- @Foundation: ActionGuard v0.3.0 (Keyed Mutex)
-- @Role: Granular Logic Gatekeeper & Race Condition Shield
-- @Standard: Keyed Locking (Non-Blocking Global)

local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Signals = Loader.Get("Signals")

local ActionGuard = {}

-- Registry Kunci: [UniqueKey] = ExpiryTime (os.clock)
-- Menggantikan _isBusy global agar UI tidak freeze total
local _activeLocks = {} :: { [string]: number }

-- [[ API UTAMA ]]
-- @param opts: {
--    Id: string (REQUIRED for button independence),
--    Debounce: number (Time in seconds),
--    Confirm: table (Optional for Dialog: {Title, Msg})
-- }
-- @param callback: Fungsi yang akan dijalankan jika lolos guard
function ActionGuard.Run(opts, callback)
	local uniqueId = opts.Id or "Global_Unsafe" -- Fallback ID jika developer lupa
	local debounceTime = opts.Debounce or 0.5
	local now = os.clock()

	-- 1. CEK STATUS KUNCI (Granular Check)
	-- Jika kunci ada DAN waktunya belum habis, tolak request (Silent Block)
	if _activeLocks[uniqueId] and _activeLocks[uniqueId] > now then
		warn("[ActionGuard] Spam Blocked: " .. uniqueId)
		return
	end

	-- 2. PASANG KUNCI (Lock)
	-- Kunci berlaku selama durasi debounce
	_activeLocks[uniqueId] = now + debounceTime

	-- 3. LOGIC EKSEKUSI
	if opts.Confirm then
		-- [PRESERVED LOGIC] Flow Konfirmasi (Sesuai Snapshot v0.1.0)
		Signals:Fire("SystemUI:RequestConfirm", {
			Title = opts.Confirm.Title,
			Message = opts.Confirm.Msg,

			-- Callback Result dari UI
			OnResult = function(confirmed)
				if confirmed then
					-- Eksekusi aksi nyata jika user pilih YES
					-- Dibungkus pcall agar error user tidak mematikan thread guard
					task.spawn(function()
						local success, err = pcall(callback)
						if not success then
							warn("[ActionGuard] Execution Error:", err)
						end
					end)
				end
				-- Lock dibiarkan habis sesuai timer debounce (auto-unlock)
			end,
		})
	else
		-- Flow Instant (Direct Execution)
		task.spawn(function()
			local success, err = pcall(callback)
			if not success then
				warn("[ActionGuard] Execution Error:", err)
			end
		end)
	end

	-- 4. GARBAGE COLLECTION (Memory Cleanup)
	-- Hapus key dari tabel setelah waktu habis agar memori tidak bocor selamanya
	task.delay(debounceTime + 0.1, function()
		if _activeLocks[uniqueId] and _activeLocks[uniqueId] <= os.clock() then
			_activeLocks[uniqueId] = nil
		end
	end)
end

return ActionGuard
