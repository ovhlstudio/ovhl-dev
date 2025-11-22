-- @Core: Context (DI Container)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local SmartLogger = Loader.Core("SmartLogger")
local Signals = Loader.Core("Signals")
local Manifest = Loader.Core("Manifest") -- [NEW] Import Manifest

local Context = {}
Context.__index = Context

function Context.New(services)
    local self = setmetatable({}, Context)
    
    -- 1. Inject Core Systems
    self.Manifest = Manifest -- [NEW] Exposed to Services
    self.Signals = Signals
    self.Services = services or {}
    
    -- 2. Logger Factory Helper
    function self:CreateLogger(domain)
        return SmartLogger.New(domain)
    end
    
    -- 3. Inject Dependencies
    for name, service in pairs(self.Services) do
        self[name] = service
    end

    return self
end

return Context
