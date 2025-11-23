--!strict
-- @Adapter: HDAdmin (REFACTORED)
local RS = game:GetService("ReplicatedStorage")

local HD = {}
local _api = nil

-- Non-Blocking Wait Function
function HD.WaitForAPI(timeout)
    if _api then return true end
    
    local start = os.clock()
    timeout = timeout or 5
    
    -- Attempt 1: Check Global Directly
    if _G.HDAdminMain then 
        _api = _G.HDAdminMain
        return true
    end

    -- Attempt 2: Scan safely
    repeat
        local setup = RS:FindFirstChild("HDAdminSetup")
        if setup and setup:IsA("ModuleScript") then
            local success, mod = pcall(require, setup)
            if success and mod and mod.GetMain then
                _api = mod:GetMain()
                return true
            end
        end
        
        task.wait(1) -- Polling acceptable here ONLY inside task.spawn context
    until (os.clock() - start) > timeout
    
    return false
end

-- Fallback Function
function HD.StartScan(logger)
    -- Deprecated: Handled by Service Logic now
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
