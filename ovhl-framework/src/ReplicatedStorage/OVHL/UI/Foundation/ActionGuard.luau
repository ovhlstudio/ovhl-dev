--!strict
-- @Foundation: ActionGuard (Global Logic Gatekeeper)
-- @Role: Mencegah Spam, Race Condition, dan Menghandle Confirmation Flow
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Signals = Loader.Get("Signals")

local ActionGuard = {}
local _isBusy = false -- Global Lock

-- [[ API UTAMA ]]
-- @param opts: { Confirm: {Title, Msg}, Debounce: number }
-- @param callback: Fungsi yang akan dijalankan jika lolos guard
function ActionGuard.Run(opts, callback)
    -- 1. Global Busy Check
    if _isBusy then 
        warn("[ActionGuard] System Busy / Spam Detected")
        return 
    end
    
    -- 2. Lock System
    _isBusy = true
    
    -- Helper untuk unlock (dipanggil saat selesai/batal)
    local function unlock()
        _isBusy = false
    end

    -- 3. Confirmation Flow
    if opts.Confirm then
        -- Kirim Sinyal ke UI System (FrameworkController) buat nampilin Dialog
        Signals:Fire("SystemUI:RequestConfirm", {
            Title = opts.Confirm.Title,
            Message = opts.Confirm.Msg,
            
            -- Callback Result dari UI
            OnResult = function(confirmed)
                if confirmed then
                    -- Eksekusi aksi nyata
                    local success, err = pcall(callback)
                    if not success then warn("[ActionGuard] Execution Error:", err) end
                end
                -- Buka gembok setelah user milih Yes/No atau Timeout
                unlock()
            end
        })
    else
        -- Langsung Eksekusi (Instant Action)
        local success, err = pcall(callback)
        if not success then warn("[ActionGuard] Execution Error:", err) end
        
        -- Debounce sederhana buat Instant Action
        task.delay(opts.Debounce or 0.5, unlock)
    end
end

return ActionGuard
