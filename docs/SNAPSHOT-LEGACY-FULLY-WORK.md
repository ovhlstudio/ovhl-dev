---
type: project-snapshot  
purpose: AI Analysis & Debugging Context
usage: Upload this entire file to AI for project understanding
---

# 🤖 AI ANALYSIS CONTEXT

> **Instructions for AI:**
> - This document contains complete project structure and codebase
> - All file paths are relative to project root  
> - Use this for: debugging, code analysis, refactoring suggestions, architecture review
> - When referencing code, cite: `File: path/to/file.lua, Line: X`

---

# 📊 Project Snapshot

**Generated:** 2025-11-22 10:07:07  
**Target Directories:** `src tests`  
**Git Info:** Not a git repository  
**Structure:** 45 folders | 64 files (63 Lua/Luau, 1 other)
**File Distribution:** Server: 16 (23K, 809 lines) | Client: 13 (11K, 392 lines) | Shared: 34 (51K, 1K lines)
**Total Size:** 87K

---

## 📁 Project Structure

```
📦 src/
  ├── 📁 ReplicatedStorage/
    ├── 📁 OVHL/
      ├── 🌙 Bootstrap.lua
      ├── 📁 Config/
        ├── 🌙 LoggerConfig.lua
      ├── 📁 Core/
        ├── 🌙 AssetSystem.lua
        ├── 🌙 ConfigSchema.lua
        ├── 🌙 Context.lua
        ├── 🌙 EngineEnums.lua
        ├── 🌙 ErrorHandler.lua
        ├── 🌙 LoggerFactory.lua
        ├── 📁 Logging/
          ├── 🌙 DomainResolver.lua
        ├── 🌙 Paths.lua
        ├── 🌙 PerformanceMonitor.lua
        ├── 🌙 PermissionCore.lua
        ├── 🌙 SharedConfigLoader.lua
        ├── 🌙 SmartLogger.lua
        ├── 🌙 TagService.lua
        ├── 🌙 TypeValidator.lua
      ├── 📁 Modules/
        ├── 📁 Admin/
          ├── 🌙 SharedConfig.lua
        ├── 📁 Inventory/
          ├── 🌙 SharedConfig.lua
        ├── 📁 PrototypePetInventory/
          ├── 🌙 SharedConfig.lua
        ├── 📁 PrototypeShop/
          ├── 🌙 SharedConfig.lua
        ├── 📁 ShowcaseSystem/
          ├── 🌙 SharedConfig.lua
      ├── 🌙 OVHL.lua
      ├── 📁 Types/
        ├── 🌙 CoreTypes.lua
      ├── 📁 UI/
        ├── 📁 Foundation/
          ├── 🌙 API.lua
          ├── 📁 Bridges/
            ├── 🌙 Topbar.lua
          ├── 📁 Components/
            ├── 🌙 ScreenWrapper.lua
            ├── 🌙 SmartButton.lua
            ├── 🌙 Window.lua
          ├── 🌙 Icons.lua
          ├── 🌙 Layers.lua
          ├── 🌙 SafeLoader.lua
          ├── 🌙 Theme.lua
        ├── 📁 Views/
          ├── 📁 PrototypePetInventory/
            ├── 🌙 Window.lua
          ├── 📁 ShowcaseSystem/
            ├── 🌙 Window.lua
  ├── 📁 ServerScriptService/
    ├── 📁 OVHL/
      ├── 📁 Config/
        ├── 🌙 PermissionConfig.lua
      ├── 📁 Core/
        ├── 🌙 Kernel.lua
        ├── 🌙 NetworkBridge.lua
        ├── 🌙 NetworkGuard.lua
        ├── 📁 Permissions/
          ├── 📁 Adapters/
            ├── 🌙 HDAdmin.lua
            ├── 🌙 InternalDB.lua
          ├── 🌙 HDAdminAdapter.lua
        ├── 🌙 RateLimiter.lua
      ├── 📁 Modules/
        ├── 📁 Inventory/
          ├── 🌙 Service.lua
        ├── 📁 PrototypeShop/
          ├── 🌙 Service.lua
      ├── 🌙 ServerRuntime.server.lua
      ├── 📁 Services/
        ├── 🌙 DataManager.lua
        ├── 🌙 DataManager_Legacy.lua
        ├── 🌙 MonetizationService.lua
        ├── 🌙 NotificationService.lua
        ├── 🌙 PermissionService.lua
  ├── 📁 StarterPlayer/
    ├── 📁 StarterPlayerScripts/
      ├── 📁 OVHL/
        ├── 🌙 ClientRuntime.client.lua
        ├── 📁 Controllers/
          ├── 📁 Admin/
            ├── 🌙 Controller.lua
          ├── 🌙 InputController.lua
          ├── 🌙 NotificationController.lua
          ├── 🌙 TopbarPlusAdapter.lua
        ├── 📁 Core/
          ├── 🌙 AssetLoader.lua
          ├── 🌙 FinderService.lua
          ├── 🌙 Kernel.lua
          ├── 🌙 NetworkBridge.lua
        ├── 📁 Modules/
          ├── 📁 Inventory/
            ├── 🌙 Controller.lua
          ├── 📁 PrototypePetInventory/
            ├── 🌙 Controller.lua
          ├── 📁 PrototypeShop/
            ├── 🌙 Controller.lua
          ├── 📁 ShowcaseSystem/
            ├── 🌙 Controller.lua
```

```
📦 tests/
  ├── 📁 E2E/
  ├── 📁 Integration/
  ├── 📁 Unit/
```

## 📂 Directory Overview

### 📦 src

- 📁 **ReplicatedStorage/OVHL**: 2 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Config**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Core**: 13 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Core/Logging**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/Admin**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/PrototypePetInventory**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/PrototypeShop**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/ShowcaseSystem**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Types**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation**: 5 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation/Bridges**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation/Components**: 3 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Views/PrototypePetInventory**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Views/ShowcaseSystem**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Config**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Core**: 4 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Core/Permissions**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Core/Permissions/Adapters**: 2 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Modules/PrototypeShop**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Services**: 5 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Controllers**: 3 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Controllers/Admin**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Core**: 4 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypePetInventory**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/ShowcaseSystem**: 1 Lua/Luau file(s)

### 📦 tests


---

## 📦 External Package Analysis (Auto-Detected)

**Packages Location:** `Packages`

| Package Name | Type | Status | References | Contexts |
|--------------|------|--------|------------|----------|
| **Fusion** | File Ref | ✅ Active | 11 | Shared  |
| **onyx-ui** | File Ref | ✅ Active | 2 | Shared  |
| **ProfileService** | File Ref | ✅ Active | 7 | Server  |
| **Promise** | File Ref | ✅ Active | 5 | Client  |
| **topbarplus** | File Ref | ✅ Active | 1 | Shared  |

## 🔗 Internal Dependency Graph

*No Manifest files found used for internal dependency mapping.*

### 🏁 Race Condition Analysis
✅ No obvious race conditions detected

### 🛡️ Security Analysis
✅ No obvious security issues detected

### 📈 Summary Statistics
#### 📊 Top 10 Largest Files
- `src/ReplicatedStorage/OVHL/UI/Views/PrototypePetInventory/Window.lua` (292 lines)
- `src/ServerScriptService/OVHL/Core/NetworkBridge.lua` (114 lines)
- `src/ReplicatedStorage/OVHL/Core/SmartLogger.lua` (101 lines)
- `src/ServerScriptService/OVHL/Services/PermissionService.lua` (96 lines)
- `src/ReplicatedStorage/OVHL/UI/Foundation/Components/Window.lua` (90 lines)
- `src/ServerScriptService/OVHL/Modules/Inventory/Service.lua` (87 lines)
- `src/ServerScriptService/OVHL/Core/Kernel.lua` (77 lines)
- `src/ServerScriptService/OVHL/Core/Permissions/HDAdminAdapter.lua` (72 lines)
- `src/ServerScriptService/OVHL/Services/DataManager_Legacy.lua` (71 lines)
- `src/ServerScriptService/OVHL/Core/NetworkGuard.lua` (71 lines)

#### 📏 File Size Distribution
- **0-100 lines:** 60 files
- **101-500 lines:** 3 files
- **501-1000 lines:** 0 files
- **1001+ lines:** 0 files

## 🗺️ Advanced Path Management Analysis

### 📍 Path Resolution Patterns

### 🔍 Path Consistency Report
- **Hardcoded Paths Found:** 0
- **Absolute Paths Found:** 1
- **Path Resolver:** ❌ Missing
- **Path Aliasing:** ❌ Missing

### 💡 Path Management Recommendations
❌ **Critical Issues Found:**
- Implement centralized PathResolver service
- Replace hardcoded paths with alias system (@core, @ui, etc.)
- Use dependency injection for path resolution

## 📜 API Contract Analysis

### 🔗 Module Contracts
- **Admin:** ❌ No contract defined
- **Inventory:** ✅ Has contract definition
  - `Contract = { Provides = {"Toggle"}, Requires = {"DataManager"} }`
- **PrototypePetInventory:** ❌ No contract defined
- **PrototypeShop:** ❌ No contract defined
- **ShowcaseSystem:** ❌ No contract defined

### 🌐 API Endpoint Analysis
- **Core API Endpoints:**
- **Core API Endpoints:**
  - `31:    -- 1. Register RemoteFunctions (Requests)`
- **Services API Endpoints:**
- **Services API Endpoints:**

### 📊 Contract Coverage
- **Modules with Contracts:** 1
- **Modules without Contracts:** 4
❌ **Contract coverage needs improvement**

## 🎨 UI System Analysis

### 🔍 UI Framework Detection
- **Fusion UI:** ✅ Detected
- **Onyx UI:** ❌ Not detected

### 📊 UI System Metrics
- **UI-Related Files:** 8
- **UI Components:** 11

### 🏗️ UI Architecture Assessment
✅ **Modern UI Architecture Detected**
- Component-based UI system
- Reactive framework integration
- Structured UI organization

### 💡 UI System Recommendations
- Leverage Fusion for reactive UI components
- Implement state management with Fusion State
- Create component library system

## 🏢 Enterprise Architecture Metrics

### 📈 Architecture Health Score
- **Dependency Injection Usage:** 3 files
- **Service Count:** 5 services
- **Module Count:** 11 modules
- **Configuration Files:** 9 configs

### 🎯 Architecture Quality Assessment
- **Overall Health Score:** 100/100
✅ **Enterprise Grade Architecture**
- Strong separation of concerns
- Proper dependency management
- Scalable service architecture

## 📚 Complete Codebase

