--!strict
-- @Kernel: Client v0.4.0 (Standardized)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

-- [STANDARD] Load Core Systems yang BENAR-BENAR ADA
local ConfigLoader = Loader.Core("SharedConfigLoader")
local Bridge = Loader.Core("Networking/Bridge")
local Context = Loader.Core("Context")
local SmartLogger = Loader.Core("SmartLogger")
local Manifest = Loader.Core("Manifest")

local ClientKernel = {}

function ClientKernel.Boot()
    local Log = SmartLogger.New("SYSTEM")
    Log:Info(string.format("🎮 %s v%s (%s) CLIENT STARTING...", Manifest.Identity.Name, Manifest.Version.Full, Manifest.Metadata.BuildType))
    
    -- [STANDARD] Systems Container
    local systems = {
        ConfigLoader = ConfigLoader,
        Network = Bridge.New(), 
        Controllers = {} 
    }
    
    local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
    local Root = PlayerScripts:WaitForChild("OVHL")
    
    -- [[ DISCOVERY FUNCTION ]]
    local function register(module)
        if module:IsA("ModuleScript") then
            local ok, res = pcall(require, module)
            if ok then 
                systems.Controllers[module.Name] = res
                systems[module.Name] = res 
                Log:Debug("   + Controller: " .. module.Name)
            else
                Log:Error("   x Failed: " .. module.Name, res)
            end
        end
    end
    
    -- 1. Scan Controllers & Modules
    Log:Info("🔍 Scanning Client Modules...")
    if Root:FindFirstChild("Controllers") then
        for _, mod in ipairs(Root.Controllers:GetChildren()) do register(mod) end
    end
    if Root:FindFirstChild("Modules") then
        for _, feature in ipairs(Root.Modules:GetChildren()) do
            if feature:IsA("Folder") then
                for _, file in ipairs(feature:GetChildren()) do
                    if file.Name:match("Controller$") then register(file) end
                end
            end
        end
    end
    
    -- [STANDARD] Context New (Context akan auto-inject SmartLogger helper)
    local ctx = Context.New(systems)
    
    -- Lifecycle: Init
    Log:Info("Phase 1: Init")
    for name, ctrl in pairs(systems.Controllers) do
        if ctrl.Init then 
            task.spawn(function()
                local s, r = pcall(function() ctrl:Init(ctx) end)
                if not s then Log:Error("Init Fail: " .. name, r) end
            end)
        end
    end
    
    -- Lifecycle: Start
    task.delay(0.1, function()
        Log:Info("Phase 2: Start")
        for name, ctrl in pairs(systems.Controllers) do
            if ctrl.Start then 
                task.spawn(function() 
                    local s, r = pcall(function() ctrl:Start() end)
                    if not s then Log:Error("Start Fail: " .. name, r) end
                end) 
            end
        end
        Log:Info("✅ CLIENT BOOT COMPLETE")
    end)
end

return ClientKernel
