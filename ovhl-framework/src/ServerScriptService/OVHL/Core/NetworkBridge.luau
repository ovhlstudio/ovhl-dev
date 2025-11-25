--!strict
-- @Component: NetworkBridge (Server v0.2.1)
-- @Role: Central Packet Router & Security Gatekeeper
-- @Mandate: Mandat 1 (Single Remote) & Mandat 3 (Pipeline Reordering)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local Enums = Loader.Get("Enums")
local TypeValidator = Loader.Get("TypeValidator")

-- [DEPENDENCY NOTE]
-- NetworkGuard akan kita optimasi total di Fase 3.
-- Tapi di Fase 2 ini, kita sudah menempatkan pemanggilannya di urutan yang benar (setelah validasi).
local Guard = require(ServerScriptService.OVHL.Core.NetworkGuard)

local Bridge = {}
Bridge.__index = Bridge

-- [CONSTANTS]
local GATEWAY_NAME = "OVHL_Gateway"
local STREAM_NAME = "OVHL_Stream"

function Bridge.New(ctx)
	-- Create Dedicated Security Logger
	local secLog = ctx:CreateLogger("SECURITY")
	local netLog = ctx:CreateLogger("NETWORK")

	local self = setmetatable({
		_logger = netLog,
		_secLog = secLog,
		_limit = ctx.RateLimiter,

		_root = nil :: Instance?,
		_gateway = nil :: RemoteFunction?,
		_stream = nil :: RemoteEvent?,

		-- Routing Tables (Pengganti Multiple Remotes)
		_routes = {}, -- [Service][Method] = { Rules, Handler }
		_services = {}, -- [Service] = ServiceInstance
	}, Bridge)

	self:_initRemotes()
	self._secLog:Info("System", "🛡️ Single Gateway Architecture Online")

	return self
end

function Bridge:_initRemotes()
	-- [FIX] Instance.new Parent Argument Deprecated Fix
	local root = ReplicatedStorage:FindFirstChild("OVHL_Remotes")
	if not root then
		root = Instance.new("Folder")
		root.Name = "OVHL_Remotes"
		root.Parent = ReplicatedStorage -- Set Parent Last
	end
	self._root = root

	-- 1. Gateway (Request-Response)
	local gw = root:FindFirstChild(GATEWAY_NAME)
	if not gw then
		gw = Instance.new("RemoteFunction")
		gw.Name = GATEWAY_NAME
		gw.Parent = root -- Set Parent Last
	end
	self._gateway = gw :: RemoteFunction

	-- Handle Incoming Traffic
	self._gateway.OnServerInvoke = function(player, packet)
		return self:_handlePacket(player, packet)
	end

	-- 2. Stream (Fire-Forget Events)
	local st = root:FindFirstChild(STREAM_NAME)
	if not st then
		st = Instance.new("RemoteEvent")
		st.Name = STREAM_NAME
		st.Parent = root -- Set Parent Last
	end
	self._stream = st :: RemoteEvent
end

