--!strict
-- @Service: ShowcaseService (Ping Handler)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local Cfg = require(Loader.Module("Showcase").SharedConfig)

local Srv = {}

function Srv:Init(ctx)
    self.Logger = ctx:CreateLogger("SHOWCASE_SRV")
    self.Network = ctx.Network
    
    -- Register Route
    self.Network:Register("Showcase", Cfg.Network)
    self.Network:Bind("Showcase", self)
end

function Srv:Start() end

-- [HANDLER] Sekarang Ping adalah Request (ada return)
function Srv:Ping(player)
    -- Jika sampai sini, berarti lolos Rate Limit Bridge
    -- Kita kembalikan Server Time untuk sync
    return { 
        Msg = "Pong!", 
        ServerTime = os.time(),
        Clock = os.clock()
    }
end

return Srv
