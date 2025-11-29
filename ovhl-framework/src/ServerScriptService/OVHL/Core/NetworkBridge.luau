--!strict
-- @Component: NetworkBridge (Server v0.3.0)
-- @Role: Central Packet Router & Security Gatekeeper

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.OVHL.Core.Loader)

-- [CLEAN IMPORT] No Hardcode Path
local Enums = Loader.Get("Enums")
local TypeValidator = Loader.Get("TypeValidator")
local Guard = Loader.Get("NetworkGuard") -- <-- NEW

local Bridge = {}
Bridge.__index = Bridge

local GATEWAY_NAME = "OVHL_Gateway"
local STREAM_NAME = "OVHL_Stream"

function Bridge.New(ctx)
	local secLog = ctx:CreateLogger("SECURITY")
	local netLog = ctx:CreateLogger("NETWORK")

	local self = setmetatable({
		_logger = netLog,
		_secLog = secLog,
		_limit = ctx.RateLimiter,
		_root = nil :: Instance?,
		_gateway = nil :: RemoteFunction?,
		_stream = nil :: RemoteEvent?,
		_routes = {}, 
		_services = {}, 
	}, Bridge)

	self:_initRemotes()
	return self
end

function Bridge:_initRemotes()
	local root = ReplicatedStorage:FindFirstChild("OVHL_Remotes")
	if not root then
		root = Instance.new("Folder")
		root.Name = "OVHL_Remotes"
		root.Parent = ReplicatedStorage
	end
	self._root = root

	local gw = root:FindFirstChild(GATEWAY_NAME)
	if not gw then
		gw = Instance.new("RemoteFunction")
		gw.Name = GATEWAY_NAME
		gw.Parent = root
	end
	self._gateway = gw :: RemoteFunction

	self._gateway.OnServerInvoke = function(player, packet)
		return self:_handlePacket(player, packet)
	end

	local st = root:FindFirstChild(STREAM_NAME)
	if not st then
		st = Instance.new("RemoteEvent")
		st.Name = STREAM_NAME
		st.Parent = root
	end
	self._stream = st :: RemoteEvent
end

function Bridge:_handlePacket(player: Player, packet: any)
	if type(packet) ~= "table" then return { C = Enums.Status.BAD_REQUEST } end
	if packet.T ~= Enums.Packet.REQUEST then return nil end

	local srvName = packet.S
	local mtdName = packet.M
	local rawArgs = packet.A or {}

	local serviceRoute = self._routes[srvName]
	if not serviceRoute then return { C = Enums.Status.NOT_FOUND } end
	local methodRoute = serviceRoute[mtdName]
	if not methodRoute then return { C = Enums.Status.NOT_FOUND } end

	local rules = methodRoute.Rules

	-- RATE LIMIT
	local limitKey = srvName .. ":" .. mtdName
	if rules.RateLimit and self._limit then
		if not self._limit:Check(player, limitKey, rules.RateLimit.Max, rules.RateLimit.Interval) then
			return { C = Enums.Status.RATE_LIMITED }
		end
	end

	-- VALIDATION
	if rules.Args then
		local ok, err = TypeValidator.Validate(rawArgs, rules.Args)
		if not ok then return { C = Enums.Status.BAD_REQUEST, E = "Args Error" } end
	end

	-- SANITIZATION (Inbound)
	local cleanArgs = {}
	for i, v in ipairs(rawArgs) do
		cleanArgs[i] = Guard.CleanIn(v, 0, player)
	end

	-- EXECUTION
	local serviceInstance = self._services[srvName]
	if serviceInstance and serviceInstance[mtdName] then
		local success, result = pcall(serviceInstance[mtdName], serviceInstance, player, table.unpack(cleanArgs))

		if not success then
			self._logger:Error("ExecError", { Err = result })
			return { C = Enums.Status.INTERNAL_ERROR }
		end

		-- SANITIZATION (Outbound)
		local sanitized = Guard.SanitizeOutbound(result)
		
		-- Legacy Wrapper Support
		if type(sanitized) == "table" and sanitized.Success ~= nil then
			if sanitized.Success then
				return { C = Enums.Status.OK, D = sanitized.Data }
			else
				return { C = Enums.Status.BAD_REQUEST, E = sanitized.Error }
			end
		end

		return { C = Enums.Status.OK, D = sanitized }
	end

	return { C = Enums.Status.INTERNAL_ERROR }
end

function Bridge:Register(serviceName, netConfig)
	if not self._routes[serviceName] then self._routes[serviceName] = {} end
	local reqs = netConfig and netConfig.Requests or {}
	for methodName, rules in pairs(reqs) do
		self._routes[serviceName][methodName] = { Rules = rules }
	end
end

function Bridge:Bind(name, srv) self._services[name] = srv end

function Bridge:Fire(player: Player, serviceName: string, eventName: string, ...: any)
	if self._stream then
		self._stream:FireClient(player, {
			T = Enums.Packet.EVENT, S = serviceName, E = eventName, D = { ... }
		})
	end
end

function Bridge:FireAll(serviceName: string, eventName: string, ...: any)
	if self._stream then
		self._stream:FireAllClients({
			T = Enums.Packet.EVENT, S = serviceName, E = eventName, D = { ... }
		})
	end
end

return Bridge
