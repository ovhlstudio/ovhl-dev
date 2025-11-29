--!strict
-- @Kernel: Server v0.3.0
-- @Role: Service Bootstrapper & Lifecycle Manager
local ServerScriptService = game:GetService("ServerScriptService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Context = Loader.Get("Context")
local SmartLogger = Loader.Get("Logger")
local Manifest = Loader.Get("Manifest")
-- Bootstrap Import
local Bridge = require(ServerScriptService.OVHL.Core.NetworkBridge) 

local ServerKernel = {}
ServerKernel._services = {} 
ServerKernel._isShuttingDown = false

function ServerKernel.Boot()
	local Log = SmartLogger.New("SYSTEM")
	Log:Info(string.format("🚀 %s v%s SERVER STARTING...", Manifest.Identity.Name, Manifest.Version.Full))

	local services = {}
	local function register(module: Instance, featureName: string?)
		if module:IsA("ModuleScript") then
			local success, result = pcall(require, module)
			if success then
				local finalName = module.Name
				if featureName and (module.Name == "Service" or module.Name == "Service.luau") then
					finalName = featureName .. "Service"
				end
				services[finalName] = result
				Log:Debug(string.format("   + Service: %-20s", finalName))
			else
				Log:Error("RegisterFail", { Module = module.Name, Error = result })
			end
		end
	end

	Log:Info("Scan", "Scanning Services...")
	local coreFolder = ServerScriptService.OVHL.Services
	for _, mod in ipairs(coreFolder:GetChildren()) do register(mod) end

	local modulesFolder = ServerScriptService.OVHL.Modules
	for _, feature in ipairs(modulesFolder:GetChildren()) do
		if feature:IsA("Folder") then
			for _, file in ipairs(feature:GetChildren()) do
				if file.Name:match("Service$") or file.Name == "Service" then
					register(file, feature.Name)
				end
			end
		end
	end

	-- Dependency Injection (Clean Path)
	services.Adapters = { DB = Loader.Get("InternalDB"), HD = Loader.Get("HDAdmin") }
	local ctx = Context.New(services)
	ctx.Network = Bridge.New(ctx) 

	ServerKernel._services = services
	ServerKernel._logger = Log

	-- Lifecycle
	for name, srv in pairs(services) do
		if type(srv.Init) == "function" then
			local s, err = pcall(srv.Init, srv, ctx)
			if not s then Log:Error("InitCrash", { Service = name, Error = err }) end
		end
	end

	for name, srv in pairs(services) do
		if type(srv.Start) == "function" then
			task.spawn(function()
				local s, err = pcall(srv.Start, srv)
				if not s then Log:Error("StartCrash", { Service = name, Error = err }) end
			end)
		end
	end

	Log:Info("Boot", "✅ SERVER BOOT COMPLETE")
	game:BindToClose(function() ServerKernel.Shutdown() end)
end

function ServerKernel.Shutdown()
	if ServerKernel._isShuttingDown then return end
	ServerKernel._isShuttingDown = true
	local Log = ServerKernel._logger or SmartLogger.New("SYSTEM")
	Log:Warn("Shutdown", "🛑 SERVER SHUTDOWN INITIATED...")

	for name, srv in pairs(ServerKernel._services) do
		if type(srv.Shutdown) == "function" then pcall(srv.Shutdown, srv)
		elseif srv.Trove and type(srv.Trove.Destroy) == "function" then srv.Trove:Destroy() end
	end
	Log:Info("Shutdown", "👋 Server Goodbye.")
end

return ServerKernel
