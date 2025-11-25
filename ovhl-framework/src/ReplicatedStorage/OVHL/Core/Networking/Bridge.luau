--!strict
-- @Component: NetworkBridge (Client/Shared v0.2.2)
-- @Role: Client Gateway & Packet Dispatcher
-- @Mandate: Mandat 1 (Single Remote) & Retry Policy

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local Promise = Loader.Get("Promise")
local Signal = Loader.Get("Signal")
local Enums = Loader.Get("Enums")

local Bridge = {}
Bridge.__index = Bridge

local GATEWAY_NAME = "OVHL_Gateway"
local STREAM_NAME = "OVHL_Stream"

function Bridge.New()
	local self = setmetatable({
		_gateway = nil :: RemoteFunction?,
		_stream = nil :: RemoteEvent?,
		_signals = {} :: { [string]: any },
		_isClient = RunService:IsClient(),
	}, Bridge)

	if self._isClient then
		self:_initClient()
	end

	return self
end

function Bridge:_initClient()
	local remotes = ReplicatedStorage:WaitForChild("OVHL_Remotes", 10)
	if not remotes then
		warn("⚠️ [Bridge] 'OVHL_Remotes' folder missing! Server might be lagging.")
		return
	end

	self._gateway = remotes:WaitForChild(GATEWAY_NAME, 10) :: RemoteFunction
	self._stream = remotes:WaitForChild(STREAM_NAME, 10) :: RemoteEvent

	if self._stream then
		self._stream.OnClientEvent:Connect(function(packet)
			self:_dispatchLocal(packet)
		end)
	else
		warn("⚠️ [Bridge] Remote Stream missing.")
	end
end

function Bridge:_dispatchLocal(packet)
	if type(packet) ~= "table" then
		return
	end
	if packet.T ~= Enums.Packet.EVENT then
		return
	end

	local service = packet.S
	local event = packet.E

	if service and event then
		local key = service .. "/" .. event
		local sig = self._signals[key]
		if sig then
			if type(packet.D) == "table" then
				sig:Fire(table.unpack(packet.D))
			else
				sig:Fire(packet.D)
			end
		end
	end
end

-- [[ PUBLIC API ]]

function Bridge:Request(serviceName: string, methodName: string, ...: any)
	if not self._isClient then
		error("Bridge:Request is Client-Only.")
	end

	local args = { ... }

	return Promise.new(function(resolve, reject)
		if not self._gateway then
			return reject("Bridge Gateway not connected")
		end

		local packet = {
			T = Enums.Packet.REQUEST,
			S = serviceName,
			M = methodName,
			A = args,
		}

		local success, response = pcall(function()
			return self._gateway:InvokeServer(packet)
		end)

		if not success then
			return reject("Network Fail: " .. tostring(response))
		end

		if type(response) == "table" then
			if response.C == Enums.Status.OK then
				resolve(response.D)
			else
				reject(response.E or "Server Error " .. tostring(response.C))
			end
		else
			reject("Invalid Protocol Response")
		end
	end)
end

-- [NEW] RETRY POLICY IMPLEMENTATION
-- options: { Retries = 3, Interval = 1 }
function Bridge:RequestWithRetry(serviceName: string, methodName: string, options: any, ...: any)
	local args = { ... }
	local retries = options and options.Retries or 3
	local interval = options and options.Interval or 1

	return Promise.new(function(resolve, reject)
		local attempts = 0

		local function attempt()
			attempts += 1
			self:Request(serviceName, methodName, table.unpack(args)):andThen(resolve):catch(function(err)
				if attempts < retries then
					-- Log peringatan kecil (Opsional, agar dev tau ada retry)
					-- print(string.format("🔄 Retry %d/%d for %s:%s - %s", attempts, retries, serviceName, methodName, tostring(err)))
					task.wait(interval)
					attempt()
				else
					reject(err) -- Gagal total setelah N percobaan
				end
			end)
		end

		attempt()
	end)
end

function Bridge:Listen(serviceName: string, eventName: string, callback: (...any) -> ())
	local key = serviceName .. "/" .. eventName
	if not self._signals[key] then
		self._signals[key] = Signal.new()
	end
	return self._signals[key]:Connect(callback)
end

-- Mock Server Methods
function Bridge:Register(_, _)
	return {}
end
function Bridge:Bind(_, _) end
function Bridge:Fire() end
function Bridge:FireAll() end

return Bridge
