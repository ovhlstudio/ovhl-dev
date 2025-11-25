--!strict
-- @Kernel: Server v0.2.0 (Lifecycle Managed)
-- @Role: Service Bootstrapper & Lifecycle Manager
-- @Mandate: Mandat 4 (Memory Management & Shutdown)

local ServerScriptService = game:GetService("ServerScriptService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

-- Core Dependencies
local Context = Loader.Get("Context")
local SmartLogger = Loader.Get("Logger")
local Manifest = Loader.Get("Manifest")
-- [NOTE] Bridge masih menggunakan versi v0.1.0 (belum direfactor di Fase 2), path tetap aman.
local Bridge = Loader.Server("Core/NetworkBridge")

-- Adapters (Database/Admin)
local Adapters = {
	DB = require(ServerScriptService.OVHL.Core.Permissions.Adapters.InternalDB),
	HD = require(ServerScriptService.OVHL.Core.Permissions.Adapters.HDAdmin),
}

local ServerKernel = {}
ServerKernel._services = {} -- [NEW] Stateful storage for cleanup access
ServerKernel._isShuttingDown = false

function ServerKernel.Boot()
	local Log = SmartLogger.New("SYSTEM")

	-- 1. Header Log
	Log:Info(
		string.format(
			"🚀 %s v%s (%s) SERVER STARTING...",
			Manifest.Identity.Name,
			Manifest.Version.Full,
			Manifest.Metadata.BuildType
		)
	)

	-- 2. Service Discovery (Collecting)
	local services = {}

	local function register(module: Instance, featureName: string?)
		if module:IsA("ModuleScript") then
			local success, result = pcall(require, module)
			if success then
				local finalName = module.Name
				-- Normalisasi nama Service (misal: "Inventory" -> "InventoryService")
				if featureName and (module.Name == "Service" or module.Name == "Service.luau") then
					finalName = featureName .. "Service"
				end

				services[finalName] = result
				Log:Debug(string.format("   + Service Registered: %-20s (Source: %s)", finalName, module.Name))
			else
				Log:Error("RegisterFail", { Module = module.Name, Error = result })
			end
		end
	end

	Log:Info("🔍 Scanning Services...")

	-- A. Core Services
	local coreFolder = ServerScriptService.OVHL.Services
	for _, mod in ipairs(coreFolder:GetChildren()) do
		register(mod)
	end

	-- B. Feature Modules Services
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

	-- 3. Dependency Injection
	services.Adapters = Adapters
	local ctx = Context.New(services)

	-- Inject Network Bridge (Critical)
	ctx.Network = Bridge.New(ctx)

	-- Simpan referensi ke Module Level untuk Shutdown nanti
	ServerKernel._services = services
	ServerKernel._logger = Log

	-- 4. Lifecycle: Init
	Log:Info("Phase 1: Init")
	for name, srv in pairs(services) do
		if type(srv.Init) == "function" then
			local s, err = pcall(srv.Init, srv, ctx)
			if not s then
				Log:Error("InitCrash", { Service = name, Error = err })
			end
		end
	end

	-- 5. Lifecycle: Start
	Log:Info("Phase 2: Start")
	for name, srv in pairs(services) do
		if type(srv.Start) == "function" then
			task.spawn(function()
				local s, err = pcall(srv.Start, srv)
				if not s then
					Log:Error("StartCrash", { Service = name, Error = err })
				end
			end)
		end
	end

	Log:Info("✅ SERVER BOOT COMPLETE")

	-- 6. Bind Shutdown (The Anti-Leak Guard)
	game:BindToClose(function()
		ServerKernel.Shutdown()
	end)
end

function ServerKernel.Shutdown()
	if ServerKernel._isShuttingDown then
		return
	end
	ServerKernel._isShuttingDown = true

	local Log = ServerKernel._logger or SmartLogger.New("SYSTEM")
	Log:Warn("🛑 SERVER SHUTDOWN INITIATED...")

	-- Loop semua service untuk cleanup
	for name, srv in pairs(ServerKernel._services) do
		-- Prioritas 1: Method Shutdown eksplisit
		if type(srv.Shutdown) == "function" then
			local s, err = pcall(srv.Shutdown, srv)
			if not s then
				warn("[Shutdown] Error in " .. name .. ": " .. tostring(err))
			end

		-- Prioritas 2: Trove Cleanup (Framework Standard)
		elseif srv.Trove and type(srv.Trove.Destroy) == "function" then
			srv.Trove:Destroy()
		end
	end

	Log:Info("👋 Server Goodbye.")
end

return ServerKernel
