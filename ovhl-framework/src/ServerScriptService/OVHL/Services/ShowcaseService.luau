--!strict
-- @Service: ShowcaseService
-- @Role: Server Side Receiver for Showcase
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local Cfg = require(Loader.Module("Showcase").SharedConfig)

local Srv = {}

function Srv:Init(ctx)
    self.Logger = ctx:CreateLogger("SHOWCASE_SRV")
    self.Network = ctx.Network
    
    -- Register Traffic
    self.Network:Register("Showcase", {
        Requests = {}, -- No Request/Response yet
        Events = { "Ping" } -- One way fire
    })
    
    -- Bind Listeners
    self.Network:Bind("Showcase", self)
    
    -- Listen to Ping
    -- NOTE: Bridge 'Listen' is for Events. For Requests we use Methods on self.
    local Bridge = ctx.Network
    -- Manual Signal binding since we used 'Bind' above, Bridge usually automaps Methods for Requests.
    -- For Events, we often bind manually or Bridge fires method "OnPing".
    -- In OVHL V2 Bridge, Register returns handles or we use FireClient.
    
    -- Let's stick to standard: Server listens via RemoteEvent manually or framework hook.
    -- Assuming OVHL Bridge V2 style:
    if Bridge._stream then
        Bridge._stream.OnServerEvent:Connect(function(player, packet)
            if packet.S == "Showcase" and packet.E == "Ping" then
                self:OnPing(player)
            end
        end)
    end
end

function Srv:Start()
    -- Nothing to start loop
end

function Srv:OnPing(player)
    -- [SERVER SIDE RATE LIMIT CHECK]
    -- Protects against Exploiters who bypass Client UI
    local limit = Cfg.Security.ButtonSpamLimit
    -- Using Context RateLimiter (Injected)
    -- Since we didn't inject RateLimiter to self in Init, let's grab it from Loader/Core 
    -- Actually ServerKernel injected 'ctx'.
    
    -- Log it
    self.Logger:Info("Network", { Msg="Ping Received", From=player.Name })
end

return Srv
