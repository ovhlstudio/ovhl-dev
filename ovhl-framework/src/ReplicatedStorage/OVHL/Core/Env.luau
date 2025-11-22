-- @Core: Env
local RunService = game:GetService("RunService")

local Env = {}

function Env.IsStudio()
    return RunService:IsStudio()
end

function Env.IsServer()
    return RunService:IsServer()
end

function Env.IsClient()
    return RunService:IsClient()
end

function Env.MockDataStore()
    return Env.IsStudio()
end

return table.freeze(Env)
