--!strict
-- @Component: NetworkBridge (Shared v2.3 - Fixed Request Logic)
-- @Role: Traffic Controller & Security Checkpoint
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local Promise = Loader.Get("Promise")

local Bridge = {}
Bridge.__index = Bridge

local IS_SERVER = RunService:IsServer()

-- Lazy load Server modules
local Guard, TypeValidator
if IS_SERVER then
	Guard = require(ServerScriptService.OVHL.Core.NetworkGuard)
	TypeValidator = Loader.Get("TypeValidator")
end

function Bridge.New(ctx)
	local self = setmetatable({
		_root = nil,
	}, Bridge)

	if IS_SERVER then
		-- SERVER SIDE SETUP
		local secLog = ctx:CreateLogger("SECURITY")
		local netLog = ctx:CreateLogger("NETWORK")
		self._logger = netLog
		self._secLog = secLog
		self._limit = ctx.RateLimiter

		self._root = ReplicatedStorage:FindFirstChild("OVHL_Remotes") or Instance.new("Folder", ReplicatedStorage)
		self._root.Name = "OVHL_Remotes"
		self._services = {}

		self._secLog:Info("System", "🛡️ Security Systems (Guard & Limiter) Connected")
	else
		-- CLIENT SIDE SETUP
		-- Tunggu folder remotes (Max 20 detik)
		self._root = ReplicatedStorage:WaitForChild("OVHL_Remotes", 20)
		if not self._root then
			warn("[Bridge] Critical: OVHL_Remotes folder not found after 20s!")
		end
	end

	return self
end

-- [[ SERVER API ]]
function Bridge:Register(serviceName, netConfig)
	if not IS_SERVER then
		return
	end

	local reqs = netConfig and netConfig.Requests or {}
	for methodName, rules in pairs(reqs) do
		-- NAMA REMOTE: Service_Method
		local remoteName = serviceName .. "_" .. methodName
		local rf = self._root:FindFirstChild(remoteName) or Instance.new("RemoteFunction", self._root)
		rf.Name = remoteName

		local limitKey = serviceName .. ":" .. methodName
		if rules.RateLimit and self._limit then
			self._limit:SetRule(limitKey, rules.RateLimit.Max, rules.RateLimit.Interval)
		end

		rf.OnServerInvoke = function(player, ...)
			return self:_handleInvoke(player, serviceName, methodName, rules, ...)
		end
	end

	local events = netConfig and netConfig.Events or {}
	for _, eventName in ipairs(events) do
		-- NAMA REMOTE: Service/Event
		local remoteName = serviceName .. "/" .. eventName
		local re = self._root:FindFirstChild(remoteName) or Instance.new("RemoteEvent", self._root)
		re.Name = remoteName
	end

	return {
		OnInvoke = function() end,
		Fire = function(...) end,
	}
end

function Bridge:_handleInvoke(player, serviceName, methodName, rules, ...)
	-- A. Rate Limit
	local limitKey = serviceName .. ":" .. methodName
	if rules.RateLimit and self._limit and not self._limit:Check(player, limitKey) then
		self._secLog:Warn("RateLimit", { Plr = player.Name, Action = methodName })
		return { Success = false, Error = "Too Many Requests", Code = 429 }
	end

	-- B. Inbound Guard
	local rawArgs = { ... }
	local cleanArgs = {}
	for i, v in ipairs(rawArgs) do
		cleanArgs[i] = Guard.CleanIn(v, 0, player)
	end

	-- C. Type Validation
	if rules.Args then
		local ok, err = TypeValidator.Validate(cleanArgs, rules.Args)
		if not ok then
			return { Success = false, Error = "Invalid Arguments", Code = 400 }
		end
	end

	-- D. Execution
	local service = self._services[serviceName]
	if service and service[methodName] then
		local success, result = pcall(service[methodName], service, player, table.unpack(cleanArgs))
		if not success then
			return { Success = false, Error = "Internal Server Error" }
		end

		-- E. Outbound Guard
		local sanitized = Guard.SanitizeOutbound(result)
		if type(sanitized) == "table" and sanitized.Success ~= nil then
			return sanitized
		end
		return { Success = true, Data = sanitized }
	end

	return { Success = false, Error = "Service Not Bound" }
end

function Bridge:Bind(name, srv)
	self._services[name] = srv
end

function Bridge:Fire(player, serviceName, eventName, ...)
	if not IS_SERVER then
		return
	end
	local remoteName = serviceName .. "/" .. eventName
	local re = self._root:FindFirstChild(remoteName)
	if re then
		re:FireClient(player, ...)
	end
end

function Bridge:FireAll(serviceName, eventName, ...)
	if not IS_SERVER then
		return
	end
	local remoteName = serviceName .. "/" .. eventName
	local re = self._root:FindFirstChild(remoteName)
	if re then
		re:FireAllClients(...)
	end
end

-- [[ CLIENT API ]]
-- [FIX] Parameter sekarang (serviceName, methodName, ...args)
function Bridge:Request(serviceName, methodName, ...)
	if IS_SERVER then
		error("Request is Client-Only")
	end
	local args = { ... }

	return Promise.new(function(resolve, reject)
		if not self._root then
			return reject("Bridge not initialized")
		end

		-- [FIX] Target nama remote yang benar: Service_Method
		local remoteName = serviceName .. "_" .. methodName

		-- Timeout 20s
		local rf = self._root:WaitForChild(remoteName, 45)
		if not rf then
			return reject("Timeout: Remote '" .. remoteName .. "' not found")
		end

		local result = rf:InvokeServer(table.unpack(args))

		if type(result) == "table" and result.Success ~= nil then
			if result.Success then
				resolve(result.Data)
			else
				reject(result.Error)
			end
		else
			resolve(result)
		end
	end)
end

function Bridge:Listen(serviceName, eventName, callback)
	if IS_SERVER then
		return
	end
	if not self._root then
		return
	end

	local remoteName = serviceName .. "/" .. eventName
	local re = self._root:WaitForChild(remoteName, 45)
	if re then
		re.OnClientEvent:Connect(callback)
	end
end

return Bridge
