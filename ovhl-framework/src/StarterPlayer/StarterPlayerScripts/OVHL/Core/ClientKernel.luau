--!strict
-- @Kernel: Client v0.2.2 (Final Fix)
-- @Role: Client Bootstrapper & Memory Guard
-- @Mandate: Mandat 4 (Memory Management)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

-- Core Dependencies
local ConfigLoader = Loader.Get("ConfigLoader")
local Bridge = Loader.Get("Bridge")
local Context = Loader.Get("Context")
local SmartLogger = Loader.Get("Logger")
local Manifest = Loader.Get("Manifest")

local ClientKernel = {}
ClientKernel._controllers = {}
ClientKernel._isShuttingDown = false

function ClientKernel.Boot()
	local Log = SmartLogger.New("SYSTEM")
	Log:Info(
		string.format(
			"🎮 %s v%s (%s) CLIENT STARTING...",
			Manifest.Identity.Name,
			Manifest.Version.Full,
			Manifest.Metadata.BuildType
		)
	)

	local systems = {
		ConfigLoader = ConfigLoader,
		Network = Bridge.New(),
		Controllers = {},
	}

	local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	local Root = PlayerScripts:WaitForChild("OVHL")

	local function register(module: Instance)
		if module:IsA("ModuleScript") then
			local ok, res = pcall(require, module)
			if ok then
				systems.Controllers[module.Name] = res
				systems[module.Name] = res
				Log:Debug("   + Controller Registered: " .. module.Name)
			else
				Log:Error("RegisterFail", { Module = module.Name, Error = res })
			end
		end
	end

	Log:Info("🔍 Scanning Client Modules...")
	if Root:FindFirstChild("Controllers") then
		for _, mod in ipairs(Root.Controllers:GetChildren()) do
			register(mod)
		end
	end
	if Root:FindFirstChild("Modules") then
		for _, feature in ipairs(Root.Modules:GetChildren()) do
			if feature:IsA("Folder") then
				for _, file in ipairs(feature:GetChildren()) do
					if file.Name:match("Controller$") then
						register(file)
					end
				end
			end
		end
	end

	ClientKernel._controllers = systems.Controllers
	ClientKernel._logger = Log

	local ctx = Context.New(systems)

	Log:Info("Phase 1: Init")
	for name, ctrl in pairs(systems.Controllers) do
		if type(ctrl.Init) == "function" then
			task.spawn(function()
				local s, r = pcall(ctrl.Init, ctrl, ctx)
				if not s then
					Log:Error("InitFail", { Ctrl = name, Error = r })
				end
			end)
		end
	end

	task.delay(0.1, function()
		Log:Info("Phase 2: Start")
		for name, ctrl in pairs(systems.Controllers) do
			if type(ctrl.Start) == "function" then
				task.spawn(function()
					local s, r = pcall(ctrl.Start, ctrl)
					if not s then
						Log:Error("StartFail", { Ctrl = name, Error = r })
					end
				end)
			end
		end
		Log:Info("✅ CLIENT BOOT COMPLETE")
	end)

	-- [FIX] BindToClose dihapus karena error di Client.
	-- Client OS akan handle memory cleanup saat window ditutup.
end

function ClientKernel.Shutdown()
	if ClientKernel._isShuttingDown then
		return
	end
	ClientKernel._isShuttingDown = true

	for _, ctrl in pairs(ClientKernel._controllers) do
		if type(ctrl.Destroy) == "function" then
			pcall(ctrl.Destroy, ctrl)
		elseif type(ctrl.Shutdown) == "function" then
			pcall(ctrl.Shutdown, ctrl)
		elseif ctrl.Trove and type(ctrl.Trove.Destroy) == "function" then
			ctrl.Trove:Destroy()
		end
	end
end

return ClientKernel
