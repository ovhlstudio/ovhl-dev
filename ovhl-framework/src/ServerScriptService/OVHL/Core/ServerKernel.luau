-- @Kernel: Server v0.6.0 (Smart Naming & Network Ready)
local ServerScriptService = game:GetService("ServerScriptService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Context = Loader.Core("Context")
local SmartLogger = Loader.Core("SmartLogger")
local Manifest = Loader.Core("Manifest")
local Bridge = Loader.Core("Networking/Bridge")

local Adapters = {
    DB = require(ServerScriptService.OVHL.Core.Permissions.Adapters.InternalDB),
    HD = require(ServerScriptService.OVHL.Core.Permissions.Adapters.HDAdmin)
}

local ServerKernel = {}

function ServerKernel.Boot()
    local Log = SmartLogger.New("SYSTEM")
    Log:Info(string.format("🚀 %s v%s (%s) SERVER STARTING...", Manifest.Identity.Name, Manifest.Version.Full, Manifest.Metadata.BuildType))
    
    local services = {} 
    
    -- [[ SMART REGISTRAR ]]
    local function register(module, featureName)
        if module:IsA("ModuleScript") then
            local ok, res = pcall(require, module)
            if ok then 
                local finalName = module.Name
                if featureName and (module.Name == "Service" or module.Name == "Service.luau") then
                    finalName = featureName .. "Service"
                end
                
                services[finalName] = res
                Log:Debug(string.format("   + Service Registered: %-20s (Source: %s)", finalName, module.Name))
            else
                Log:Error("   x Failed to load: " .. module.Name, res)
            end
        end
    end

    Log:Info("🔍 Scanning Services...")
    
    local coreFolder = ServerScriptService.OVHL.Services
    for _, mod in ipairs(coreFolder:GetChildren()) do register(mod) end
    
    local modulesFolder = ServerScriptService.OVHL.Modules
    for _, feature in ipairs(modulesFolder:GetChildren()) do
        if feature:IsA("Folder") then
            for _, file in ipairs(feature:GetChildren()) do
                if file.Name:match("Service$") then 
                    register(file, feature.Name) 
                end
            end
        end
    end
    
    services.Adapters = Adapters
    
    local ctx = Context.New(services)
    
    -- [FIX] Initialize Network Bridge
    ctx.Network = Bridge.New()
    Log:Info("🌐 Network Bridge Initialized")
    
    -- [[ LIFECYCLE ]]
    Log:Info("Phase 1: Init")
    for name, srv in pairs(services) do
        if srv.Init then 
            task.spawn(function() 
                local s, r = pcall(srv.Init, srv, ctx)
                if not s then Log:Error("Init Failed: " .. name, r) end
            end) 
        end
    end
    
    Log:Info("Phase 2: Start")
    for name, srv in pairs(services) do
        if srv.Start then 
            task.spawn(function() 
                local s, r = pcall(srv.Start, srv)
                if not s then Log:Error("Start Failed: " .. name, r) end
            end) 
        end
    end
    
    game:BindToClose(function()
        Log:Warn("⚠️ SERVER SHUTTING DOWN...")
        for _, srv in pairs(services) do
            if srv.Shutdown then pcall(srv.Shutdown, srv) end
        end
        task.wait(2)
    end)
    
    Log:Info("✅ SERVER BOOT COMPLETE")
end

return ServerKernel