### 📦 src/

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Bootstrap.lua</strong> (23 lines, 549B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Bootstrap.lua`

```lua
   1 | --[[
   2 |     OVHL Bootstrap
   3 |     Universal Entry Point for Server/Client
   4 | ]]
   5 | local RunService = game:GetService('RunService')
   6 | local Bootstrap = {}
   7 | Bootstrap.Server = {}
   8 | Bootstrap.Client = {}
   9 | 
  10 | function Bootstrap.Server:Start()
  11 |     if RunService:IsServer() then
  12 |         require(game.ServerScriptService.OVHL.Core.Kernel).Boot()
  13 |     end
  14 | end
  15 | 
  16 | function Bootstrap.Client:Start()
  17 |     if RunService:IsClient() then
  18 |         local PS = game.Players.LocalPlayer:WaitForChild('PlayerScripts')
  19 |         require(PS.OVHL.Core.Kernel).Boot()
  20 |     end
  21 | end
  22 | 
  23 | return Bootstrap
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Config/LoggerConfig.lua</strong> (36 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Config/LoggerConfig.lua`

```lua
   1 | return {
   2 |     DefaultLevel = "INFO",
   3 |     UseEmoji = true,
   4 |     UseColor = true,
   5 |     ShowTimestamp = true,
   6 | 
   7 |     Domains = {
   8 |         -- Core
   9 |         SYSTEM      = "⚙️ SYSTEM",
  10 |         NETWORK     = "🌐 NETWORK", 
  11 |         SECURITY    = "🔐 SECURITY",
  12 |         DATA        = "💾 DATA",
  13 |         
  14 |         -- Features
  15 |         INVENTORY   = "🎒 INVENTORY",
  16 |         SHOP        = "🏪 SHOP", 
  17 |         ADMIN       = "👑 ADMIN",
  18 |         PERMISSION  = "🔐 PERMISSION", -- [TARGET OPERASI KITA]
  19 |         
  20 |         -- UI Stuff
  21 |         UX             = "👆 UX",       -- Button clicks
  22 |         USER_INTERFACE = "🎨 UI",       -- General UI
  23 |         TOPBAR         = "🔘 TOPBAR",   -- Topbar specific
  24 |         
  25 |         -- Fallback
  26 |         DEFAULT     = "📦 GENERAL"
  27 |     },
  28 | 
  29 |     Levels = {
  30 |         DEBUG    = { Weight=1, Icon="🔍" },
  31 |         INFO     = { Weight=2, Icon="ℹ️" },
  32 |         WARN     = { Weight=3, Icon="⚠️" },
  33 |         ERROR    = { Weight=4, Icon="❌" },
  34 |         CRITICAL = { Weight=5, Icon="💀" }
  35 |     }
  36 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/AssetSystem.lua</strong> (33 lines, 851B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/AssetSystem.lua`

```lua
   1 | --[[ @Component: AssetSystem (String Fix & Caching) ]]
   2 | local ContentProvider = game:GetService("ContentProvider")
   3 | local AssetSystem = {}
   4 | 
   5 | -- Regex Pattern
   6 | local ID_PATTERN = "^(%d+)$"
   7 | local RBX_PATTERN = "^rbxassetid://(%d+)$"
   8 | 
   9 | function AssetSystem.Clean(id)
  10 |     if not id then return "" end
  11 |     local str = tostring(id)
  12 |     
  13 |     -- Convert "12345" -> "rbxassetid://12345"
  14 |     if str:match(ID_PATTERN) then
  15 |         return "rbxassetid://" .. str
  16 |     end
  17 |     
  18 |     -- Pass if already formatted
  19 |     if str:match(RBX_PATTERN) then
  20 |         return str
  21 |     end
  22 |     
  23 |     return "rbxassetid://0" -- Fallback Texture
  24 | end
  25 | 
  26 | -- Wrapper for ImageLabel
  27 | function AssetSystem.Apply(guiObject, rawId)
  28 |     if guiObject and guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
  29 |         guiObject.Image = AssetSystem.Clean(rawId)
  30 |     end
  31 | end
  32 | 
  33 | return AssetSystem
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/ConfigSchema.lua</strong> (48 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/ConfigSchema.lua`

```lua
   1 | --[[ @Component: ConfigSchema (Validation) ]]
   2 | local ConfigSchema = {}
   3 | 
   4 | local REQUIRED_FIELDS = {
   5 |     Meta = { Name="string", Type="string", Version="string" }
   6 | }
   7 | 
   8 | local OPTIONAL_FIELDS = {
   9 |     Topbar = { Enabled="boolean" }, -- Loose check for flex
  10 |     Network = { Route="string", Requests="table" },
  11 |     UI = { Type="string" },
  12 |     Behavior = "table",
  13 |     Contract = "table"
  14 | }
  15 | 
  16 | local function validateTable(data, schema, path)
  17 |     local errors = {}
  18 |     for field, expectedType in pairs(schema) do
  19 |         local val = data[field]
  20 |         local context = path .. "." .. field
  21 |         
  22 |         if val == nil then
  23 |             table.insert(errors, "Missing required: " .. context)
  24 |         elseif type(expectedType) == "table" then
  25 |             if type(val) ~= "table" then
  26 |                 table.insert(errors, context .. " expected table, got " .. type(val))
  27 |             else
  28 |                 local subErrors = validateTable(val, expectedType, context)
  29 |                 for _, e in ipairs(subErrors) do table.insert(errors, e) end
  30 |             end
  31 |         elseif type(val) ~= expectedType then
  32 |             table.insert(errors, context .. " expected " .. expectedType .. ", got " .. type(val))
  33 |         end
  34 |     end
  35 |     return errors
  36 | end
  37 | 
  38 | function ConfigSchema.Validate(config, moduleName)
  39 |     local errors = validateTable(config, REQUIRED_FIELDS, moduleName)
  40 |     
  41 |     if #errors > 0 then
  42 |         local msg = "[CONFIG VALIDATION FAILED] " .. moduleName .. "\n" .. table.concat(errors, "\n")
  43 |         error(msg)
  44 |     end
  45 |     return true
  46 | end
  47 | 
  48 | return ConfigSchema
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Context.lua</strong> (37 lines, 1023B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Context.lua`

```lua
   1 | --[[
   2 |     Framework Context - Dynamic Service Container (V7 Fixed)
   3 |     Supports strict checking + dynamic injection.
   4 | ]]
   5 | 
   6 | local Context = {}
   7 | Context.__index = Context
   8 | 
   9 | function Context.New(services)
  10 |     local self = setmetatable({}, Context)
  11 |     
  12 |     -- 1. Dynamic Injection (Inject Adapters, Services, etc automatically)
  13 |     for key, value in pairs(services) do
  14 |         self[key] = value
  15 |     end
  16 | 
  17 |     -- 2. Hard Validation (Fundamental Systems)
  18 |     -- Ini wajib ada. Kalau gak ada, mending crash di awal daripada aneh2.
  19 |     assert(self.LoggerFactory, "[Context] Missing LoggerFactory")
  20 |     assert(self.ConfigLoader,  "[Context] Missing ConfigLoader")
  21 |     
  22 |     -- 3. Compatibility Shim (Legacy Logger)
  23 |     -- Buat module lama yang masih panggil ctx.Logger
  24 |     if not self.Logger then
  25 |         self.Logger = self.LoggerFactory.System()
  26 |     end
  27 | 
  28 |     return self
  29 | end
  30 | 
  31 | -- Helper Shortcut
  32 | function Context:GetLogger(domain)
  33 |     if domain then return self.LoggerFactory.Create(domain) end
  34 |     return self.Logger
  35 | end
  36 | 
  37 | return Context
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/EngineEnums.lua</strong> (17 lines, 581B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/EngineEnums.lua`

```lua
   1 | --[[ @Component: EngineEnums (HD Admin Standard) ]]
   2 | local EngineEnums = {
   3 |     -- 1:1 Mirror of HD Admin Ranks
   4 |     Permission = { 
   5 |         NonAdmin  = 0, -- Default
   6 |         VIP       = 1, -- Donors
   7 |         Mod       = 2, -- Moderators
   8 |         Admin     = 3, -- Administrators
   9 |         HeadAdmin = 4, -- Head Administrators (Missing before)
  10 |         Owner     = 5  -- Game Creator
  11 |     },
  12 |     
  13 |     UIMode = { Native = "Native", Fusion = "Fusion", Hybrid = "Hybrid" },
  14 |     LogLevel = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4, FATAL = 5 }
  15 | }
  16 | table.freeze(EngineEnums)
  17 | return EngineEnums
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/ErrorHandler.lua</strong> (29 lines, 796B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/ErrorHandler.lua`

```lua
   1 | --[[ @Component: ErrorHandler (Centralized) ]]
   2 | local ErrorHandler = {}
   3 | local Stats = { total = 0, byCat = {} }
   4 | 
   5 | function ErrorHandler.Handle(category, err, context)
   6 |     Stats.total = Stats.total + 1
   7 |     Stats.byCat[category] = (Stats.byCat[category] or 0) + 1
   8 |     
   9 |     -- Formatting
  10 |     local msg = string.format("[OVHL-%s] %s | CTX: %s", category, tostring(err), tostring(context or "N/A"))
  11 |     
  12 |     -- In a real AAA game, you would send this to Sentry/PlayFab here
  13 |     warn(msg) 
  14 |     print(debug.traceback())
  15 |     
  16 |     return nil
  17 | end
  18 | 
  19 | function ErrorHandler.Wrap(category, func, context)
  20 |     return function(...)
  21 |         local s, r = pcall(func, ...)
  22 |         if not s then
  23 |             return ErrorHandler.Handle(category, r, context)
  24 |         end
  25 |         return r
  26 |     end
  27 | end
  28 | 
  29 | return ErrorHandler
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/LoggerFactory.lua</strong> (27 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/LoggerFactory.lua`

```lua
   1 | --[[ @Component: LoggerFactory (Enterprise Dependency Injection) ]]
   2 | local SmartLogger = require(script.Parent.SmartLogger)
   3 | 
   4 | local LoggerFactory = {}
   5 | LoggerFactory._cache = {}
   6 | 
   7 | function LoggerFactory.Create(domain, overrides)
   8 |     local key = domain .. (overrides and overrides.LogLevel or "")
   9 |     
  10 |     if not LoggerFactory._cache[key] then
  11 |         LoggerFactory._cache[key] = SmartLogger.New(domain, overrides)
  12 |     end
  13 |     
  14 |     return LoggerFactory._cache[key]
  15 | end
  16 | 
  17 | -- Pre-defined domains for consistency
  18 | function LoggerFactory.System() return LoggerFactory.Create("SYSTEM") end
  19 | function LoggerFactory.Admin() return LoggerFactory.Create("ADMIN") end
  20 | function LoggerFactory.Inventory() return LoggerFactory.Create("INVENTORY") end
  21 | function LoggerFactory.Shop() return LoggerFactory.Create("SHOP") end
  22 | function LoggerFactory.UI() return LoggerFactory.Create("USER_INTERFACE") end
  23 | function LoggerFactory.Network() return LoggerFactory.Create("NETWORK") end
  24 | function LoggerFactory.Security() return LoggerFactory.Create("SECURITY") end
  25 | function LoggerFactory.Data() return LoggerFactory.Create("DATA") end
  26 | 
  27 | return LoggerFactory
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Logging/DomainResolver.lua</strong> (34 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Logging/DomainResolver.lua`

```lua
   1 | --[[ @Component: DomainResolver (V17 - Smart Deduction) ]]
   2 | local DomainResolver = {}
   3 | 
   4 | local MANUAL_MAPPINGS = {
   5 |     -- Core Hardcodes (Keep these for consistency)
   6 |     ["PermissionService"] = "PERMISSION",
   7 |     ["DataManager"] = "DATA",
   8 |     ["HDAdminAdapter"] = "HD_ADMIN",
   9 |     ["InternalDB"] = "DATABASE",
  10 | }
  11 | 
  12 | function DomainResolver.Resolve(moduleName)
  13 |     -- 1. Cek Mapping Manual
  14 |     if MANUAL_MAPPINGS[moduleName] then
  15 |         return MANUAL_MAPPINGS[moduleName]
  16 |     end
  17 |     
  18 |     -- 2. Smart String Cleaning (Auto-Domain)
  19 |     -- "InventoryController" -> "INVENTORY"
  20 |     -- "ShopSystem" -> "SHOP"
  21 |     local domain = moduleName
  22 |     domain = domain:gsub("Controller$", "")
  23 |     domain = domain:gsub("Service$", "")
  24 |     domain = domain:gsub("Adapter$", "")
  25 |     domain = domain:gsub("Manager$", "")
  26 |     domain = domain:gsub("System$", "")
  27 |     domain = domain:gsub("Panel$", "")
  28 |     
  29 |     -- Return UPPERCASE string. 
  30 |     -- SmartLogger V17 akan otomatis kasih icon 📦 kalau ini belum terdaftar di Config.
  31 |     return domain:upper()
  32 | end
  33 | 
  34 | return DomainResolver
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Paths.lua</strong> (26 lines, 877B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Paths.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local PS = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")
   3 | 
   4 | local ROOT = RS:WaitForChild("OVHL", 10)
   5 | if not ROOT then error("OVHL Root not found!") end
   6 | 
   7 | local Paths = {
   8 |     Root = ROOT,
   9 |     Core = ROOT:WaitForChild("Core"),
  10 |     Config = ROOT:WaitForChild("Config"),
  11 |     Modules = ROOT:WaitForChild("Modules"),
  12 |     UI = ROOT:WaitForChild("UI"),
  13 |     Types = ROOT:WaitForChild("Types"),
  14 |     Client = {
  15 |         Root = PS and PS:WaitForChild("OVHL"),
  16 |         Controllers = PS and PS:WaitForChild("OVHL"):WaitForChild("Controllers"),
  17 |         Modules = PS and PS:WaitForChild("OVHL"):WaitForChild("Modules")
  18 |     },
  19 |     Packages = RS:WaitForChild("Packages")
  20 | }
  21 | 
  22 | function Paths.Require(moduleName)
  23 |     return require(Paths.Core:FindFirstChild(moduleName))
  24 | end
  25 | 
  26 | return Paths
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/PerformanceMonitor.lua</strong> (26 lines, 687B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/PerformanceMonitor.lua`

```lua
   1 | --[[ @Component: PerformanceMonitor ]]
   2 | local PerformanceMonitor = {}
   3 | local stats = {}
   4 | 
   5 | function PerformanceMonitor.Start(label)
   6 |     stats[label] = { start = os.clock() }
   7 | end
   8 | 
   9 | function PerformanceMonitor.Stop(label)
  10 |     if not stats[label] then return end
  11 |     local dur = os.clock() - stats[label].start
  12 |     stats[label].duration = dur
  13 |     return dur
  14 | end
  15 | 
  16 | function PerformanceMonitor.Log(logger)
  17 |     local report = {}
  18 |     for k, v in pairs(stats) do
  19 |         if v.duration then
  20 |             table.insert(report, string.format("%s: %.4fms", k, v.duration * 1000))
  21 |         end
  22 |     end
  23 |     logger:Info("PERF", "Startup Metrics:\n" .. table.concat(report, "\n"))
  24 | end
  25 | 
  26 | return PerformanceMonitor
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/PermissionCore.lua</strong> (16 lines, 441B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/PermissionCore.lua`

```lua
   1 | --[[ @Component: PermissionCore (Shared Logic) ]]
   2 | local PermCore = {}
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | -- ABSOLUTE REQUIRE
   5 | local Enums = require(RS.OVHL.Core.EngineEnums)
   6 | 
   7 | function PermCore.Resolve(val)
   8 |     if type(val) == "number" then return val end
   9 |     return Enums.Permission[val] or 0
  10 | end
  11 | 
  12 | function PermCore.Check(userRank, reqRank)
  13 |     return PermCore.Resolve(userRank) >= PermCore.Resolve(reqRank)
  14 | end
  15 | 
  16 | return PermCore
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/SharedConfigLoader.lua</strong> (41 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/SharedConfigLoader.lua`

```lua
   1 | --[[ @Component: SharedConfigLoader (Validated) ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Loader = {}
   4 | local Schema = require(script.Parent.ConfigSchema)
   5 | 
   6 | function Loader.Load(moduleName)
   7 |     local modFolder = RS.OVHL.Modules:FindFirstChild(moduleName)
   8 |     if not modFolder then
   9 |         warn("[CONFIG] Module not found: " .. moduleName)
  10 |         return {} 
  11 |     end
  12 | 
  13 |     local configFile = modFolder:FindFirstChild("SharedConfig")
  14 |     if not configFile then
  15 |         warn("[CONFIG] SharedConfig missing for: " .. moduleName)
  16 |         return {}
  17 |     end
  18 | 
  19 |     local success, cfg = pcall(require, configFile)
  20 |     if not success then
  21 |         warn("[CONFIG] Syntax Error in " .. moduleName .. ": " .. tostring(cfg))
  22 |         return {}
  23 |     end
  24 | 
  25 |     -- STRICT VALIDATION
  26 |     local ok, err = pcall(Schema.Validate, cfg, moduleName)
  27 |     if not ok then
  28 |         warn(err) -- Warn only, don't crash thread, simply return safe default?
  29 |         -- Or crash? Claude said "FAIL FAST". Let's error.
  30 |         error(err)
  31 |     end
  32 |     
  33 |     -- Defaults
  34 |     if not cfg.Network then
  35 |         cfg.Network = { Route = moduleName, Requests = {} }
  36 |     end
  37 | 
  38 |     return cfg
  39 | end
  40 | 
  41 | return Loader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/SmartLogger.lua</strong> (101 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/SmartLogger.lua`

```lua
   1 | --[[ @Component: SmartLogger (V4.0 - Original Logic Restored + Paths) ]]
   2 | local RunService = game:GetService("RunService")
   3 | local HttpService = game:GetService("HttpService")
   4 | local RS = game:GetService("ReplicatedStorage")
   5 | 
   6 | -- [FIX V4] Menggunakan Paths System, bukan hardcode
   7 | local Paths = require(RS.OVHL.Core.Paths)
   8 | local Config = require(Paths.Config.LoggerConfig)
   9 | 
  10 | local SmartLogger = {}
  11 | SmartLogger.__index = SmartLogger
  12 | 
  13 | local IS_SERVER = RunService:IsServer()
  14 | local CONTEXT = IS_SERVER and "[SERVER]" or "[CLIENT]"
  15 | 
  16 | function SmartLogger.New(domain, overrides)
  17 |     local self = setmetatable({}, SmartLogger)
  18 |     self._rawDomain = domain or "SYSTEM"
  19 |     
  20 |     local mapped = Config.Domains[self._rawDomain]
  21 |     if mapped then
  22 |         self._domainDisplay = mapped
  23 |     else
  24 |         self._domainDisplay = string.format("📦 %s", self._rawDomain:upper())
  25 |     end
  26 |     
  27 |     local defLvl = Config.DefaultLevel or "INFO"
  28 |     local myLvl = (overrides and overrides.LogLevel) or defLvl
  29 |     self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
  30 |     
  31 |     return self
  32 | end
  33 | 
  34 | --[[ 
  35 |     SAFE DUMP: Mengubah table menjadi string aman tanpa cyclic error.
  36 |     Mencegah crash jika object mengandung self-reference atau Instance kompleks.
  37 | ]]
  38 | function SmartLogger:_safeDump(data, depth)
  39 |     depth = depth or 0
  40 |     if depth > 2 then return "..." end -- Hard limit depth
  41 |     
  42 |     local t = type(data)
  43 |     if t == "table" then
  44 |         local parts = {}
  45 |         for k, v in pairs(data) do
  46 |             if type(k) == "string" then
  47 |                 table.insert(parts, k .. "=" .. self:_safeDump(v, depth + 1))
  48 |             end
  49 |         end
  50 |         return "{" .. table.concat(parts, ", ") .. "}"
  51 |     elseif t == "userdata" then
  52 |         return typeof(data)
  53 |     else
  54 |         return tostring(data)
  55 |     end
  56 | end
  57 | 
  58 | function SmartLogger:_safeFormat(level, message, data)
  59 |     if not message then return nil end
  60 |     
  61 |     local cfg = Config.Levels[level]
  62 |     if not cfg then return nil end
  63 |     
  64 |     local meta = ""
  65 |     if data ~= nil then
  66 |         local success, result = pcall(function()
  67 |             return HttpService:JSONEncode(data)
  68 |         end)
  69 |         
  70 |         if success then
  71 |             meta = " │ " .. result
  72 |         else
  73 |             meta = " │ [RAW] " .. self:_safeDump(data)
  74 |         end
  75 |     end
  76 | 
  77 |     local levelIcon = cfg.Icon or "📝"
  78 |     return string.format("%s %s %s\n   └── %s%s", 
  79 |         levelIcon, CONTEXT, self._domainDisplay, message, meta)
  80 | end
  81 | 
  82 | function SmartLogger:_log(level, message, data)
  83 |     local cfg = Config.Levels[level]
  84 |     if not cfg or cfg.Weight < self._weight then return end
  85 |     
  86 |     local logMessage = self:_safeFormat(level, message, data)
  87 |     if not logMessage then return end
  88 |     
  89 |     if level == "ERROR" or level == "CRITICAL" then
  90 |         warn(logMessage)
  91 |     else
  92 |         print(logMessage)
  93 |     end
  94 | end
  95 | 
  96 | function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
  97 | function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
  98 | function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
  99 | function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end
 100 | 
 101 | return SmartLogger
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/TagService.lua</strong> (36 lines, 979B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/TagService.lua`

```lua
   1 | --[[ @Component: TagService (V3.0 Binder Pattern) ]]
   2 | local CS = game:GetService("CollectionService")
   3 | local TagService = {}
   4 | 
   5 | function TagService.Bind(tagName, lifecycle)
   6 |     -- Lifecycle: { Init = func(inst), Destroy = func(inst) }
   7 |     local connections = {}
   8 |     
   9 |     local function setup(inst)
  10 |         if lifecycle.Init then 
  11 |             task.spawn(lifecycle.Init, inst) 
  12 |         end
  13 |     end
  14 |     
  15 |     local function cleanup(inst)
  16 |         if lifecycle.Destroy then 
  17 |             task.spawn(lifecycle.Destroy, inst) 
  18 |         end
  19 |     end
  20 |     
  21 |     table.insert(connections, CS:GetInstanceAddedSignal(tagName):Connect(setup))
  22 |     table.insert(connections, CS:GetInstanceRemovedSignal(tagName):Connect(cleanup))
  23 |     
  24 |     for _, inst in ipairs(CS:GetTagged(tagName)) do
  25 |         setup(inst)
  26 |     end
  27 |     
  28 |     -- Return Cleaner Object
  29 |     return {
  30 |         Destroy = function()
  31 |             for _, conn in ipairs(connections) do conn:Disconnect() end
  32 |         end
  33 |     }
  34 | end
  35 | 
  36 | return TagService
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/TypeValidator.lua</strong> (54 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/TypeValidator.lua`

```lua
   1 | --[[
   2 |     Type Validator - Strict Runtime Checking
   3 |     Part of Hybrid Security System (Inbound Defense)
   4 | ]]
   5 | 
   6 | local TypeValidator = {}
   7 | 
   8 | local TYPE_CHECKERS = {
   9 |     string = function(v) return type(v) == 'string' end,
  10 |     number = function(v) return type(v) == 'number' end,
  11 |     boolean = function(v) return type(v) == 'boolean' end,
  12 |     table = function(v) return type(v) == 'table' end,
  13 |     ['function'] = function(v) return type(v) == 'function' end,
  14 |     Instance = function(v) return typeof(v) == 'Instance' end,
  15 |     Vector3 = function(v) return typeof(v) == 'Vector3' end,
  16 |     Color3 = function(v) return typeof(v) == 'Color3' end,
  17 |     Player = function(v) return typeof(v) == 'Instance' and v:IsA('Player') end,
  18 |     any = function(v) return true end
  19 | }
  20 | 
  21 | function TypeValidator.Validate(args, schema)
  22 |     if not schema then return true end
  23 |     local errors = {}
  24 | 
  25 |     for i, spec in ipairs(schema) do
  26 |         local val = args[i]
  27 |         local name = spec.name or ('arg #' .. i)
  28 |         
  29 |         -- Handle simple string types for backward compatibility
  30 |         local requiredType = type(spec) == 'string' and spec or spec.type
  31 |         local isOptional = (type(spec) == 'table' and spec.optional)
  32 | 
  33 |         if val == nil then
  34 |             if not isOptional then
  35 |                 table.insert(errors, string.format('%s is required', name))
  36 |             end
  37 |         else
  38 |             local checker = TYPE_CHECKERS[requiredType]
  39 |             if not checker then
  40 |                 -- Fallback to basic type check
  41 |                 if type(val) ~= requiredType and typeof(val) ~= requiredType then
  42 |                      table.insert(errors, string.format('%s expected %s, got %s', name, requiredType, typeof(val)))
  43 |                 end
  44 |             elseif not checker(val) then
  45 |                 table.insert(errors, string.format('%s invalid format for %s', name, requiredType))
  46 |             end
  47 |         end
  48 |     end
  49 | 
  50 |     if #errors > 0 then return false, table.concat(errors, '; ') end
  51 |     return true
  52 | end
  53 | 
  54 | return TypeValidator
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/Admin/SharedConfig.lua</strong> (22 lines, 753B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/Admin/SharedConfig.lua`

```lua
   1 | return {
   2 |     Meta = { Name = "Admin", Type = "System", Version = "3.0.0" },
   3 |     Topbar = {
   4 |         Enabled = true, Text = "ADMIN", Icon = "rbxassetid://3926305904",
   5 |         Permission = 3, Order = 99
   6 |     },
   7 |     -- [DATA DRIVEN UI SOURCE]
   8 |     UI = {
   9 |         Title = "ACCESS CONTROL",
  10 |         SearchPlaceholder = "Search username or ID...",
  11 |         EmptyState = "Select a player to view details",
  12 |         Labels = {
  13 |             HeaderID = "User ID: ",
  14 |             SectionRank = "PERMISSION LEVEL",
  15 |             BtnKick = "KICK USER",
  16 |             BtnSave = "SAVE CHANGES",
  17 |             ModalConfirm = "CONFIRM ACTION",
  18 |             ModalDesc = "Are you sure you want to proceed?"
  19 |         }
  20 |     },
  21 |     Network = { Route = "PermissionSystem", Requests = {} }
  22 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/Inventory/SharedConfig.lua</strong> (22 lines, 919B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/Inventory/SharedConfig.lua`

```lua
   1 | return {
   2 |     Meta = { Name = "Inventory", Type = "Feature", Version = "2.1.0" },
   3 |     Topbar = { Enabled = true, Text = "BAG", Icon = "rbxassetid://96226541857519", Shortcut = Enum.KeyCode.I },
   4 |     Behavior = { Debounce = 0.5, AutoFetch = true },
   5 |     UI = {
   6 |         Type = "Fusion",
   7 |         Defaults = { 
   8 |             Title = "MY BACKPACK",
   9 |             EmptyState = "No items found." 
  10 |         },
  11 |         RarityColors = {
  12 |             Common = Color3.fromHex("94A3B8"), Uncommon = Color3.fromHex("10B981"),
  13 |             Rare = Color3.fromHex("3B82F6"), Epic = Color3.fromHex("8B5CF6"),
  14 |             Legendary = Color3.fromHex("F59E0B"), Consumable = Color3.fromHex("EF4444")
  15 |         }
  16 |     },
  17 |     Network = {
  18 |         Route = "Inventory",
  19 |         Requests = { GetItems = {Args={}, RateLimit={Max=10}}, Equip = {Args={"string"}, RateLimit={Max=8}} }
  20 |     },
  21 |     Contract = { Provides = {"Toggle"}, Requires = {"DataManager"} }
  22 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/PrototypePetInventory/SharedConfig.lua</strong> (40 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/PrototypePetInventory/SharedConfig.lua`

```lua
   1 | return {
   2 |     Meta = { Name = "PetInventory", Type = "Prototype", Version = "1.0" },
   3 |     Topbar = { Enabled = true, Text = "PETS", Icon = "rbxassetid://13379080651", Order = 2 },
   4 |     
   5 |     -- [DATA DRIVEN DESIGN]
   6 |     -- Semua warna dan teks dari referensi gambar didefinisikan di sini.
   7 |     UI = {
   8 |         Colors = {
   9 |             PanelBG     = Color3.fromHex("1c1d30"), -- Dark Blueish
  10 |             PanelBorder = Color3.fromHex("2d2f4e"),
  11 |             HeaderPill  = Color3.fromHex("252640"),
  12 |             
  13 |             -- Button Colors
  14 |             BtnEquip    = Color3.fromHex("fca311"), -- Orange
  15 |             BtnMerge    = Color3.fromHex("118ab2"), -- Blue
  16 |             BtnDelete   = Color3.fromHex("ef476f"), -- Red
  17 |             BtnGreen    = Color3.fromHex("06d6a0"), -- Green (+)
  18 |             
  19 |             -- Rarity Colors (Item Bottom Bar)
  20 |             Rarity = {
  21 |                 Common    = Color3.fromHex("9ca3af"),
  22 |                 Uncommon  = Color3.fromHex("4ade80"),
  23 |                 Rare      = Color3.fromHex("60a5fa"),
  24 |                 Epic      = Color3.fromHex("a78bfa"),
  25 |                 Legendary = Color3.fromHex("fbbf24"),
  26 |                 Mythic    = Color3.fromHex("f87171"),
  27 |             }
  28 |         },
  29 |         Labels = {
  30 |             TitleLeft  = "Name",
  31 |             TitleRight = "Pets",
  32 |             BtnEquip   = "Equip",
  33 |             BtnMerge   = "Merge",
  34 |             BtnDelete  = "Delete",
  35 |             BtnMulti   = "Multi Delete",
  36 |             BtnMergeAll= "Merge All"
  37 |         }
  38 |     },
  39 |     Network = { Route = "PetInv", Requests = {} }
  40 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/PrototypeShop/SharedConfig.lua</strong> (20 lines, 748B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/PrototypeShop/SharedConfig.lua`

```lua
   1 | return {
   2 |     Meta = { Name = "PrototypeShop", Type = "Feature", Version = "2.1.0" },
   3 |     Topbar = { Enabled = true, Text = "SHOP", Icon = "rbxassetid://4882429582", Order = 2 },
   4 |     Behavior = { InteractionDistance = 10, OneTimePurchase = true },
   5 |     UI = {
   6 |         Defaults = {
   7 |             HeaderLabel = "LEGENDARY ARMORY",
   8 |             ItemName = "MYTHIC SWORD",
   9 |             ItemDesc = "Legendary Weapon | Damage: 999",
  10 |             BuyBtn = "BUY NOW (500 G)",
  11 |             OwnedBtn = "ALREADY OWNED",
  12 |             ModalTitle = "CONFIRM PURCHASE",
  13 |             ModalDesc = "Buy Mythic Sword for 500 Gold?"
  14 |         }
  15 |     },
  16 |     Network = {
  17 |         Route = "PrototypeShop",
  18 |         Requests = { BuyItem = {Args={"string"}, RateLimit={Max=10}} }
  19 |     }
  20 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/ShowcaseSystem/SharedConfig.lua</strong> (13 lines, 437B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/ShowcaseSystem/SharedConfig.lua`

```lua
   1 | return {
   2 |     Meta = { Name = "ShowcaseSystem", Type = "Feature", Version = "1.1" },
   3 |     Topbar = { Enabled = true, Text = "ENTERPRISE", Icon = "rbxassetid://11572598370", Order = 1 },
   4 |     UI = {
   5 |         Title = "SYSTEM STATUS",
   6 |         Subtitle = "Architecture V4.1 Verified",
   7 |         Labels = {
   8 |             Action = "RUN DIAGNOSTIC",
   9 |             Close = "SHUTDOWN"
  10 |         }
  11 |     },
  12 |     Network = { Route = "Showcase", Requests = {} }
  13 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/OVHL.lua</strong> (25 lines, 890B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/OVHL.lua`

```lua
   1 | local RS = game:GetService('ReplicatedStorage')
   2 | local Paths = require(RS.OVHL.Core.Paths)
   3 | 
   4 | local OVHL = { VERSION = '4.0.0-AUTO' }
   5 | local function Safe(m) local s,r = pcall(require, m); return s and r or {} end
   6 | 
   7 | OVHL.Paths = Paths
   8 | OVHL.Logger = Safe(Paths.Core.SmartLogger)
   9 | OVHL.LoggerFactory = Safe(Paths.Core.LoggerFactory)
  10 | OVHL.Config = Safe(Paths.Core.SharedConfigLoader)
  11 | OVHL.Enums = Safe(Paths.Core.EngineEnums)
  12 | OVHL.Types = Safe(Paths.Types.CoreTypes)
  13 | OVHL.DomainResolver = Safe(Paths.Core.Logging.DomainResolver)
  14 | OVHL.TypeValidator = Safe(Paths.Core.TypeValidator)
  15 | OVHL.ErrorHandler = Safe(Paths.Core.ErrorHandler)
  16 | OVHL.Perf = Safe(Paths.Core.PerformanceMonitor)
  17 | 
  18 | local F = Paths.UI.Foundation
  19 | OVHL.Theme = Safe(F.Theme)
  20 | OVHL.Layers = Safe(F.Layers)
  21 | OVHL.SafeLoader = Safe(F.SafeLoader)
  22 | OVHL.UIConfig = Safe(Paths.Config.UIConfig)
  23 | OVHL.Icons = OVHL.UIConfig.Icons or {}
  24 | 
  25 | return OVHL
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Types/CoreTypes.lua</strong> (17 lines, 435B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Types/CoreTypes.lua`

```lua
   1 | --[[ @Component: CoreTypes (Shared) ]]
   2 | local CoreTypes = {}
   3 | 
   4 | export type Logger = {
   5 |     Info: (self: Logger, domain: string, msg: string, data: any?) -> (),
   6 |     Warn: (self: Logger, domain: string, msg: string, data: any?) -> (),
   7 |     Error: (self: Logger, domain: string, msg: string, data: any?) -> ()
   8 | }
   9 | 
  10 | export type SystemContext = {
  11 |     Logger: Logger,
  12 |     ConfigLoader: any,
  13 |     Network: any,
  14 |     [string]: any
  15 | }
  16 | 
  17 | return CoreTypes
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/API.lua</strong> (44 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/API.lua`

```lua
   1 | --[[ OVHL V6.0 API ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Packages = RS.Packages
   4 | local Foundation = RS.OVHL.UI.Foundation
   5 | 
   6 | local Fusion = require(Packages.Fusion)
   7 | local Onyx = require(Packages["onyx-ui"])
   8 | 
   9 | local API = {}
  10 | API.Fusion = Fusion
  11 | API.Theme = require(Foundation.Theme)
  12 | API.Layers = require(Foundation.Layers)
  13 | API.Icons = require(Foundation.Icons)
  14 | API.SafeLoader = require(Foundation.SafeLoader)
  15 | 
  16 | -- Inject Helpers
  17 | API.Children = Fusion.Children
  18 | API.Computed = Fusion.Computed
  19 | API.Value = Fusion.Value
  20 | 
  21 | -- Component Registry
  22 | local ScreenWrapper = require(Foundation.Components.ScreenWrapper)(API)
  23 | local Window = require(Foundation.Components.Window)(API)
  24 | local SmartButton = require(Foundation.Components.SmartButton)(API)
  25 | 
  26 | function API.NewScope()
  27 |     local scope = Fusion.scoped(Fusion)
  28 |     
  29 |     -- Native Onyx
  30 |     for k, v in pairs(Onyx.Components) do scope[k] = v end
  31 |     for k, v in pairs(Onyx.Util) do if type(v)=="function" then scope[k]=v end end
  32 |     
  33 |     -- OVHL Smart Components
  34 |     scope.ScreenWrapper = ScreenWrapper
  35 |     scope.Window = Window
  36 |     scope.SmartButton = SmartButton -- Gunakan ini, jangan Button biasa
  37 |     
  38 |     return scope
  39 | end
  40 | 
  41 | function API.Mount(scope, mod, props) return API.SafeLoader.Mount(scope, mod, props) end
  42 | function API.Unwrap(v) return Fusion.peek(v) end
  43 | 
  44 | return API
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Bridges/Topbar.lua</strong> (46 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Bridges/Topbar.lua`

```lua
   1 | --[[ @Bridge: TopbarPlus V3 Integration (Themed) ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local TopbarPlus = require(RS.Packages.topbarplus)
   4 | -- ABSOLUTE PATH REQUIRE
   5 | local Theme = require(RS.OVHL.UI.Foundation.Theme)
   6 | 
   7 | local TopbarBridge = {}
   8 | local _initialized = false
   9 | 
  10 | function TopbarBridge.Init()
  11 |     if _initialized then return end
  12 |     _initialized = true
  13 |     
  14 |     -- Inject Theme to Library
  15 |     local C = Theme.Colors
  16 |     TopbarPlus.modifyBaseTheme({
  17 |         {"IconBackgroundColor", C.Surface},
  18 |         {"IconBorderColor", C.Border},
  19 |         {"IconImageColor", C.TextHigh},
  20 |         {"IconLabelColor", C.TextHigh},
  21 |         {"WidgetBackgroundColor", C.Surface},
  22 |         {"WidgetBorderColor", C.Border},
  23 |     })
  24 | end
  25 | 
  26 | function TopbarBridge.Register(name, config, toggleFunc)
  27 |     TopbarBridge.Init() 
  28 |     
  29 |     if not config or not config.Enabled then return nil end
  30 |     
  31 |     local icon = TopbarPlus.new()
  32 |         :setLabel(config.Text or name)
  33 |         :setImage(config.Icon)
  34 |         :setOrder(config.Order or 10)
  35 |         
  36 |     if config.Caption then
  37 |         icon:setCaption(config.Caption)
  38 |     end
  39 |     
  40 |     icon.selected:Connect(toggleFunc)
  41 |     icon.deselected:Connect(toggleFunc)
  42 |     
  43 |     return icon
  44 | end
  45 | 
  46 | return TopbarBridge
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/ScreenWrapper.lua</strong> (37 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/ScreenWrapper.lua`

```lua
   1 | --[[ @Component: ScreenWrapper (Input Fixed) ]]
   2 | local Players = game:GetService("Players")
   3 | 
   4 | return function(API)
   5 |     return function(scope, props)
   6 |         local player = Players.LocalPlayer
   7 |         local targetParent = player and player:WaitForChild("PlayerGui")
   8 |         
   9 |         return scope:New "ScreenGui" {
  10 |             Name = props.Name or "OVHL_Screen",
  11 |             Parent = targetParent,
  12 |             DisplayOrder = props.DisplayOrder or 10,
  13 |             ResetOnSpawn = false,
  14 |             Enabled = props.Enabled,
  15 |             IgnoreGuiInset = true,
  16 |             ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
  17 |             
  18 |             [API.Children] = {
  19 |                 scope:New "UIScale" {
  20 |                     Scale = 1 -- Biarkan default, kita atur scaling di konten
  21 |                 },
  22 |                 
  23 |                 -- COORDINATE ENFORCER (CANVAS)
  24 |                 scope:New "Frame" {
  25 |                     Name = "Canvas",
  26 |                     Size = UDim2.fromScale(1, 1),
  27 |                     BackgroundTransparency = 1,
  28 |                     BorderSizePixel = 0,
  29 |                     ZIndex = 1,
  30 |                     Active = false, -- [FIX] PENTING! Biar klik tembus ke tombol
  31 |                     
  32 |                     [API.Children] = props.Content
  33 |                 }
  34 |             }
  35 |         }
  36 |     end
  37 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/SmartButton.lua</strong> (47 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/SmartButton.lua`

```lua
   1 | --[[ @Component: Smart Button (Bootstrap Logic) ]]
   2 | return function(API)
   3 |     local Theme = API.Theme
   4 |     
   5 |     return function(scope, props)
   6 |         local style = props.Style or "Solid" -- Solid, Outlined, Ghost, Danger
   7 |         
   8 |         -- Logic Pewarnaan Otomatis (Foundation Level)
   9 |         local bgColor = Theme.Colors.Primary
  10 |         local textColor = Theme.Colors.TextInverse -- Hitam di atas hijau
  11 |         local strokeColor = Theme.Colors.Primary
  12 |         local strokeTrans = 1
  13 |         
  14 |         if style == "Outlined" then
  15 |             bgColor = Theme.Colors.Surface
  16 |             textColor = Theme.Colors.TextMain -- Putih
  17 |             strokeColor = Theme.Colors.Border -- Zinc 700 (Terang)
  18 |             strokeTrans = 0
  19 |         elseif style == "Ghost" then
  20 |             bgColor = Theme.Colors.Surface
  21 |             textColor = Theme.Colors.TextMuted
  22 |             strokeTrans = 1
  23 |         elseif style == "Danger" then
  24 |             bgColor = Theme.Colors.Danger
  25 |             textColor = Theme.Colors.TextMain
  26 |         end
  27 |         
  28 |         return scope:Button {
  29 |             Content = { props.Text }, -- Mapping Text -> Content
  30 |             Color = bgColor,
  31 |             ContentColor = textColor,
  32 |             
  33 |             -- Styling
  34 |             Size = UDim2.new(1, 0, 0, 44), -- Default Full Width
  35 |             Corner = { Radius = scope:UDim(0, 8) },
  36 |             
  37 |             -- Border Logic
  38 |             Stroke = {
  39 |                 Color = strokeColor,
  40 |                 Thickness = 1,
  41 |                 Transparency = strokeTrans
  42 |             },
  43 |             
  44 |             OnActivated = props.OnClick
  45 |         }
  46 |     end
  47 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/Window.lua</strong> (90 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/Window.lua`

```lua
   1 | --[[ @Component: Standard Window (Modal Center) ]]
   2 | return function(API)
   3 |     local Theme = API.Theme
   4 |     
   5 |     return function(scope, props)
   6 |         return scope:Frame {
   7 |             Name = "ModalWindow",
   8 |             
   9 |             -- CENTERING LOGIC (ABSOLUTE)
  10 |             -- Ini akan bekerja karena parentnya adalah "CoordinateSpace" (100% size)
  11 |             AnchorPoint = Vector2.new(0.5, 0.5),
  12 |             Position = UDim2.fromScale(0.5, 0.5),
  13 |             Size = props.Size or UDim2.fromOffset(450, 300),
  14 |             
  15 |             -- Styling
  16 |             BackgroundColor3 = Theme.Colors.Surface,
  17 |             BackgroundTransparency = 0,
  18 |             
  19 |             Corner = { Radius = scope:UDim(0, 12) },
  20 |             
  21 |             -- Shadow Effect (UIStroke Shadow Trick)
  22 |             Stroke = { 
  23 |                 Color = Color3.fromRGB(0, 0, 0),
  24 |                 Thickness = 4,
  25 |                 Transparency = 0.8 -- Shadow halus di pinggir
  26 |             },
  27 |             
  28 |             [API.Children] = {
  29 |                 -- Inner Border (Untuk ketegasan)
  30 |                 scope:New "UIStroke" {
  31 |                     Color = Theme.Colors.Border,
  32 |                     Thickness = 1,
  33 |                     Transparency = 0,
  34 |                     ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  35 |                 },
  36 | 
  37 |                 -- 1. HEADER
  38 |                 scope:Frame {
  39 |                     Name = "Header",
  40 |                     Size = UDim2.new(1, 0, 0, 56),
  41 |                     BackgroundTransparency = 1,
  42 |                     Padding = { Left = scope:UDim(0, 24), Right = scope:UDim(0, 24) },
  43 |                     
  44 |                     [API.Children] = {
  45 |                         scope:Text {
  46 |                             Text = props.Title or "Window",
  47 |                             TextColor3 = Theme.Colors.TextMain,
  48 |                             TextSize = 20,
  49 |                             FontFace = Theme.Font.Header,
  50 |                             TextXAlignment = Enum.TextXAlignment.Left,
  51 |                             Size = UDim2.fromScale(1, 1)
  52 |                         },
  53 |                         
  54 |                         -- Close Button (Top Right)
  55 |                         scope:IconButton {
  56 |                             Image = API.Icons.General.Close,
  57 |                             Size = UDim2.fromOffset(32, 32),
  58 |                             AnchorPoint = Vector2.new(1, 0.5),
  59 |                             Position = UDim2.new(1, 0, 0.5, 0),
  60 |                             Color = Theme.Colors.Surface,
  61 |                             Style = "Ghost",
  62 |                             OnActivated = props.OnClose
  63 |                         }
  64 |                     }
  65 |                 },
  66 |                 
  67 |                 -- 2. SEPARATOR
  68 |                 scope:Frame {
  69 |                     Name = "Separator",
  70 |                     Size = UDim2.new(1, 0, 0, 1),
  71 |                     Position = UDim2.fromOffset(0, 56),
  72 |                     BackgroundColor3 = Theme.Colors.Border,
  73 |                     BackgroundTransparency = 0,
  74 |                     BorderSizePixel = 0
  75 |                 },
  76 |                 
  77 |                 -- 3. CONTENT CONTAINER
  78 |                 scope:Frame {
  79 |                     Name = "Body",
  80 |                     Size = UDim2.new(1, 0, 1, -57),
  81 |                     Position = UDim2.fromOffset(0, 57),
  82 |                     BackgroundTransparency = 1,
  83 |                     Padding = { All = scope:UDim(0, 24) },
  84 |                     
  85 |                     [API.Children] = props[API.Children]
  86 |                 }
  87 |             }
  88 |         }
  89 |     end
  90 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Icons.lua</strong> (15 lines, 458B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Icons.lua`

```lua
   1 | --[[ @Foundation: Icons (Asset Registry) ]]
   2 | -- Source of Truth for Asset IDs.
   3 | return {
   4 |     General = {
   5 |         Close    = "rbxassetid://7743878857",
   6 |         Back     = "rbxassetid://7743875484",
   7 |         Search   = "rbxassetid://7743878738",
   8 |         Settings = "rbxassetid://7743878358",
   9 |     },
  10 |     Status = {
  11 |         Success  = "rbxassetid://11572598370",
  12 |         Error    = "rbxassetid://11572598737",
  13 |         Warning  = "rbxassetid://11572599248",
  14 |     }
  15 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Layers.lua</strong> (9 lines, 173B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Layers.lua`

```lua
   1 | --[[ @Foundation: Layers (Z-Index Registry) ]]
   2 | return {
   3 |     Base    = 0,
   4 |     Page    = 10,
   5 |     Window  = 100,
   6 |     Modal   = 1000,
   7 |     Overlay = 5000,
   8 |     Debug   = 10000,
   9 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/SafeLoader.lua</strong> (50 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/SafeLoader.lua`

```lua
   1 | --[[ @Foundation: SafeLoader (Secure Error Boundary) ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local RunService = game:GetService("RunService")
   4 | local Fusion = require(RS.Packages.Fusion)
   5 | 
   6 | local SafeLoader = {}
   7 | 
   8 | function SafeLoader.Mount(scope, componentFunc, props)
   9 |     local success, result = xpcall(function()
  10 |         return componentFunc(scope, props)
  11 |     end, debug.traceback)
  12 | 
  13 |     if success then
  14 |         return result
  15 |     else
  16 |         -- LOGGING (Internal)
  17 |         warn("[OVHL UI CRITICAL FAIL]")
  18 |         warn(result)
  19 |         
  20 |         -- ERROR UI (Sanitized for Production)
  21 |         local errorMsg = "UI Component Failed to Load."
  22 |         if RunService:IsStudio() then
  23 |             errorMsg = errorMsg .. "\n\nDEBUG INFO:\n" .. tostring(result)
  24 |         else
  25 |             errorMsg = errorMsg .. "\nPlease rejoin or contact developer."
  26 |         end
  27 |         
  28 |         return scope:New "Frame" {
  29 |             Name = "ErrorBoundary",
  30 |             Size = UDim2.fromScale(1, 1),
  31 |             BackgroundColor3 = Color3.fromRGB(20, 5, 5),
  32 |             ZIndex = 99999,
  33 |             
  34 |             [Fusion.Children] = {
  35 |                 scope:New "TextLabel" {
  36 |                     Size = UDim2.fromScale(0.8, 0.8),
  37 |                     Position = UDim2.fromScale(0.1, 0.1),
  38 |                     Text = errorMsg,
  39 |                     TextColor3 = Color3.fromRGB(255, 100, 100),
  40 |                     BackgroundTransparency = 1,
  41 |                     TextSize = 14,
  42 |                     TextWrapped = true,
  43 |                     Font = Enum.Font.Code
  44 |                 }
  45 |             }
  46 |         }
  47 |     end
  48 | end
  49 | 
  50 | return SafeLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Theme.lua</strong> (45 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Theme.lua`

```lua
   1 | --[[ @Foundation: Theme (Calibrated High Contrast) ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | 
   4 | -- Palette (Zinc & Emerald)
   5 | local P = {
   6 |     Black      = Color3.fromHex("000000"),
   7 |     Zinc950    = Color3.fromHex("09090b"), -- App BG
   8 |     Zinc900    = Color3.fromHex("18181b"), -- Card Surface
   9 |     Zinc800    = Color3.fromHex("27272a"), -- Input BG
  10 |     Zinc700    = Color3.fromHex("3f3f46"), -- Border (Lighter!)
  11 |     Zinc600    = Color3.fromHex("52525b"), -- Secondary Hover
  12 |     Zinc400    = Color3.fromHex("a1a1aa"), -- Muted Text
  13 |     White      = Color3.fromHex("ffffff"),
  14 |     
  15 |     Emerald500 = Color3.fromHex("10b981"), -- Brand
  16 |     Emerald600 = Color3.fromHex("059669"), -- Brand Hover
  17 |     
  18 |     Red500     = Color3.fromHex("ef4444"), -- Danger
  19 | }
  20 | 
  21 | return {
  22 |     Colors = {
  23 |         -- Surfaces
  24 |         Background  = P.Zinc950,
  25 |         Surface     = P.Zinc900, 
  26 |         
  27 |         -- Borders (Crucial for Outline Buttons)
  28 |         Border      = P.Zinc700, -- Jauh lebih terang dari Surface
  29 |         
  30 |         -- Actions
  31 |         Primary     = P.Emerald500,
  32 |         PrimaryDark = P.Emerald600,
  33 |         Secondary   = P.Zinc800,
  34 |         Danger      = P.Red500,
  35 |         
  36 |         -- Typography
  37 |         TextMain    = P.White,
  38 |         TextMuted   = P.Zinc400,
  39 |         TextInverse = P.Black,
  40 |     },
  41 |     Font = {
  42 |         Header = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
  43 |         Body   = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
  44 |     }
  45 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Views/PrototypePetInventory/Window.lua</strong> (292 lines, 14K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Views/PrototypePetInventory/Window.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local UI = require(RS.OVHL.UI.Foundation.API)
   3 | 
   4 | -- Helper Button (Updated Style)
   5 | local function CustomButton(scope, props)
   6 |     return scope:Button {
   7 |         Content = { props.Text },
   8 |         Color = props.Color,
   9 |         ContentColor = Color3.new(1,1,1),
  10 |         -- [FIX] Ukuran tombol lebih proporsional (Scale + Offset)
  11 |         Size = props.Size or UDim2.new(1, 0, 0, 44), 
  12 |         Corner = { Radius = UDim.new(0, 8) },
  13 |         Stroke = { 
  14 |             Color = Color3.new(0,0,0), 
  15 |             Transparency = 0.5, 
  16 |             Thickness = 2 
  17 |         },
  18 |         -- [FIX] Text Size lebih besar
  19 |         ContentSize = 18,
  20 |         OnActivated = props.OnClick
  21 |     }
  22 | end
  23 | 
  24 | -- Helper Slot
  25 | local function PetSlot(scope, props)
  26 |     local data = props.Data
  27 |     local cfg = props.Config.UI
  28 |     
  29 |     return scope:Frame {
  30 |         Name = "PetSlot",
  31 |         BackgroundColor3 = cfg.Colors.HeaderPill,
  32 |         BackgroundTransparency = 0,
  33 |         Corner = { Radius = UDim.new(0, 8) },
  34 |         Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 2 },
  35 |         
  36 |         [UI.Children] = {
  37 |             scope:Text {
  38 |                 Text = data.Icon or "🐶",
  39 |                 TextSize = 42, -- [FIX] Lebih besar
  40 |                 Size = UDim2.new(1,0,0.7,0),
  41 |                 BackgroundTransparency = 1,
  42 |                 TextYAlignment = Enum.TextYAlignment.Center
  43 |             },
  44 |             scope:Frame {
  45 |                 Size = UDim2.new(1, 0, 0.3, 0),
  46 |                 Position = UDim2.fromScale(0, 0.7),
  47 |                 BackgroundColor3 = data.RarityColor,
  48 |                 Corner = { Radius = UDim.new(0, 8) },
  49 |                 [UI.Children] = {
  50 |                     scope:Frame {
  51 |                         Size = UDim2.new(1, 0, 0.5, 0),
  52 |                         BackgroundColor3 = data.RarityColor,
  53 |                         BorderSizePixel = 0
  54 |                     },
  55 |                     scope:Text {
  56 |                         Text = data.Name,
  57 |                         TextSize = 14, -- [FIX] Readable
  58 |                         TextColor3 = Color3.new(1,1,1),
  59 |                         Size = UDim2.fromScale(1, 1),
  60 |                         FontFace = UI.Theme.Font.Bold
  61 |                     }
  62 |                 }
  63 |             }
  64 |         }
  65 |     }
  66 | end
  67 | 
  68 | return function(scope, props)
  69 |     local cfg = props.Config.UI
  70 |     local state = props.State
  71 |     
  72 |     return scope:ScreenWrapper {
  73 |         Name = "PetInventoryUI",
  74 |         Enabled = props.Visible,
  75 |         DisplayOrder = UI.Layers.Window,
  76 |         
  77 |         -- [FIX] CONTAINER UTAMA (Responsive Center)
  78 |         Content = scope:Frame {
  79 |             Name = "ResponsiveContainer",
  80 |             AnchorPoint = Vector2.new(0.5, 0.5),
  81 |             Position = UDim2.fromScale(0.5, 0.5),
  82 |             
  83 |             -- Ukuran adaptif: 80% lebar layar, tapi max 800px
  84 |             Size = UDim2.fromScale(0.9, 0.8), 
  85 |             BackgroundTransparency = 1,
  86 |             
  87 |             -- [FIX] Aspect Ratio Constraint (Biar gak gepeng di Mobile)
  88 |             [UI.Children] = {
  89 |                 scope:New "UISizeConstraint" {
  90 |                     MaxSize = Vector2.new(900, 600),
  91 |                     MinSize = Vector2.new(600, 400)
  92 |                 },
  93 |                 
  94 |                 -- CONTENT LAYOUT (Horizontal Panel)
  95 |                 scope:New "UIListLayout" {
  96 |                     FillDirection = Enum.FillDirection.Horizontal,
  97 |                     Padding = UDim.new(0, 16),
  98 |                     HorizontalAlignment = Enum.HorizontalAlignment.Center,
  99 |                     VerticalAlignment = Enum.VerticalAlignment.Center
 100 |                 },
 101 | 
 102 |                 -- === LEFT PANEL (35%) ===
 103 |                 scope:Frame {
 104 |                     Name = "LeftPanel",
 105 |                     Size = UDim2.new(0.35, -8, 1, 0),
 106 |                     BackgroundColor3 = cfg.Colors.PanelBG,
 107 |                     BackgroundTransparency = 0,
 108 |                     Corner = { Radius = UDim.new(0, 16) },
 109 |                     Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 3 },
 110 |                     
 111 |                     [UI.Children] = {
 112 |                         -- Header
 113 |                         scope:Frame {
 114 |                             Size = UDim2.fromOffset(120, 40),
 115 |                             Position = UDim2.fromScale(0.5, 0),
 116 |                             AnchorPoint = Vector2.new(0.5, 0.5),
 117 |                             BackgroundColor3 = cfg.Colors.HeaderPill,
 118 |                             Corner = { Radius = UDim.new(0, 12) },
 119 |                             Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 2 },
 120 |                             ZIndex = 2,
 121 |                             [UI.Children] = {
 122 |                                 scope:Text {
 123 |                                     Text = cfg.Labels.TitleLeft,
 124 |                                     TextColor3 = Color3.new(1,1,1),
 125 |                                     FontFace = UI.Theme.Font.Bold,
 126 |                                     TextSize = 18,
 127 |                                     Size = UDim2.fromScale(1, 1)
 128 |                                 }
 129 |                             }
 130 |                         },
 131 |                         
 132 |                         -- Content
 133 |                         scope:Frame {
 134 |                             Size = UDim2.fromScale(1, 1),
 135 |                             BackgroundTransparency = 1,
 136 |                             Padding = { Top = UDim.new(0, 40), Left = UDim.new(0, 12), Right = UDim.new(0, 12), Bottom = UDim.new(0, 12) },
 137 |                             
 138 |                             List = {
 139 |                                 FillDirection = Enum.FillDirection.Vertical,
 140 |                                 Padding = UDim.new(0, 12),
 141 |                                 VerticalAlignment = Enum.VerticalAlignment.Top
 142 |                             },
 143 |                             
 144 |                             [UI.Children] = {
 145 |                                 -- Preview Box
 146 |                                 scope:Frame {
 147 |                                     Size = UDim2.new(1, 0, 0, 180), -- Lebih pendek dikit biar muat
 148 |                                     BackgroundColor3 = cfg.Colors.HeaderPill,
 149 |                                     Corner = { Radius = UDim.new(0, 12) },
 150 |                                     Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 2 },
 151 |                                     [UI.Children] = {
 152 |                                         scope:Text {
 153 |                                             Text = scope:Computed(function(use) 
 154 |                                                 local pet = use(state.SelectedPet)
 155 |                                                 return pet and pet.Icon or "?"
 156 |                                             end),
 157 |                                             TextSize = 100,
 158 |                                             Size = UDim2.fromScale(1, 1),
 159 |                                             BackgroundTransparency = 1
 160 |                                         }
 161 |                                     }
 162 |                                 },
 163 |                                 
 164 |                                 scope:Frame { Size = UDim2.new(1, 0, 1, -290), BackgroundTransparency = 1 },
 165 |                                 
 166 |                                 CustomButton(scope, {
 167 |                                     Text = cfg.Labels.BtnEquip,
 168 |                                     Color = cfg.Colors.BtnEquip,
 169 |                                     OnClick = props.OnEquip
 170 |                                 }),
 171 |                                 
 172 |                                 scope:Frame {
 173 |                                     Size = UDim2.new(1, 0, 0, 44),
 174 |                                     BackgroundTransparency = 1,
 175 |                                     List = { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), HorizontalFlex = Enum.UIFlexAlignment.Fill },
 176 |                                     [UI.Children] = {
 177 |                                         CustomButton(scope, { Text = cfg.Labels.BtnMerge, Color = cfg.Colors.BtnMerge, Size = UDim2.new(0,0,1,0), OnClick = props.OnMerge }),
 178 |                                         CustomButton(scope, { Text = cfg.Labels.BtnDelete, Color = cfg.Colors.BtnDelete, Size = UDim2.new(0,0,1,0), OnClick = props.OnDelete })
 179 |                                     }
 180 |                                 }
 181 |                             }
 182 |                         }
 183 |                     }
 184 |                 },
 185 | 
 186 |                 -- === RIGHT PANEL (65%) ===
 187 |                 scope:Frame {
 188 |                     Name = "RightPanel",
 189 |                     Size = UDim2.new(0.65, -8, 1, 0),
 190 |                     BackgroundColor3 = cfg.Colors.PanelBG,
 191 |                     BackgroundTransparency = 0,
 192 |                     Corner = { Radius = UDim.new(0, 16) },
 193 |                     Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 3 },
 194 |                     
 195 |                     [UI.Children] = {
 196 |                         -- Header
 197 |                         scope:Frame {
 198 |                             Size = UDim2.fromOffset(160, 40),
 199 |                             Position = UDim2.fromScale(0.5, 0),
 200 |                             AnchorPoint = Vector2.new(0.5, 0.5),
 201 |                             BackgroundColor3 = cfg.Colors.HeaderPill,
 202 |                             Corner = { Radius = UDim.new(0, 12) },
 203 |                             Stroke = { Color = cfg.Colors.PanelBorder, Thickness = 2 },
 204 |                             ZIndex = 2,
 205 |                             [UI.Children] = {
 206 |                                 scope:Text {
 207 |                                     Text = cfg.Labels.TitleRight,
 208 |                                     TextColor3 = Color3.new(1,1,1),
 209 |                                     FontFace = UI.Theme.Font.Bold,
 210 |                                     TextSize = 18
 211 |                                 }
 212 |                             }
 213 |                         },
 214 |                         
 215 |                         -- Close
 216 |                         scope:IconButton {
 217 |                             Image = UI.Icons.General.Close,
 218 |                             Size = UDim2.fromOffset(32, 32),
 219 |                             Position = UDim2.new(1, -12, 0, -12),
 220 |                             AnchorPoint = Vector2.new(0.5, 0.5),
 221 |                             Color = cfg.Colors.BtnDelete,
 222 |                             ZIndex = 3,
 223 |                             OnActivated = props.OnClose
 224 |                         },
 225 |                         
 226 |                         -- Content
 227 |                         scope:Frame {
 228 |                             Size = UDim2.fromScale(1, 1),
 229 |                             BackgroundTransparency = 1,
 230 |                             Padding = { Top = UDim.new(0, 40), Left = UDim.new(0, 12), Right = UDim.new(0, 12), Bottom = UDim.new(0, 12) },
 231 |                             
 232 |                             [UI.Children] = {
 233 |                                 -- Scroller
 234 |                                 scope:Scroller {
 235 |                                     Size = UDim2.new(1, 0, 1, -60),
 236 |                                     CanvasSize = UDim2.new(0, 0, 0, 0),
 237 |                                     AutomaticCanvasSize = Enum.AutomaticSize.Y,
 238 |                                     
 239 |                                     [UI.Children] = {
 240 |                                         scope:New "UIGridLayout" {
 241 |                                             CellSize = UDim2.fromOffset(90, 110), -- [FIX] Sedikit lebih kecil biar muat banyak
 242 |                                             CellPadding = UDim2.fromOffset(10, 10),
 243 |                                             HorizontalAlignment = Enum.HorizontalAlignment.Center
 244 |                                         },
 245 |                                         scope:ForValues(state.Inventory, function(use, innerScope, item)
 246 |                                             if not innerScope.Text then
 247 |                                                 local Onyx = require(RS.Packages["onyx-ui"])
 248 |                                                 for k, v in pairs(Onyx.Components) do innerScope[k] = v end
 249 |                                             end
 250 |                                             return PetSlot(innerScope, { Data = item, Config = props.Config })
 251 |                                         end)
 252 |                                     }
 253 |                                 },
 254 |                                 
 255 |                                 -- Footer
 256 |                                 scope:Frame {
 257 |                                     Size = UDim2.new(1, 0, 0, 44),
 258 |                                     AnchorPoint = Vector2.new(0, 1),
 259 |                                     Position = UDim2.fromScale(0, 1),
 260 |                                     BackgroundTransparency = 1,
 261 |                                     
 262 |                                     [UI.Children] = {
 263 |                                         scope:Frame {
 264 |                                             Size = UDim2.fromScale(0.7, 1),
 265 |                                             BackgroundTransparency = 1,
 266 |                                             List = { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom },
 267 |                                             [UI.Children] = {
 268 |                                                 CustomButton(scope, { Text = cfg.Labels.BtnMulti, Color = cfg.Colors.BtnDelete, Size = UDim2.fromOffset(120, 36) }),
 269 |                                                 CustomButton(scope, { Text = cfg.Labels.BtnMergeAll, Color = cfg.Colors.BtnEquip, Size = UDim2.fromOffset(120, 36) }),
 270 |                                             }
 271 |                                         },
 272 |                                         scope:Frame {
 273 |                                             Size = UDim2.fromScale(0.3, 1),
 274 |                                             Position = UDim2.fromScale(1, 0),
 275 |                                             AnchorPoint = Vector2.new(1, 0),
 276 |                                             BackgroundTransparency = 1,
 277 |                                             List = { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center },
 278 |                                             [UI.Children] = {
 279 |                                                 scope:Text { Text = "6/100", TextSize = 18, TextColor3 = Color3.new(1,1,1), FontFace = UI.Theme.Font.Bold, AutomaticSize = Enum.AutomaticSize.X },
 280 |                                                 CustomButton(scope, { Text = "+", Color = cfg.Colors.BtnGreen, Size = UDim2.fromOffset(36, 36) })
 281 |                                             }
 282 |                                         }
 283 |                                     }
 284 |                                 }
 285 |                             }
 286 |                         }
 287 |                     }
 288 |                 }
 289 |             }
 290 |         }
 291 |     }
 292 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Views/ShowcaseSystem/Window.lua</strong> (58 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Views/ShowcaseSystem/Window.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local UI = require(RS.OVHL.UI.Foundation.API)
   3 | 
   4 | return function(scope, props)
   5 |     local cfg = props.Config.UI
   6 |     
   7 |     return scope:ScreenWrapper {
   8 |         Name = "ShowcaseWindow",
   9 |         DisplayOrder = UI.Layers.Window,
  10 |         Enabled = props.Visible,
  11 |         
  12 |         Content = scope:Window {
  13 |             Title = cfg.Title,
  14 |             Size = UDim2.fromOffset(420, 260),
  15 |             OnClose = props.OnClose,
  16 |             
  17 |             [UI.Children] = {
  18 |                 scope:Frame {
  19 |                     BackgroundTransparency = 1,
  20 |                     Size = UDim2.fromScale(1, 1),
  21 |                     
  22 |                     List = {
  23 |                         FillDirection = Enum.FillDirection.Vertical,
  24 |                         Padding = scope:UDim(0, 12),
  25 |                         VerticalAlignment = Enum.VerticalAlignment.Center
  26 |                     },
  27 |                     
  28 |                     [UI.Children] = {
  29 |                         -- Subtitle
  30 |                         scope:Text {
  31 |                             Text = cfg.Subtitle,
  32 |                             TextColor3 = UI.Theme.Colors.TextMuted,
  33 |                             TextSize = 14,
  34 |                             TextXAlignment = Enum.TextXAlignment.Center,
  35 |                             Size = UDim2.new(1, 0, 0, 20)
  36 |                         },
  37 |                         
  38 |                         scope:Frame { Size = UDim2.fromOffset(0, 8) },
  39 |                         
  40 |                         -- Primary Action
  41 |                         scope:SmartButton {
  42 |                             Text = cfg.Labels.Action,
  43 |                             Style = "Solid",
  44 |                             OnClick = props.OnAction
  45 |                         },
  46 |                         
  47 |                         -- Secondary Action
  48 |                         scope:SmartButton {
  49 |                             Text = cfg.Labels.Close,
  50 |                             Style = "Outlined",
  51 |                             OnClick = props.OnClose
  52 |                         }
  53 |                     }
  54 |                 }
  55 |             }
  56 |         }
  57 |     }
  58 | end
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Config/PermissionConfig.lua</strong> (4 lines, 117B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Config/PermissionConfig.lua`

```lua
   1 | return {
   2 |     Provider = "HDAdmin", -- Switchable: HDAdmin, Adonis, etc
   3 |     Settings = { OwnerIsSuperAdmin = true }
   4 | }
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Kernel.lua</strong> (77 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Kernel.lua`

```lua
   1 | --[[ @Component: Kernel (Server - DI Container) ]]
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local SS = game:GetService("ServerScriptService")
   4 | 
   5 | local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
   6 | local Config = require(RS.OVHL.Core.SharedConfigLoader)
   7 | local Context = require(RS.OVHL.Core.Context)
   8 | local Bridge = require(SS.OVHL.Core.NetworkBridge)
   9 | local RateLimiter = require(SS.OVHL.Core.RateLimiter)
  10 | local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)
  11 | 
  12 | -- Static Requires for Core Services
  13 | local Services = {
  14 |     Perms = require(SS.OVHL.Services.PermissionService),
  15 |     Data  = require(SS.OVHL.Services.DataManager),
  16 |     Notif = require(SS.OVHL.Services.NotificationService)
  17 | }
  18 | -- Adapters Loaded Here
  19 | local Adapters = {
  20 |     DB = require(SS.OVHL.Core.Permissions.Adapters.InternalDB),
  21 |     HD = require(SS.OVHL.Core.Permissions.Adapters.HDAdmin)
  22 | }
  23 | 
  24 | local Kernel = {}
  25 | 
  26 | function Kernel.Boot()
  27 |     local log = LoggerFactory.System()
  28 |     log:Info("🚀 SERVER STARTUP")
  29 | 
  30 |     local systems = {
  31 |         LoggerFactory = LoggerFactory, ConfigLoader = Config, RateLimiter = RateLimiter.New(),
  32 |         Permissions = Services.Perms, DataManager = Services.Data, Notification = Services.Notif,
  33 |         Adapters = Adapters
  34 |     }
  35 | 
  36 |     local ctx = Context.New(systems)
  37 |     ctx.Network = Bridge.New(ctx)
  38 |     systems.Network = ctx.Network
  39 | 
  40 |     -- Inject Loggers
  41 |     Services.Perms.Logger = LoggerFactory.Create("PERMISSION")
  42 |     Services.Data.Logger = LoggerFactory.Create("DATA")
  43 |     Services.Notif.Logger = LoggerFactory.Create("NOTIF")
  44 | 
  45 |     -- Load Feature Modules
  46 |     local modules = {}
  47 |     for _, f in ipairs(SS.OVHL.Modules:GetChildren()) do
  48 |         local script = f:FindFirstChild("Service")
  49 |         if script then
  50 |             local srv = require(script)
  51 |             local domain = DomainResolver.Resolve(f.Name)
  52 |             srv.Logger = LoggerFactory.Create(domain)
  53 |             srv._config = Config.Load(f.Name)
  54 |             modules[f.Name] = srv
  55 |             
  56 |             if srv._config.Network then
  57 |                 systems.Network:Register(f.Name, srv._config.Network)
  58 |                 systems.Network:Bind(f.Name, srv)
  59 |             end
  60 |         end
  61 |     end
  62 | 
  63 |     -- Lifecycle
  64 |     local function run(o, m) if o[m] then o[m](o, ctx) end end
  65 |     
  66 |     log:Info("Phase 1: Init")
  67 |     run(Services.Perms, "Init"); run(Services.Data, "Init"); run(Services.Notif, "Init")
  68 |     for _, m in pairs(modules) do run(m, "Init") end
  69 | 
  70 |     log:Info("Phase 2: Start")
  71 |     local function bg(o) if o.Start then task.spawn(function() o:Start() end) end end
  72 |     bg(Services.Perms); bg(Services.Data); bg(Services.Notif)
  73 |     for _, m in pairs(modules) do bg(m) end
  74 | 
  75 |     log:Info("✅ SERVER READY")
  76 | end
  77 | return Kernel
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/NetworkBridge.lua</strong> (114 lines, 4K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/NetworkBridge.lua`

```lua
   1 | --[[ 
   2 |     @Component: NetworkBridge (Server V3.0 - Unified Envelope)
   3 |     Security Pillar: Inbound Validation, Outbound Sanitization, Unified Return.
   4 | ]]
   5 | local RS = game:GetService('ReplicatedStorage')
   6 | local SS = game:GetService('ServerScriptService')
   7 | 
   8 | local Guard = require(SS.OVHL.Core.NetworkGuard)
   9 | local TypeValidator = require(RS.OVHL.Core.TypeValidator)
  10 | 
  11 | local Bridge = {}
  12 | Bridge.__index = Bridge
  13 | 
  14 | function Bridge.New(ctx)
  15 |     local log = ctx.Logger
  16 |     if not log and ctx.LoggerFactory then log = ctx.LoggerFactory.Network() end
  17 | 
  18 |     local self = setmetatable({ 
  19 |         _logger = log, 
  20 |         _limit = ctx.RateLimiter,
  21 |         _root = nil
  22 |     }, Bridge)
  23 |     
  24 |     self._root = RS:FindFirstChild('OVHL_Remotes') or Instance.new('Folder', RS)
  25 |     self._root.Name = 'OVHL_Remotes'
  26 |     self._services = {}
  27 |     return self
  28 | end
  29 | 
  30 | function Bridge:Register(serviceName, netConfig)
  31 |     -- 1. Register RemoteFunctions (Requests)
  32 |     local reqs = netConfig and netConfig.Requests or {}
  33 |     for methodName, rules in pairs(reqs) do
  34 |         local remoteName = serviceName .. '_' .. methodName
  35 |         local rf = self._root:FindFirstChild(remoteName) or Instance.new('RemoteFunction', self._root)
  36 |         rf.Name = remoteName
  37 |         
  38 |         local limitKey = serviceName .. ':' .. methodName
  39 |         if rules.RateLimit and self._limit then
  40 |             self._limit:SetRule(limitKey, rules.RateLimit.Max, rules.RateLimit.Interval)
  41 |         end
  42 |         
  43 |         rf.OnServerInvoke = function(player, ...)
  44 |             return self:_handleInvoke(player, serviceName, methodName, rules, ...)
  45 |         end
  46 |     end
  47 | 
  48 |     -- 2. Register RemoteEvents (Push Events)
  49 |     local events = netConfig and netConfig.Events or {}
  50 |     for _, eventName in ipairs(events) do
  51 |         local remoteName = serviceName .. '/' .. eventName
  52 |         local re = self._root:FindFirstChild(remoteName) or Instance.new("RemoteEvent", self._root)
  53 |         re.Name = remoteName
  54 |     end
  55 | end
  56 | 
  57 | function Bridge:_handleInvoke(player, serviceName, methodName, rules, ...)
  58 |     -- A. Rate Limit
  59 |     local limitKey = serviceName .. ':' .. methodName
  60 |     if rules.RateLimit and self._limit and not self._limit:Check(player, limitKey) then
  61 |         self._logger:Warn('RateLimit', {Plr=player.Name, Method=methodName})
  62 |         return { Success=false, Error='Too Many Requests', Code=429 }
  63 |     end
  64 |     
  65 |     -- B. Inbound Cleaning
  66 |     local rawArgs = {...}
  67 |     local cleanArgs = {}
  68 |     for i,v in ipairs(rawArgs) do cleanArgs[i] = Guard.CleanIn(v) end
  69 |     
  70 |     -- C. Type Validation
  71 |     if rules.Args then
  72 |         local ok, err = TypeValidator.Validate(cleanArgs, rules.Args)
  73 |         if not ok then
  74 |             self._logger:Warn('TypeFail', {Plr=player.Name, Err=err})
  75 |             return { Success=false, Error='Invalid Arguments: '..err, Code=400 }
  76 |         end
  77 |     end
  78 |     
  79 |     -- D. Execution
  80 |     local service = self._services[serviceName]
  81 |     if service and service[methodName] then
  82 |         local success, result = pcall(service[methodName], service, player, table.unpack(cleanArgs))
  83 |         
  84 |         if not success then
  85 |             self._logger:Error('ExecError', {Method=methodName, Err=result})
  86 |             return { Success=false, Error='Internal Server Error', Code=500 }
  87 |         end
  88 |         
  89 |         -- E. Outbound Sanitization & Envelope
  90 |         local sanitized = Guard.SanitizeOutbound(result)
  91 |         if type(sanitized) == "table" and sanitized.Success ~= nil then
  92 |              return sanitized -- Pass-through if service manually wrapped it
  93 |         end
  94 |         return { Success=true, Data=sanitized }
  95 |     end
  96 |     
  97 |     return { Success=false, Error='Service Not Bound', Code=404 }
  98 | end
  99 | 
 100 | function Bridge:Bind(name, srv) self._services[name] = srv end
 101 | 
 102 | function Bridge:Fire(player, serviceName, eventName, ...)
 103 |     local remoteName = serviceName .. '/' .. eventName
 104 |     local re = self._root:FindFirstChild(remoteName)
 105 |     if re then re:FireClient(player, ...) end
 106 | end
 107 | 
 108 | function Bridge:FireAll(serviceName, eventName, ...)
 109 |     local remoteName = serviceName .. '/' .. eventName
 110 |     local re = self._root:FindFirstChild(remoteName)
 111 |     if re then re:FireAllClients(...) end
 112 | end
 113 | 
 114 | return Bridge
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/NetworkGuard.lua</strong> (71 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/NetworkGuard.lua`

```lua
   1 | --[[ @Component: NetworkGuard (Complete) ]]
   2 | local Guard = {}
   3 | 
   4 | local MAX_DEPTH = 10
   5 | local SENSITIVE_KEYS = {"API", "TOKEN", "WEBHOOK", "SECRET", "PASSWORD"}
   6 | 
   7 | -- INBOUND CLEANER (CLIENT -> SERVER)
   8 | function Guard.CleanIn(val, d)
   9 |     d = d or 0
  10 |     if d > MAX_DEPTH then return nil end
  11 |     
  12 |     local t = type(val)
  13 |     if t == "string" then return string.sub(val, 1, 1000) end -- Prevent giant strings
  14 |     if t == "number" then return (val == val and val) or 0 end -- NaN Check
  15 |     if t == "boolean" then return val end
  16 |     
  17 |     if t == "table" then
  18 |         local n = {}
  19 |         for k,v in pairs(val) do
  20 |             -- Only allow string/number keys
  21 |             if type(k) == "string" or type(k) == "number" then
  22 |                 n[k] = Guard.CleanIn(v, d+1)
  23 |             end
  24 |         end
  25 |         return n
  26 |     end
  27 |     
  28 |     -- Allow common Roblox types (Vector3, etc) pass through strictly?
  29 |     -- For V2 safety, we deny Instances to prevent replication abuse unless needed.
  30 |     -- (Modify here if you need to pass Parts)
  31 |     if typeof(val) == "Instance" then return nil end 
  32 |     
  33 |     return nil
  34 | end
  35 | 
  36 | -- OUTBOUND SANITIZER (SERVER -> CLIENT)
  37 | -- Fungsi ini yang sebelumnya HILANG (NIL)
  38 | function Guard.SanitizeOutbound(val, d)
  39 |     d = d or 0
  40 |     if d > MAX_DEPTH then return nil end
  41 |     
  42 |     local t = type(val)
  43 |     
  44 |     if t == "table" then
  45 |         local n = {}
  46 |         for k,v in pairs(val) do
  47 |             local isSafe = true
  48 |             
  49 |             -- REDACT SENSITIVE KEYS
  50 |             if type(k) == "string" then
  51 |                 local upper = string.upper(k)
  52 |                 for _, bad in ipairs(SENSITIVE_KEYS) do
  53 |                     if string.find(upper, bad) then 
  54 |                         n[k] = "[REDACTED]" 
  55 |                         isSafe = false
  56 |                         break 
  57 |                     end
  58 |                 end
  59 |             end
  60 |             
  61 |             if isSafe then
  62 |                 n[k] = Guard.SanitizeOutbound(v, d+1)
  63 |             end
  64 |         end
  65 |         return n
  66 |     end
  67 |     
  68 |     return val
  69 | end
  70 | 
  71 | return Guard
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Permissions/Adapters/HDAdmin.lua</strong> (23 lines, 643B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Permissions/Adapters/HDAdmin.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local HD = {}
   3 | local _api = nil
   4 | 
   5 | function HD.Connect(logger)
   6 |     if _api then return true end
   7 |     local setup = RS:FindFirstChild("HDAdminSetup")
   8 |     if not setup then return false end
   9 |     
  10 |     local s, r = pcall(function() return require(setup):GetMain() end)
  11 |     if s and r then 
  12 |         _api = r; logger:Info("Link", "HD Admin Connected")
  13 |         return true 
  14 |     end
  15 |     return false
  16 | end
  17 | 
  18 | function HD.GetRank(plr)
  19 |     if not _api then return 0 end
  20 |     local s, r = pcall(function() return _api:GetModule("cf"):GetRankId(plr) end)
  21 |     return (s and type(r)=="number") and r or 0
  22 | end
  23 | return HD
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Permissions/Adapters/InternalDB.lua</strong> (19 lines, 652B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Permissions/Adapters/InternalDB.lua`

```lua
   1 | local DataStoreService = game:GetService("DataStoreService")
   2 | local InternalDB = {}
   3 | local STORE = DataStoreService:GetDataStore("OVHL_Global_Permissions")
   4 | 
   5 | function InternalDB.Get(userId)
   6 |     local s, r = pcall(function() return STORE:GetAsync(tostring(userId)) end)
   7 |     return (s and r and r.Rank) or 0
   8 | end
   9 | 
  10 | function InternalDB.Set(userId, rank, actor)
  11 |     local key = tostring(userId)
  12 |     if rank == 0 then 
  13 |         pcall(function() STORE:RemoveAsync(key) end)
  14 |         return true
  15 |     end
  16 |     local payload = { Rank = rank, UpdatedBy = actor, UpdatedAt = os.time() }
  17 |     return pcall(function() STORE:SetAsync(key, payload) end)
  18 | end
  19 | return InternalDB
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Permissions/HDAdminAdapter.lua</strong> (72 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Permissions/HDAdminAdapter.lua`

```lua
   1 | --[[
   2 |     🛡️ ADAPTER: HD ADMIN (ISOLATED)
   3 |     @Responsibility: Handle connection to _G.HDAdminMain securely.
   4 | ]]
   5 | local RS = game:GetService("ReplicatedStorage")
   6 | local RunService = game:GetService("RunService")
   7 | 
   8 | local HDAdminAdapter = {}
   9 | local _api = nil
  10 | local _scanning = false
  11 | 
  12 | -- Status Helper
  13 | function HDAdminAdapter.IsReady() return _api ~= nil end
  14 | 
  15 | -- SCANNING LOGIC (Dipindah dari Service)
  16 | function HDAdminAdapter.StartScan(logger)
  17 |     if _api or _scanning then return end
  18 |     _scanning = true
  19 |     
  20 |     local startTick = tick()
  21 |     local connection
  22 |     
  23 |     connection = RunService.Heartbeat:Connect(function()
  24 |         local now = tick()
  25 |         
  26 |         -- 1. Probe Global
  27 |         if _G.HDAdminMain then
  28 |             _api = _G.HDAdminMain
  29 |         end
  30 |         
  31 |         -- 2. Probe Module
  32 |         if not _api then
  33 |             local m = RS:FindFirstChild("HDAdminSetup")
  34 |             if m then
  35 |                  local s, lib = pcall(require, m)
  36 |                  if s and lib and lib.GetMain then 
  37 |                     pcall(function() _api = lib:GetMain() end) 
  38 |                  end
  39 |             end
  40 |         end
  41 |         
  42 |         -- SUCCESS
  43 |         if _api then
  44 |             logger:Info("Link", "🔗 CONNECTED to HD Admin API!")
  45 |             _scanning = false
  46 |             connection:Disconnect()
  47 |             return
  48 |         end
  49 |         
  50 |         -- TIMEOUT (10 Detik)
  51 |         if (now - startTick) > 10 then
  52 |             logger:Warn("Timeout", "⏳ HD Admin not responding (Adapter Gave Up).")
  53 |             _scanning = false
  54 |             connection:Disconnect()
  55 |         end
  56 |     end)
  57 | end
  58 | 
  59 | -- RESOLVER LOGIC
  60 | function HDAdminAdapter.GetRank(player)
  61 |     if not _api then return 0 end
  62 |     
  63 |     local s, cf = pcall(function() return _api:GetModule("cf") end)
  64 |     if s and cf then
  65 |         local raw = cf:GetRankId(player)
  66 |         if type(raw) == "number" then return raw end
  67 |     end
  68 |     
  69 |     return 0
  70 | end
  71 | 
  72 | return HDAdminAdapter
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/RateLimiter.lua</strong> (35 lines, 962B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/RateLimiter.lua`

```lua
   1 | --[[ @Component: RateLimiter (Hardened V15) ]]
   2 | local RateLimiter = {}
   3 | RateLimiter.__index = RateLimiter
   4 | 
   5 | function RateLimiter.New()
   6 |     return setmetatable({_rules={}, _track={}}, RateLimiter)
   7 | end
   8 | 
   9 | function RateLimiter:SetRule(action, max, window)
  10 |     -- Safety Fallback: Default to 1 second if nil
  11 |     self._rules[action] = {
  12 |         Max = max or 10,
  13 |         Window = window or 1 -- [FIX] Anti-Crash Default
  14 |     }
  15 | end
  16 | 
  17 | function RateLimiter:Check(player, action)
  18 |     local rule = self._rules[action]
  19 |     if not rule then return true end
  20 |     
  21 |     local key = player.UserId.."_"..action
  22 |     local now = os.time()
  23 |     local entry = self._track[key]
  24 |     
  25 |     -- [FIX] rule.Window is now guaranteed to be a number
  26 |     if not entry or (now - entry.Start > rule.Window) then
  27 |         self._track[key] = {Count=1, Start=now}
  28 |         return true
  29 |     end
  30 |     
  31 |     if entry.Count >= rule.Max then return false end
  32 |     entry.Count += 1
  33 |     return true
  34 | end
  35 | return RateLimiter
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/Inventory/Service.lua</strong> (87 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/Inventory/Service.lua`

```lua
   1 | local Srv = {}
   2 | function Srv:Init(ctx)
   3 | 	self.Log = ctx.Logger
   4 | end
   5 | function Srv:Start() end
   6 | 
   7 | -- MOCK DB
   8 | local ITEM_DB = {
   9 | 	{
  10 | 		Id = "item_001",
  11 | 		Name = "Rusty Dagger",
  12 | 		Rarity = "Common",
  13 | 		Power = 10,
  14 | 		Type = "Weapon",
  15 | 		Image = "rbxassetid://96226541857519",
  16 | 	},
  17 | 	{
  18 | 		Id = "item_002",
  19 | 		Name = "Iron Sword",
  20 | 		Rarity = "Uncommon",
  21 | 		Power = 25,
  22 | 		Type = "Weapon",
  23 | 		Image = "rbxassetid://96226541857519",
  24 | 	},
  25 | 	{
  26 | 		Id = "item_003",
  27 | 		Name = "Golden Bow",
  28 | 		Rarity = "Rare",
  29 | 		Power = 40,
  30 | 		Type = "Weapon",
  31 | 		Image = "rbxassetid://96226541857519",
  32 | 	},
  33 | 	{
  34 | 		Id = "item_004",
  35 | 		Name = "Dragon Slayer",
  36 | 		Rarity = "Legendary",
  37 | 		Power = 999,
  38 | 		Type = "Weapon",
  39 | 		Image = "rbxassetid://96226541857519",
  40 | 	},
  41 | 	{
  42 | 		Id = "item_005",
  43 | 		Name = "Wooden Shield",
  44 | 		Rarity = "Common",
  45 | 		Power = 5,
  46 | 		Type = "Armor",
  47 | 		Image = "rbxassetid://96226541857519",
  48 | 	},
  49 | 	{
  50 | 		Id = "item_006",
  51 | 		Name = "Health Potion",
  52 | 		Rarity = "Consumable",
  53 | 		Power = 0,
  54 | 		Type = "Consumable",
  55 | 		Image = "rbxassetid://96226541857519",
  56 | 	},
  57 | 	{
  58 | 		Id = "item_007",
  59 | 		Name = "Mana Potion",
  60 | 		Rarity = "Consumable",
  61 | 		Power = 0,
  62 | 		Type = "Consumable",
  63 | 		Image = "rbxassetid://96226541857519",
  64 | 	},
  65 | 	{
  66 | 		Id = "item_008",
  67 | 		Name = "Magic Scroll",
  68 | 		Rarity = "Epic",
  69 | 		Power = 0,
  70 | 		Type = "Material",
  71 | 		Image = "rbxassetid://96226541857519",
  72 | 	},
  73 | }
  74 | 
  75 | -- PLAYER INVENTORY (FULL)
  76 | local PLAYER_INV = ITEM_DB
  77 | 
  78 | function Srv:GetItems(player)
  79 | 	task.wait(0.2)
  80 | 	return { Success = true, Data = PLAYER_INV }
  81 | end
  82 | 
  83 | function Srv:Equip(player, itemId)
  84 | 	return { Success = true, Msg = "Action Performed on " .. itemId }
  85 | end
  86 | 
  87 | return Srv
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/PrototypeShop/Service.lua</strong> (10 lines, 366B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/PrototypeShop/Service.lua`

```lua
   1 | local Srv = {}
   2 | function Srv:Init(ctx) self.Log=ctx.Logger end
   3 | function Srv:Start() self.Log:Info("SHOP", "Server Ready") end
   4 | 
   5 | function Srv:BuyItem(player, item)
   6 |     self.Log:Info("SHOP", "Buying", {Plr=player.Name, Item=item})
   7 |     if item == "Sword" then return {Success=true, Msg="Purchased Sword"} end
   8 |     return {Success=false, Msg="Invalid Item"}
   9 | end
  10 | return Srv
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/ServerRuntime.server.lua</strong> (3 lines, 113B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/ServerRuntime.server.lua`

```lua
   1 | -- OVHL Server Runtime
   2 | local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)
   3 | Bootstrap.Server:Start()
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/DataManager.lua</strong> (50 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/DataManager.lua`

```lua
   1 | local Players = game:GetService("Players")
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Paths = require(RS.OVHL.Core.Paths)
   4 | local ProfileService = require(Paths.Packages.ProfileService)
   5 | 
   6 | local DataManager = {}
   7 | local ProfileStore = nil
   8 | 
   9 | local DATA_TEMPLATE = { Coins = 0, Level = 1, Inventory = {} }
  10 | 
  11 | function DataManager:Init(ctx)
  12 |     self.Logger = ctx.LoggerFactory.Create("DATA")
  13 |     self.Profiles = {}
  14 |     ProfileStore = ProfileService.GetProfileStore("OVHL_Data_V1", DATA_TEMPLATE)
  15 |     
  16 |     Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
  17 |     Players.PlayerRemoving:Connect(function(p) self:OnQuit(p) end)
  18 | end
  19 | 
  20 | function DataManager:Start() end
  21 | 
  22 | function DataManager:OnJoin(player)
  23 |     local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
  24 |     if profile then
  25 |         profile:AddUserId(player.UserId)
  26 |         profile:Reconcile()
  27 |         profile:ListenToRelease(function()
  28 |             self.Profiles[player] = nil
  29 |             player:Kick("Session Locked.")
  30 |         end)
  31 |         if player:IsDescendantOf(Players) then
  32 |             self.Profiles[player] = profile
  33 |         else
  34 |             profile:Release()
  35 |         end
  36 |     else
  37 |         player:Kick("Data Load Failed.")
  38 |     end
  39 | end
  40 | 
  41 | function DataManager:OnQuit(player)
  42 |     if self.Profiles[player] then self.Profiles[player]:Release() end
  43 | end
  44 | 
  45 | function DataManager:Get(player)
  46 |     local profile = self.Profiles[player]
  47 |     return profile and profile.Data
  48 | end
  49 | 
  50 | return DataManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/DataManager_Legacy.lua</strong> (71 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/DataManager_Legacy.lua`

```lua
   1 | --[[ @Service: DataManager V4 (ProfileService Powered) ]]
   2 | local Players = game:GetService("Players")
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | local Paths = require(RS.OVHL.Core.Paths)
   5 | 
   6 | -- Load ProfileService (Pastikan package ini ada di wally.toml!)
   7 | local ProfileService = require(Paths.Packages.ProfileService)
   8 | 
   9 | local DataManager = {}
  10 | local ProfileStore = nil
  11 | 
  12 | -- Schema Definition
  13 | local DATA_TEMPLATE = {
  14 |     Coins = 0,
  15 |     Level = 1,
  16 |     XP = 0,
  17 |     Inventory = {},
  18 |     LastLogin = 0
  19 | }
  20 | 
  21 | function DataManager:Init(ctx)
  22 |     self.Logger = ctx.LoggerFactory.Create("DATA")
  23 |     self.Profiles = {}
  24 |     
  25 |     -- Initialize ProfileStore
  26 |     ProfileStore = ProfileService.GetProfileStore("OVHL_Production_V1", DATA_TEMPLATE)
  27 |     
  28 |     Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
  29 |     Players.PlayerRemoving:Connect(function(p) self:OnQuit(p) end)
  30 | end
  31 | 
  32 | function DataManager:Start()
  33 |     self.Logger:Info("System", "ProfileService DataManager Started")
  34 | end
  35 | 
  36 | function DataManager:OnJoin(player)
  37 |     local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
  38 |     
  39 |     if profile then
  40 |         profile:AddUserId(player.UserId)
  41 |         profile:Reconcile() -- Auto-fill missing fields from Template
  42 |         
  43 |         profile:ListenToRelease(function()
  44 |             self.Profiles[player] = nil
  45 |             player:Kick("Session Locked: Profile loaded externally.")
  46 |         end)
  47 |         
  48 |         if player:IsDescendantOf(Players) then
  49 |             self.Profiles[player] = profile
  50 |             self.Logger:Info("Load", "Profile Loaded for " .. player.Name)
  51 |         else
  52 |             profile:Release()
  53 |         end
  54 |     else
  55 |         player:Kick("Critical: Failed to load data profile.")
  56 |     end
  57 | end
  58 | 
  59 | function DataManager:OnQuit(player)
  60 |     local profile = self.Profiles[player]
  61 |     if profile then
  62 |         profile:Release()
  63 |     end
  64 | end
  65 | 
  66 | function DataManager:Get(player)
  67 |     local profile = self.Profiles[player]
  68 |     return profile and profile.Data
  69 | end
  70 | 
  71 | return DataManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/MonetizationService.lua</strong> (50 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/MonetizationService.lua`

```lua
   1 | --[[ @Service: MonetizationService (V3.0 Centralized) ]]
   2 | local MPS = game:GetService("MarketplaceService")
   3 | local Players = game:GetService("Players")
   4 | 
   5 | local Srv = {}
   6 | 
   7 | function Srv:Init(ctx)
   8 |     self.Logger = ctx.LoggerFactory.Create("MONEY")
   9 |     self.Data = ctx.DataManager
  10 |     self.Handlers = {} 
  11 | end
  12 | 
  13 | function Srv:Start()
  14 |     self.Logger:Info("Start", "Monetization Dispatcher Active")
  15 |     MPS.ProcessReceipt = function(info) return self:Process(info) end
  16 | end
  17 | 
  18 | function Srv:RegisterProduct(id, handler)
  19 |     -- Defensive: Ensure Key is Number
  20 |     local numId = tonumber(id)
  21 |     if numId then
  22 |         self.Handlers[numId] = handler
  23 |         self.Logger:Debug("Register", {Id=numId})
  24 |     else
  25 |         self.Logger:Warn("RegisterFail", {Id=id, Msg="ID must be convertible to number"})
  26 |     end
  27 | end
  28 | 
  29 | function Srv:Process(info)
  30 |     local player = Players:GetPlayerByUserId(info.PlayerId)
  31 |     if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
  32 |     
  33 |     local handler = self.Handlers[tonumber(info.ProductId)]
  34 |     if handler then
  35 |         local success, err = pcall(function() handler(player, info) end)
  36 |         
  37 |         if success then
  38 |             self.Logger:Info("PurchaseSuccess", {Plr=player.Name, Product=info.ProductId})
  39 |             return Enum.ProductPurchaseDecision.PurchaseGranted
  40 |         else
  41 |             self.Logger:Error("PurchaseFail", {Plr=player.Name, Err=err})
  42 |             return Enum.ProductPurchaseDecision.NotProcessedYet
  43 |         end
  44 |     end
  45 |     
  46 |     self.Logger:Warn("NoHandler", {Product=info.ProductId})
  47 |     return Enum.ProductPurchaseDecision.PurchaseGranted 
  48 | end
  49 | 
  50 | return Srv
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/NotificationService.lua</strong> (27 lines, 864B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/NotificationService.lua`

```lua
   1 | --[[ @Component: NotificationService (Server) ]]
   2 | local Service = {}
   3 | 
   4 | function Service:Init(ctx) 
   5 |     self.Net = ctx.Network -- Bridge
   6 |     -- Register Channel Khusus Notif
   7 |     self.Bridge = self.Net:Register("NotificationSystem", {
   8 |         -- Server to Client events don't need Config definition here normally,
   9 |         -- but Bridge setup requires registration.
  10 |     }) 
  11 |     self.Remote = self.Net._root:FindFirstChild("NotificationSystem/Push") 
  12 |                   or Instance.new("RemoteEvent", self.Net._root)
  13 |     self.Remote.Name = "NotificationSystem/Push"
  14 | end
  15 | 
  16 | function Service:Start() end
  17 | 
  18 | function Service:Notify(player, message, type)
  19 |     -- Type: "Info", "Error", "Success"
  20 |     self.Remote:FireClient(player, message, type or "Info")
  21 | end
  22 | 
  23 | function Service:NotifyAll(message, type)
  24 |     self.Remote:FireAllClients(message, type or "Info")
  25 | end
  26 | 
  27 | return Service
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/PermissionService.lua</strong> (96 lines, 3K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/PermissionService.lua`

```lua
   1 | --[[ @Service: PermissionService (V18 - Domain Fixed) ]]
   2 | local Players = game:GetService("Players")
   3 | local SSS = game:GetService("ServerScriptService")
   4 | -- [FIX] Load Config agar log source jelas
   5 | local Cfg = require(SSS.OVHL.Config.PermissionConfig)
   6 | 
   7 | local Hub = {}
   8 | 
   9 | function Hub:Init(ctx)
  10 |     self.DB = ctx.Adapters.DB
  11 |     self.HD = ctx.Adapters.HD
  12 |     
  13 |     -- [FIX V18] JANGAN PAKE ctx.Logger (Itu System!)
  14 |     -- Gunakan Factory untuk create domain spesifik "PERMISSION"
  15 |     self.Logger = ctx.LoggerFactory.Create("PERMISSION")
  16 |     
  17 |     self._cache = {}
  18 |     
  19 |     ctx.Network:Register("PermissionSystem", {
  20 |         Requests = {
  21 |             SetRank = { Args = {"number", "number"}, RateLimit = {Max=10, Interval=5} },
  22 |             SearchPlayers = { Args = {"string"}, RateLimit = {Max=20, Interval=2} }
  23 |         }
  24 |     })
  25 |     ctx.Network:Bind("PermissionSystem", self)
  26 |     Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
  27 | end
  28 | 
  29 | function Hub:Start()
  30 |     if Cfg.Provider == "HDAdmin" then
  31 |         task.spawn(function()
  32 |             local i = 0
  33 |             while not self.HD.Connect(self.Logger) and i < 5 do task.wait(2); i+=1 end
  34 |             for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
  35 |         end)
  36 |     end
  37 | end
  38 | 
  39 | function Hub:OnJoin(p)
  40 |     task.delay(1.5, function() if p.Parent then self:Resolve(p) end end)
  41 | end
  42 | 
  43 | function Hub:Resolve(p)
  44 |     local rawDB = self.DB.Get(p.UserId) or 0
  45 |     local rawHD = 0
  46 |     if Cfg.Provider == "HDAdmin" then rawHD = self.HD.GetRank(p) end
  47 |     local isOwnerConfig = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
  48 |     
  49 |     local r, s = 0, "GUEST"
  50 |     if rawDB > r then r=rawDB; s="INTERNAL_DB" end
  51 |     if rawHD > r then r=rawHD; s="HD_ADMIN" end
  52 |     if isOwnerConfig then r=5; s="OWNER" end
  53 |     
  54 |     self._cache[p.UserId] = {Rank=r, Source=s}
  55 |     
  56 |     -- [FIX] Ini sekarang akan muncul sebagai [PERMISSION] di console
  57 |     self.Logger:Info("Identity", {
  58 |         User = p.Name,
  59 |         FinalRank = r,
  60 |         WinningSource = s,
  61 |         _Debug = string.format("[HD: %d] [DB: %d] [IsOwner: %s]", rawHD, rawDB, tostring(isOwnerConfig))
  62 |     })
  63 | end
  64 | 
  65 | function Hub:Check(p, req)
  66 |     local d = self._cache[p.UserId] or {Rank=0}
  67 |     local t = type(req)=="number" and req or 3
  68 |     return d.Rank >= t
  69 | end
  70 | 
  71 | function Hub:SearchPlayers(p, q)
  72 |     local res = {}
  73 |     local qs = string.lower(q or "")
  74 |     for _, v in ipairs(Players:GetPlayers()) do
  75 |         local match = (qs == "")
  76 |         if not match and (string.find(string.lower(v.Name), qs) or string.find(string.lower(v.DisplayName), qs)) then
  77 |             match = true
  78 |         end
  79 |         if match then
  80 |             local info = self._cache[v.UserId] or {Rank=0, Source="?"}
  81 |             table.insert(res, {Name=v.Name, UserId=v.UserId, CurrentRank=info.Rank, Source=info.Source})
  82 |         end
  83 |     end
  84 |     return {Success=true, Data=res}
  85 | end
  86 | 
  87 | function Hub:SetRank(p, tid, r)
  88 |     if not self:Check(p, 4) then return {Success=false, Msg="No Access"} end
  89 |     if self.DB.Set(tid, r, p.UserId) then
  90 |         local t = Players:GetPlayerByUserId(tid)
  91 |         if t then self:Resolve(t) end
  92 |         return {Success=true, Msg="Internal Rank Saved"}
  93 |     end
  94 |     return {Success=false, Msg="DB Write Error"}
  95 | end
  96 | return Hub
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua</strong> (3 lines, 113B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua`

```lua
   1 | -- OVHL Client Runtime
   2 | local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)
   3 | Bootstrap.Client:Start()
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/Admin/Controller.lua</strong> (20 lines, 499B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/Admin/Controller.lua`

```lua
   1 | local Ctrl = {}
   2 | 
   3 | function Ctrl:Init(ctx)
   4 |     self.Api = ctx.Network:Get("PermissionSystem")
   5 |     self.Logger = ctx.LoggerFactory.Create("ADMIN")
   6 | end
   7 | 
   8 | function Ctrl:Start()
   9 |     self.Logger:Info("Start", "Admin Logic Active (Headless)")
  10 |     -- Logic check permission tanpa UI
  11 | end
  12 | 
  13 | -- Fungsi logika tetap ada, tapi tidak ditrigger oleh UI
  14 | function Ctrl:SetRank(userId, rankId)
  15 |     self.Api:SetRank(userId, rankId):andThen(function(res)
  16 |         self.Logger:Info("SetRank", res)
  17 |     end)
  18 | end
  19 | 
  20 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/InputController.lua</strong> (4 lines, 82B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/InputController.lua`

```lua
   1 | local Ctrl = {}
   2 | function Ctrl:Init(ctx) end
   3 | function Ctrl:Start() end
   4 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/NotificationController.lua</strong> (16 lines, 476B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/NotificationController.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local Ctrl = {}
   3 | 
   4 | function Ctrl:Init(ctx)
   5 |     self.Log = ctx.Logger
   6 |     local root = RS:WaitForChild("OVHL_Remotes")
   7 |     local remote = root:WaitForChild("NotificationSystem/Push", 5)
   8 |     if remote then
   9 |         remote.OnClientEvent:Connect(function(msg, kind)
  10 |             -- Tanpa UI, notifikasi masuk ke Console
  11 |             self.Log:Info("NOTIF", msg, {Type=kind})
  12 |         end)
  13 |     end
  14 | end
  15 | function Ctrl:Start() end
  16 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/TopbarPlusAdapter.lua</strong> (7 lines, 210B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/TopbarPlusAdapter.lua`

```lua
   1 | local Adapter = {}
   2 | Adapter.__index = Adapter
   3 | function Adapter.New() return setmetatable({}, Adapter) end
   4 | function Adapter:Init(ctx) end
   5 | function Adapter:Add() end
   6 | function Adapter:SetState() end
   7 | return Adapter
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Core/AssetLoader.lua</strong> (18 lines, 574B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/AssetLoader.lua`

```lua
   1 | --[[ @Component: AssetLoader (Client - Wally Promise) ]]
   2 | local Content = game:GetService("ContentProvider")
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | -- WALLY REQUIRE
   5 | local Promise = require(RS.Packages.Promise) 
   6 | 
   7 | local Loader = {}
   8 | function Loader.Load(assets)
   9 |     return Promise.new(function(resolve)
  10 |         local list = {}
  11 |         for _,v in pairs(assets) do 
  12 |             if type(v) == "string" and v:match("^rbxasset") then table.insert(list, v) end
  13 |         end
  14 |         pcall(function() Content:PreloadAsync(list) end)
  15 |         resolve()
  16 |     end)
  17 | end
  18 | return Loader
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Core/FinderService.lua</strong> (63 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/FinderService.lua`

```lua
   1 | --[[ @Component: FinderService (Anti-Break Logic) ]]
   2 | local CollectionService = game:GetService("CollectionService")
   3 | local Players = game:GetService("Players")
   4 | local Player = Players.LocalPlayer
   5 | local PlayerGui = Player:WaitForChild("PlayerGui")
   6 | 
   7 | local Finder = {}
   8 | 
   9 | -- Strategy: Direct > Attribute > Tag > Name > Recursive Pattern
  10 | function Finder.Get(query, root)
  11 |     root = root or PlayerGui
  12 |     
  13 |     -- 1. Direct Reference by Attribute (O(1))
  14 |     if type(query) == "string" then
  15 |         -- Cek apakah Root punya atribut reference ke instance
  16 |         local attrRef = root:GetAttribute(query)
  17 |         if attrRef and typeof(attrRef) == "Instance" then
  18 |             return attrRef
  19 |         end
  20 |     end
  21 |     
  22 |     -- 2. CollectionService Tag (O(1) Lookup, O(n) filtering)
  23 |     -- Query bisa berupa string TagName
  24 |     local tagged = CollectionService:GetTagged(query)
  25 |     for _, obj in ipairs(tagged) do
  26 |         if obj:IsDescendantOf(root) then return obj end
  27 |     end
  28 | 
  29 |     -- 3. Standard Name Search (Fast Child)
  30 |     local child = root:FindFirstChild(query, true) -- Recursive built-in
  31 |     if child then return child end
  32 |     
  33 |     return nil
  34 | end
  35 | 
  36 | -- Digunakan untuk resolve list component dari Config.UI.Components
  37 | function Finder.ResolveMap(screenName, componentMap)
  38 |     local root = PlayerGui:FindFirstChild(screenName)
  39 |     if not root then return nil, "ScreenGui " .. screenName .. " not found" end
  40 |     
  41 |     local results = { _Root = root }
  42 |     local missing = {}
  43 |     
  44 |     for key, spec in pairs(componentMap) do
  45 |         -- Support simple string name OR spec table { Name="xyz", Tag="abc" }
  46 |         local searchKey = (type(spec) == "table") and (spec.Tag or spec.Name) or spec
  47 |         local found = Finder.Get(searchKey, root)
  48 |         
  49 |         if found then
  50 |             results[key] = found
  51 |         else
  52 |             table.insert(missing, key .. " (" .. tostring(searchKey) .. ")")
  53 |         end
  54 |     end
  55 |     
  56 |     if #missing > 0 then
  57 |         return nil, "Missing Components: " .. table.concat(missing, ", ")
  58 |     end
  59 |     
  60 |     return results
  61 | end
  62 | 
  63 | return Finder
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua</strong> (65 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua`

```lua
   1 | --[[ @Component: Kernel (Headless Client) ]]
   2 | local RS = game:GetService('ReplicatedStorage')
   3 | local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")
   4 | 
   5 | local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
   6 | local Config = require(RS.OVHL.Core.SharedConfigLoader)
   7 | local Bridge = require(PS.OVHL.Core.NetworkBridge)
   8 | local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)
   9 | local Context = require(RS.OVHL.Core.Context)
  10 | local FinderService = require(PS.OVHL.Core.FinderService)
  11 | 
  12 | local Kernel = {}
  13 | 
  14 | function Kernel.Boot()
  15 |     local log = LoggerFactory.System()
  16 |     log:Info("🚀 CLIENT STARTUP (HEADLESS MODE - NO UI)")
  17 |     
  18 |     local systems = {
  19 |         LoggerFactory = LoggerFactory,
  20 |         ConfigLoader = Config,
  21 |         Network = Bridge.New(),
  22 |         Finder = FinderService
  23 |         -- UI & Topbar REMOVED
  24 |     }
  25 |     
  26 |     local ctx = Context.New(systems)
  27 |     local modules = {}
  28 |     
  29 |     -- Scanner
  30 |     local function Scan(dir)
  31 |         if not dir then return end
  32 |         for _, f in ipairs(dir:GetChildren()) do
  33 |             if f:IsA("Folder") then
  34 |                 local script = f:FindFirstChild("Controller")
  35 |                 if script then
  36 |                     local mod = require(script)
  37 |                     mod.Name = f.Name
  38 |                     mod._config = Config.Load(f.Name)
  39 |                     local domain = DomainResolver.Resolve(f.Name)
  40 |                     mod.Logger = LoggerFactory.Create(domain)
  41 |                     
  42 |                     modules[f.Name] = mod
  43 |                     log:Debug("Indexed", {Name=f.Name})
  44 |                 end
  45 |             end
  46 |         end
  47 |     end
  48 |     
  49 |     Scan(PS.OVHL.Modules)
  50 |     Scan(PS.OVHL.Controllers)
  51 | 
  52 |     log:Info("Phase 1: Init Modules")
  53 |     for _, m in pairs(modules) do
  54 |         if m.Init then pcall(function() m:Init(ctx) end) end
  55 |     end
  56 |     
  57 |     log:Info("Phase 2: Start Modules")
  58 |     for _, m in pairs(modules) do
  59 |         if m.Start then task.spawn(function() m:Start() end) end
  60 |     end
  61 |     
  62 |     log:Info("✅ CLIENT READY")
  63 | end
  64 | 
  65 | return Kernel
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Core/NetworkBridge.lua</strong> (42 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/NetworkBridge.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local Paths = require(RS.OVHL.Core.Paths)
   3 | local Promise = require(Paths.Packages.Promise)
   4 | 
   5 | local Bridge = {}
   6 | Bridge.__index = Bridge
   7 | 
   8 | function Bridge.New() 
   9 |     return setmetatable({_f = RS:WaitForChild("OVHL_Remotes")}, Bridge) 
  10 | end
  11 | 
  12 | function Bridge:Get(srvName)
  13 |     return setmetatable({}, {
  14 |         __index = function(_, key)
  15 |             return function(this, ...)
  16 |                 local args = {...}
  17 |                 local remName = srvName .. "_" .. key
  18 |                 
  19 |                 return Promise.new(function(resolve, reject)
  20 |                     local remote = self._f:WaitForChild(remName, 5)
  21 |                     if not remote then return reject("Timeout") end
  22 |                     
  23 |                     task.spawn(function()
  24 |                         local s, r = pcall(function() return remote:InvokeServer(table.unpack(args)) end)
  25 |                         if s then
  26 |                             if type(r) == "table" and r.Success ~= nil then
  27 |                                 if r.Success then resolve(r.Data) else reject(r.Error) end
  28 |                             else resolve(r) end
  29 |                         else reject(r) end
  30 |                     end)
  31 |                 end):timeout(5)
  32 |             end
  33 |         end
  34 |     })
  35 | end
  36 | 
  37 | function Bridge:Listen(srvName, eventName, callback)
  38 |     local r = self._f:WaitForChild(srvName .. "/" .. eventName, 5)
  39 |     if r then return r.OnClientEvent:Connect(callback) end
  40 | end
  41 | 
  42 | return Bridge
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/Controller.lua</strong> (21 lines, 485B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/Controller.lua`

```lua
   1 | local Ctrl = {}
   2 | 
   3 | function Ctrl:Init(ctx)
   4 |     self.Api = ctx.Network:Get("Inventory")
   5 |     self.Logger = ctx.LoggerFactory.Create("INVENTORY")
   6 | end
   7 | 
   8 | function Ctrl:Start()
   9 |     self.Logger:Info("Start", "Inventory Logic Active (Headless)")
  10 |     self:FetchItems()
  11 | end
  12 | 
  13 | function Ctrl:FetchItems()
  14 |     self.Api:GetItems():andThen(function(res)
  15 |         if res.Success then
  16 |             self.Logger:Info("DataReceived", {Count=#res.Data, Sample=res.Data[1]})
  17 |         end
  18 |     end)
  19 | end
  20 | 
  21 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypePetInventory/Controller.lua</strong> (61 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypePetInventory/Controller.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | local UI = require(RS.OVHL.UI.Foundation.API)
   3 | local Topbar = require(RS.OVHL.UI.Foundation.Bridges.Topbar)
   4 | 
   5 | local Ctrl = {}
   6 | 
   7 | function Ctrl:Init(ctx)
   8 |     self.Logger = ctx.LoggerFactory.Create("PET_INV")
   9 |     self.UI = UI
  10 |     
  11 |     -- Debugging
  12 |     self.Logger:Info("Pet Inventory Controller Initialized")
  13 | 
  14 |     -- Register Topbar
  15 |     Topbar.Register("Pets", self._config.Topbar, function()
  16 |         self:Toggle()
  17 |     end)
  18 | end
  19 | 
  20 | function Ctrl:Start()
  21 |     local scope = self.UI.NewScope()
  22 |     self.Scope = scope
  23 |     
  24 |     -- Mock Data
  25 |     local mockPets = {
  26 |         { Id = 1, Name = "Doge", Icon = "🐶", RarityColor = self._config.UI.Colors.Rarity.Common },
  27 |         { Id = 2, Name = "Cat",  Icon = "🐱", RarityColor = self._config.UI.Colors.Rarity.Common },
  28 |         { Id = 3, Name = "Fox",  Icon = "🦊", RarityColor = self._config.UI.Colors.Rarity.Rare },
  29 |         { Id = 4, Name = "Dragon", Icon = "🐲", RarityColor = self._config.UI.Colors.Rarity.Legendary },
  30 |         { Id = 5, Name = "Alien", Icon = "👽", RarityColor = self._config.UI.Colors.Rarity.Mythic },
  31 |         { Id = 6, Name = "Robot", Icon = "🤖", RarityColor = self._config.UI.Colors.Rarity.Epic },
  32 |         { Id = 7, Name = "Ghost", Icon = "👻", RarityColor = self._config.UI.Colors.Rarity.Uncommon },
  33 |         { Id = 8, Name = "Unicorn", Icon = "🦄", RarityColor = self._config.UI.Colors.Rarity.Legendary },
  34 |     }
  35 |     
  36 |     self.State = {
  37 |         Visible = scope:Value(false),
  38 |         Inventory = scope:Value(mockPets),
  39 |         SelectedPet = scope:Value(mockPets[4])
  40 |     }
  41 | 
  42 |     local View = require(RS.OVHL.UI.Views.PrototypePetInventory.Window)
  43 |     
  44 |     self.UI.Mount(scope, View, {
  45 |         Config = self._config,
  46 |         State = self.State,
  47 |         Visible = self.State.Visible,
  48 |         
  49 |         OnClose = function() self:Toggle() end,
  50 |         OnEquip = function() print("Equip logic here") end,
  51 |         OnDelete = function() print("Delete logic here") end,
  52 |         OnMerge = function() print("Merge logic here") end
  53 |     })
  54 | end
  55 | 
  56 | function Ctrl:Toggle()
  57 |     local current = self.UI.Unwrap(self.State.Visible)
  58 |     self.State.Visible:set(not current)
  59 | end
  60 | 
  61 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Controller.lua</strong> (18 lines, 390B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Controller.lua`

```lua
   1 | local Ctrl = {}
   2 | 
   3 | function Ctrl:Init(ctx)
   4 |     self.Api = ctx.Network:Get("PrototypeShop")
   5 |     self.Logger = ctx.LoggerFactory.Create("SHOP")
   6 | end
   7 | 
   8 | function Ctrl:Start()
   9 |     self.Logger:Info("Start", "Shop Logic Active (Headless)")
  10 | end
  11 | 
  12 | function Ctrl:Purchase(itemId)
  13 |     self.Api:BuyItem(itemId):andThen(function(res)
  14 |         self.Logger:Info("PurchaseResult", res)
  15 |     end)
  16 | end
  17 | 
  18 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/ShowcaseSystem/Controller.lua</strong> (54 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/ShowcaseSystem/Controller.lua`

```lua
   1 | local RS = game:GetService("ReplicatedStorage")
   2 | -- Absolute Paths
   3 | local UI_API = require(RS.OVHL.UI.Foundation.API)
   4 | local Topbar = require(RS.OVHL.UI.Foundation.Bridges.Topbar)
   5 | 
   6 | local Ctrl = {}
   7 | 
   8 | function Ctrl:Init(ctx)
   9 |     self.Logger = ctx.LoggerFactory.Create("SHOWCASE")
  10 |     self.UI = UI_API
  11 |     
  12 |     -- Logic Injection for Topbar
  13 |     Topbar.Register("Showcase", self._config.Topbar, function()
  14 |         self:Toggle()
  15 |     end)
  16 | end
  17 | 
  18 | function Ctrl:Start()
  19 |     -- 1. State Initialization
  20 |     local scope = self.UI.NewScope()
  21 |     self.Scope = scope
  22 |     self.State = {
  23 |         Visible = scope:Value(false)
  24 |     }
  25 | 
  26 |     -- 2. Component Loading (Safe)
  27 |     local View = require(RS.OVHL.UI.Views.ShowcaseSystem.Window)
  28 |     
  29 |     -- 3. Mounting
  30 |     self.UI.Mount(scope, View, {
  31 |         Config = self._config,
  32 |         Visible = self.State.Visible,
  33 |         
  34 |         -- Interaction Handlers
  35 |         OnAction = function()
  36 |             self.Logger:Info("Diagnostic Running...")
  37 |             task.wait(0.5)
  38 |             self.Logger:Info("System Green.")
  39 |         end,
  40 |         
  41 |         OnClose = function()
  42 |             self:Toggle()
  43 |         end
  44 |     })
  45 |     
  46 |     self.Logger:Info("Showcase UI Mounted Successfully")
  47 | end
  48 | 
  49 | function Ctrl:Toggle()
  50 |     local current = self.UI.Unwrap(self.State.Visible)
  51 |     self.State.Visible:set(not current)
  52 | end
  53 | 
  54 | return Ctrl
```

</details>



### 📦 tests/




---

## 🎯 AI Quick Reference

### Common Analysis Tasks:

1. **🐛 Debug Error**
   - Locate the error message in the relevant file (use line numbers!)
   - Check surrounding context and dependencies  
   - Suggest fixes with specific line numbers

2. **📝 Code Review**
   - Check for best practices and patterns
   - Identify potential bugs or improvements
   - Suggest refactoring opportunities

3. **🗂️ Architecture Analysis**
   - Review module organization  
   - Check separation of concerns (client/server/shared)
   - Validate dependency graphs and race conditions

4. **📚 Documentation**
   - Identify undocumented functions
   - Suggest comments for complex logic
   - Generate API documentation

### File Organization:
- **src/StarterPlayer/StarterPlayerScripts/OVHL/**: Client-side code (runs on player's game client)
- **src/ServerScriptService/OVHL/**: Server-side code (runs on game server)  
- **src/ReplicatedStorage/OVHL/**: Shared code (accessible by both client and server)
- **tests/**: Test files for automated testing

---

*Generated by OVHL Framework ULTIMATE Snapshot Tool*
