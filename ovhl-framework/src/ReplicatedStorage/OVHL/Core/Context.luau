--!strict
-- @Core: Context (DI Container)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- [MIGRATION] Use Dot Syntax Internally
local SmartLogger = Loader.Core.SmartLogger
local Signals = Loader.Core.Signals
local Manifest = Loader.Core.Manifest 

local Context = {}
Context.__index = Context

function Context.New(services)
    local self = setmetatable({}, Context)
    
    self.Manifest = Manifest
    self.Signals = Signals
    self.Services = services or {}
    
    function self:CreateLogger(domain: string)
        return SmartLogger.New(domain)
    end
    
    -- Inject Dependencies
    for name, service in pairs(self.Services) do
        self[name] = service
    end

    return self
end

return Context
