-- @Core: Bootstrap
local RunService = game:GetService("RunService")
local Bootstrap = {}

function Bootstrap.StartServer()
    if not RunService:IsServer() then return end
    require(game.ServerScriptService.OVHL.Core.ServerKernel).Boot()
end

function Bootstrap.StartClient()
    if not RunService:IsClient() then return end
    local PS = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
    require(PS.OVHL.Core.ClientKernel).Boot()
end

return Bootstrap
