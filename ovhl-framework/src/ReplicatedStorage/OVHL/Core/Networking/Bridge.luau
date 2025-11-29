--!strict
-- @Component: NetworkBridge v1.1 (Latency Tracer)
-- @Role: Client Gateway with Timeout Protection & Latency Logs
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
local Promise = Loader.Get("Promise")
local Signal = Loader.Get("Signal")
local Enums = Loader.Get("Enums")
local Constants = Loader.Get("Constants")
local SmartLogger = Loader.Get("Logger") -- [NEW] Need Logger

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
        _logger = SmartLogger.New("NETWORK") -- [NEW] Internal Logger
	}, Bridge)

	if self._isClient then self:_initClient() end
	return self
end

function Bridge:_initClient()
	local remotes = ReplicatedStorage:WaitForChild("OVHL_Remotes", 10)
	if not remotes then warn("⚠️ [Bridge] 'OVHL_Remotes' missing!"); return end
	self._gateway = remotes:WaitForChild(GATEWAY_NAME, 10) :: RemoteFunction
	self._stream = remotes:WaitForChild(STREAM_NAME, 10) :: RemoteEvent
	if self._stream then
		self._stream.OnClientEvent:Connect(function(p) self:_dispatchLocal(p) end)
	end
end

function Bridge:_dispatchLocal(packet)
	if type(packet) ~= "table" then return end
	if packet.T ~= Enums.Packet.EVENT then return end
	local key = packet.S .. "/" .. packet.E
	local sig = self._signals[key]
	if sig then
		if type(packet.D) == "table" then sig:Fire(table.unpack(packet.D)) else sig:Fire(packet.D) end
	end
end

-- [[ PUBLIC API ]]

function Bridge:Request(serviceName: string, methodName: string, ...: any)
	if not self._isClient then error("Bridge:Request is Client-Only.") end
	local args = { ... }

	return Promise.new(function(resolve, reject)
		if not self._gateway then return reject("Bridge Gateway not connected") end

        -- [LATENCY TRACKER]
        local startTime = os.clock()
        local timeOut = Constants.NET.TIMEOUT or 10
        local hasResponded = false
        
        task.delay(timeOut, function()
            if not hasResponded then
                self._logger:Error("Timeout", { Route=serviceName..":"..methodName, Wait=timeOut })
                reject("Request Timed Out ("..timeOut.."s)")
            end
        end)

		local packet = { T = Enums.Packet.REQUEST, S = serviceName, M = methodName, A = args }

		local success, response = pcall(function()
			return self._gateway:InvokeServer(packet)
		end)
        
        hasResponded = true
        
        -- [LOG LATENCY]
        local duration = (os.clock() - startTime) * 1000 -- ms
        self._logger:Debug("Trace", { 
            Route = serviceName..":"..methodName, 
            Ping = string.format("%.0fms", duration) 
        })

		if not success then return reject("Network Fail: " .. tostring(response)) end

		if type(response) == "table" then
			if response.C == Enums.Status.OK then resolve(response.D)
			else reject(response.E or "Server Error " .. tostring(response.C)) end
		else
			reject("Invalid Protocol Response")
		end
	end)
end

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
					task.wait(interval)
					attempt()
				else
					reject(err)
				end
			end)
		end
		attempt()
	end)
end

function Bridge:Listen(serviceName: string, eventName: string, callback: (...any) -> ())
	local key = serviceName .. "/" .. eventName
	if not self._signals[key] then self._signals[key] = Signal.new() end
	return self._signals[key]:Connect(callback)
end

-- Server Mocks
function Bridge:Register(_, _) return {} end
function Bridge:Bind(_, _) end
function Bridge:Fire() end
function Bridge:FireAll() end

return Bridge