-- [[ CORE: PACKET ROUTER ]]
function Bridge:_handlePacket(player: Player, packet: any)
	-- 1. Basic Integrity Check
	if type(packet) ~= "table" then
		return { C = Enums.Status.BAD_REQUEST, E = "Invalid Packet Format" }
	end

	-- Protocol: T=Type, S=Service, M=Method, A=Args
	if packet.T ~= Enums.Packet.REQUEST then
		return nil
	end

	local srvName = packet.S
	local mtdName = packet.M
	local rawArgs = packet.A or {}

	-- 2. Route Lookup
	local serviceRoute = self._routes[srvName]
	if not serviceRoute then
		return { C = Enums.Status.NOT_FOUND, E = "Service Not Found" }
	end

	local methodRoute = serviceRoute[mtdName]
	if not methodRoute then
		return { C = Enums.Status.NOT_FOUND, E = "Method Not Found" }
	end

	local rules = methodRoute.Rules

	-- 3. PIPELINE STEP A: RATE LIMIT (Murah)
	-- Cek kuota dulu sebelum proses data berat
	local limitKey = srvName .. ":" .. mtdName
	if rules.RateLimit and self._limit then
		if not self._limit:Check(player, limitKey, rules.RateLimit.Max, rules.RateLimit.Interval) then
			self._secLog:Warn("RateLimit", { Plr = player.Name, Action = limitKey })
			return { C = Enums.Status.RATE_LIMITED, E = "Too Many Requests" }
		end
	end

	-- 4. PIPELINE STEP B: TYPE VALIDATION (Cepat)
	-- Pastikan struktur data benar DULU sebelum disanitasi
	if rules.Args then
		local ok, err = TypeValidator.Validate(rawArgs, rules.Args)
		if not ok then
			self._secLog:Debug("InvalidArgs", { Plr = player.Name, Act = limitKey, Err = err })
			return { C = Enums.Status.BAD_REQUEST, E = "Invalid Arguments" }
		end
	end

	-- 5. PIPELINE STEP C: SANITIZATION (Berat - CPU Intensive)
	-- Hanya jalankan jika lolos validasi tipe
	local cleanArgs = {}
	for i, v in ipairs(rawArgs) do
		-- Guard.CleanIn akan kita optimasi di Fase 3
		cleanArgs[i] = Guard.CleanIn(v, 0, player)
	end

	-- 6. EXECUTION (Business Logic)
	-- Panggil fungsi asli di Service
	local serviceInstance = self._services[srvName]
	if serviceInstance and serviceInstance[mtdName] then
		local success, result = pcall(serviceInstance[mtdName], serviceInstance, player, table.unpack(cleanArgs))

		if not success then
			self._logger:Error("ExecError", { Srv = srvName, Mtd = mtdName, Err = result })
			return { C = Enums.Status.INTERNAL_ERROR, E = "Internal Server Error" }
		end

		-- 7. OUTBOUND SANITIZATION
		local sanitized = Guard.SanitizeOutbound(result)

		-- Support Legacy Format Return { Success=true, Data=... } or Direct Data
		if type(sanitized) == "table" and sanitized.Success ~= nil then
			-- Jika Service return format lama
			if sanitized.Success then
				return { C = Enums.Status.OK, D = sanitized.Data }
			else
				return { C = Enums.Status.BAD_REQUEST, E = sanitized.Error }
			end
		end

		return { C = Enums.Status.OK, D = sanitized }
	end

	return { C = Enums.Status.INTERNAL_ERROR, E = "Service Not Bound Logic" }
end

-- [[ PUBLIC API ]]

function Bridge:Register(serviceName, netConfig)
	if not self._routes[serviceName] then
		self._routes[serviceName] = {}
	end

	-- Daftarkan Method (Requests)
	local reqs = netConfig and netConfig.Requests or {}
	for methodName, rules in pairs(reqs) do
		self._routes[serviceName][methodName] = {
			Rules = rules,
		}
	end

	-- Events tidak perlu didaftarkan di route karena one-way,
	-- tapi kita simpan meta-nya jika butuh validasi nanti.

	-- Return Handles (Compatibility)
	return {
		Fire = function(plr, evt, ...)
			self:Fire(plr, serviceName, evt, ...)
		end,
		FireAll = function(evt, ...)
			self:FireAll(serviceName, evt, ...)
		end,
	}
end

function Bridge:Bind(name, srv)
	self._services[name] = srv
end

-- Server Push (To Client)
function Bridge:Fire(player: Player, serviceName: string, eventName: string, ...: any)
	if self._stream then
		self._stream:FireClient(player, {
			T = Enums.Packet.EVENT,
			S = serviceName,
			E = eventName,
			D = { ... }, -- Pack args
		})
	end
end

function Bridge:FireAll(serviceName: string, eventName: string, ...: any)
	if self._stream then
		self._stream:FireAllClients({
			T = Enums.Packet.EVENT,
			S = serviceName,
			E = eventName,
			D = { ... },
		})
	end
end

return Bridge
