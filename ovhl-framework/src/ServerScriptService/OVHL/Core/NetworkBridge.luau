--!strict
-- @Component: NetworkBridge (Server v2.1 - Luau Edition)
-- @Role: Traffic Controller & Security Checkpoint
local RS = game:GetService('ReplicatedStorage')
local SS = game:GetService('ServerScriptService')

local Guard = require(SS.OVHL.Core.NetworkGuard)
local Loader = require(RS.OVHL.Core.Loader)
local TypeValidator = Loader.Core("TypeValidator")

local Bridge = {}
Bridge.__index = Bridge

function Bridge.New(ctx)
    -- Create Dedicated Security Logger
    local secLog = ctx:CreateLogger("SECURITY")
    local netLog = ctx:CreateLogger("NETWORK")

    local self = setmetatable({ 
        _logger = netLog,
        _secLog = secLog,
        _limit = ctx.RateLimiter,
        _root = nil
    }, Bridge)
    
    self._root = RS:FindFirstChild('OVHL_Remotes') or Instance.new('Folder', RS)
    self._root.Name = 'OVHL_Remotes'
    self._services = {}
    
    -- [CCTV] Verification Log
    self._secLog:Info("System", "🛡️ Security Systems (Guard & Limiter) Connected")
    
    return self
end

function Bridge:Register(serviceName, netConfig)
    local reqs = netConfig and netConfig.Requests or {}
    for methodName, rules in pairs(reqs) do
        local remoteName = serviceName .. '_' .. methodName
        local rf = self._root:FindFirstChild(remoteName) or Instance.new('RemoteFunction', self._root)
        rf.Name = remoteName
        
        local limitKey = serviceName .. ':' .. methodName
        if rules.RateLimit and self._limit then
            self._limit:SetRule(limitKey, rules.RateLimit.Max, rules.RateLimit.Interval)
        end
        
        rf.OnServerInvoke = function(player, ...)
            return self:_handleInvoke(player, serviceName, methodName, rules, ...)
        end
    end

    local events = netConfig and netConfig.Events or {}
    for _, eventName in ipairs(events) do
        local remoteName = serviceName .. '/' .. eventName
        local re = self._root:FindFirstChild(remoteName) or Instance.new("RemoteEvent", self._root)
        re.Name = remoteName
    end
    
    return { OnInvoke = function() end, Fire = function(...) end }
end

function Bridge:_handleInvoke(player, serviceName, methodName, rules, ...)
    -- A. Rate Limit
    local limitKey = serviceName .. ':' .. methodName
    if rules.RateLimit and self._limit and not self._limit:Check(player, limitKey) then
        self._secLog:Warn("RateLimit", {Plr=player.Name, Action=methodName})
        return { Success=false, Error='Too Many Requests', Code=429 }
    end
    
    -- B. Inbound Guard
    local rawArgs = {...}
    local cleanArgs = {}
    for i,v in ipairs(rawArgs) do cleanArgs[i] = Guard.CleanIn(v, 0, player) end
    
    -- C. Type Validator
    if rules.Args then
        local ok, err = TypeValidator.Validate(cleanArgs, rules.Args)
        if not ok then return { Success=false, Error='Invalid Arguments', Code=400 } end
    end
    
    -- D. Execution
    local service = self._services[serviceName]
    if service and service[methodName] then
        local success, result = pcall(service[methodName], service, player, table.unpack(cleanArgs))
        if not success then return { Success=false, Error='Internal Server Error' } end
        
        -- E. Outbound Guard
        local sanitized = Guard.SanitizeOutbound(result)
        if type(sanitized) == "table" and sanitized.Success ~= nil then return sanitized end
        return { Success=true, Data=sanitized }
    end
    
    return { Success=false, Error='Service Not Bound' }
end

function Bridge:Bind(name, srv) self._services[name] = srv end
return Bridge
