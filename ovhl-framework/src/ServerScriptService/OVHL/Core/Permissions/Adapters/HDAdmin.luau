--!strict
-- @Adapter: HDAdmin
-- Menghubungkan diri ke _G.HDAdminMain
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local HD = {}
local _api = nil
local _scanning = false

function HD.StartScan(logger)
    if _api or _scanning then return end
    _scanning = true
    
    local start = os.clock()
    
    task.spawn(function()
        while (os.clock() - start) < 10 do
            if _G.HDAdminMain then
                _api = _G.HDAdminMain
                break
            end
            
            local setup = RS:FindFirstChild("HDAdminSetup")
            if setup then
                local s, m = pcall(require, setup)
                if s and m and m.GetMain then
                    _api = m:GetMain()
                    break
                end
            end
            task.wait(1)
        end
        
        -- [FIX] Logger Check sebelum Info/Warn (untuk menghindari crash)
        if logger then
            if _api then
                logger:Info("Link", "HD Admin API Connected")
            else
                logger:Warn("Link", "HD Admin API Not Found (Timeout)")
            end
        end
        _scanning = false
    end)
end

function HD.GetRank(player)
    if not _api then return 0 end
    
    local s, cf = pcall(function() return _api:GetModule("cf") end)
    if s and cf then
        local id = cf:GetRankId(player)
        return tonumber(id) or 0
    end
    return 0
end

return HD
