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

**Generated:** 2025-11-22 18:54:10  
**Target Directories:** `src`  
**Git Info:** Branch: HEAD
unknown | Commit: unknown | Modified files: 7  
**Structure:** 31 folders | 38 files (38 Lua/Luau, 0 other)
**File Distribution:** Server: 9 (13K, 461 lines) | Client: 4 (6K, 207 lines) | Shared: 25 (35K, 1K lines)
**Total Size:** 54K

---

## 📁 Project Structure

```
📦 src/
  ├── 📁 ReplicatedStorage/
    ├── 📁 OVHL/
      ├── 🌙 Bootstrap.luau
      ├── 📁 Config/
        ├── 🌙 LoggerConfig.luau
      ├── 📁 Core/
        ├── 🌙 ConfigSchema.luau
        ├── 🌙 Context.luau
        ├── 🌙 Env.luau
        ├── 🌙 FrameworkTypes.luau
        ├── 🌙 Loader.luau
        ├── 🌙 Manifest.luau
        ├── 📁 Networking/
          ├── 🌙 Bridge.luau
          ├── 🌙 Middleware.luau
          ├── 🌙 NetworkEnums.luau
        ├── 🌙 SharedConfigLoader.luau
        ├── 🌙 Signals.luau
        ├── 🌙 SmartLogger.luau
      ├── 📁 Modules/
        ├── 📁 Inventory/
          ├── 🌙 SharedConfig.luau
      ├── 📁 Types/
      ├── 📁 UI/
        ├── 📁 Foundation/
          ├── 🌙 API.luau
          ├── 📁 Bridges/
            ├── 🌙 Topbar.lua
          ├── 📁 Components/
            ├── 🌙 ScreenWrapper.luau
            ├── 🌙 SmartButton.luau
            ├── 🌙 Window.luau
          ├── 🌙 OVHLTheme.luau
          ├── 🌙 SafeLoader.luau
          ├── 🌙 Theme.luau
          ├── 🌙 Util.luau
        ├── 📁 Views/
          ├── 📁 Inventory/
            ├── 🌙 InventoryView.luau
  ├── 📁 ServerScriptService/
    ├── 📁 OVHL/
      ├── 📁 Config/
        ├── 🌙 PermissionConfig.luau
      ├── 📁 Core/
        ├── 📁 Permissions/
          ├── 📁 Adapters/
            ├── 🌙 HDAdmin.luau
            ├── 🌙 InternalDB.luau
        ├── 🌙 ServerKernel.luau
      ├── 📁 Modules/
        ├── 📁 Inventory/
          ├── 🌙 InventoryService.luau
      ├── 🌙 ServerRuntime.server.luau
      ├── 📁 Services/
        ├── 🌙 DataManager.luau
        ├── 🌙 MonetizationService.luau
        ├── 🌙 PermissionService.luau
  ├── 📁 StarterPlayer/
    ├── 📁 StarterPlayerScripts/
      ├── 📁 OVHL/
        ├── 🌙 ClientRuntime.client.luau
        ├── 📁 Controllers/
          ├── 🌙 PermissionController.luau
        ├── 📁 Core/
          ├── 🌙 ClientKernel.luau
        ├── 📁 Modules/
          ├── 📁 Inventory/
            ├── 🌙 InventoryController.luau
```

## 📂 Directory Overview

### 📦 src

- 📁 **ReplicatedStorage/OVHL**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Config**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Core**: 9 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Core/Networking**: 3 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation**: 5 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation/Bridges**: 1 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Foundation/Components**: 3 Lua/Luau file(s)
- 📁 **ReplicatedStorage/OVHL/UI/Views/Inventory**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Config**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Core**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Core/Permissions/Adapters**: 2 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)
- 📁 **ServerScriptService/OVHL/Services**: 3 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Controllers**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Core**: 1 Lua/Luau file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory**: 1 Lua/Luau file(s)

---

## 📦 External Package Analysis (Auto-Detected)

**Packages Location:** `Packages`

| Package Name | Type | Status | References | Contexts |
|--------------|------|--------|------------|----------|
| **Fusion** | File Ref | ✅ Active | 25 | Client Shared  |
| **onyx-ui** | File Ref | ✅ Active | 2 | Shared  |
| **Option** | File Ref | ✅ Active | 2 | Server Shared  |
| **profileservice** | File Ref | ✅ Active | 1 | Shared  |
| **Promise** | File Ref | ✅ Active | 2 | Shared  |
| **Signal** | File Ref | ✅ Active | 13 | Client Shared  |
| **topbarplus** | File Ref | ✅ Active | 1 | Shared  |
| **Trove** | File Ref | ✅ Active | 4 | Client  |

## 🔗 Internal Dependency Graph

*No Manifest files found used for internal dependency mapping.*

### 🏁 Race Condition Analysis
✅ No obvious race conditions detected

### 🛡️ Security Analysis
✅ No obvious security issues detected

### 📈 Summary Statistics
#### 📊 Top 10 Largest Files
- `src/ReplicatedStorage/OVHL/UI/Views/Inventory/InventoryView.luau` (152 lines)
- `src/ServerScriptService/OVHL/Services/DataManager.luau` (99 lines)
- `src/ServerScriptService/OVHL/Core/ServerKernel.luau` (97 lines)
- `src/ReplicatedStorage/OVHL/Core/SmartLogger.luau` (95 lines)
- `src/ReplicatedStorage/OVHL/Core/Networking/Bridge.luau` (95 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/ClientKernel.luau` (87 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/InventoryController.luau` (81 lines)
- `src/ReplicatedStorage/OVHL/UI/Foundation/Bridges/Topbar.lua` (80 lines)
- `src/ServerScriptService/OVHL/Services/PermissionService.luau` (76 lines)
- `src/ReplicatedStorage/OVHL/UI/Foundation/API.luau` (70 lines)

#### 📏 File Size Distribution
- **0-100 lines:** 37 files
- **101-500 lines:** 1 files
- **501-1000 lines:** 0 files
- **1001+ lines:** 0 files

## 🗺️ Advanced Path Management Analysis

### 📍 Path Resolution Patterns

### 🔍 Path Consistency Report
- **Hardcoded Paths Found:** 0
- **Absolute Paths Found:** 2
- **Path Resolver:** ❌ Missing
- **Path Aliasing:** ❌ Missing

### 💡 Path Management Recommendations
❌ **Critical Issues Found:**
- Implement centralized PathResolver service
- Replace hardcoded paths with alias system (@core, @ui, etc.)
- Use dependency injection for path resolution

## 📜 API Contract Analysis

### 🔗 Module Contracts
- **Inventory:** ❌ No contract defined

### 🌐 API Endpoint Analysis
- **Networking API Endpoints:**
- **Inventory API Endpoints:**

### 📊 Contract Coverage
- **Modules with Contracts:** 0
- **Modules without Contracts:** 1
❌ **Contract coverage needs improvement**

## 🎨 UI System Analysis

### 🔍 UI Framework Detection
- **Fusion UI:** ✅ Detected
- **Onyx UI:** ❌ Not detected

### 📊 UI System Metrics
- **UI-Related Files:** 6
- **UI Components:** 10

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
- **Service Count:** 3 services
- **Module Count:** 3 modules
- **Configuration Files:** 5 configs

### 🎯 Architecture Quality Assessment
- **Overall Health Score:** 75/100
✅ **Enterprise Grade Architecture**
- Strong separation of concerns
- Proper dependency management
- Scalable service architecture

## 📚 Complete Codebase

### 📦 src/

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Bootstrap.luau</strong> (16 lines, 466B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Bootstrap.luau`

```lua
   1 | -- @Core: Bootstrap
   2 | local RunService = game:GetService("RunService")
   3 | local Bootstrap = {}
   4 | 
   5 | function Bootstrap.StartServer()
   6 |     if not RunService:IsServer() then return end
   7 |     require(game.ServerScriptService.OVHL.Core.ServerKernel).Boot()
   8 | end
   9 | 
  10 | function Bootstrap.StartClient()
  11 |     if not RunService:IsClient() then return end
  12 |     local PS = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
  13 |     require(PS.OVHL.Core.ClientKernel).Boot()
  14 | end
  15 | 
  16 | return Bootstrap
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Config/LoggerConfig.luau</strong> (32 lines, 950B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Config/LoggerConfig.luau`

```lua
   1 | return {
   2 |     DefaultLevel = "DEBUG", -- [FIX] Ganti dari INFO ke DEBUG agar semua narasi muncul
   3 |     UseEmoji = true,
   4 |     UseColor = true,
   5 |     ShowTimestamp = true,
   6 | 
   7 |     Domains = {
   8 |         SYSTEM      = "⚙️ SYSTEM",
   9 |         NETWORK     = "🌐 NETWORK", 
  10 |         SECURITY    = "🔐 SECURITY",
  11 |         DATA        = "💾 DATA",
  12 |         INVENTORY   = "🎒 INVENTORY",
  13 |         SHOP        = "🏪 SHOP", 
  14 |         ADMIN       = "👑 ADMIN",
  15 |         PERMISSION  = "🔐 PERMISSION",
  16 |         
  17 |         -- UI Domains (Telemetry)
  18 |         UX             = "👆 UX",
  19 |         USER_INTERFACE = "🎨 UI",
  20 |         TOPBAR         = "🔘 TOPBAR",
  21 |         
  22 |         DEFAULT     = "📦 GENERAL"
  23 |     },
  24 | 
  25 |     Levels = {
  26 |         DEBUG    = { Weight=1, Icon="🔍" },
  27 |         INFO     = { Weight=2, Icon="ℹ️" },
  28 |         WARN     = { Weight=3, Icon="⚠️" },
  29 |         ERROR    = { Weight=4, Icon="❌" },
  30 |         CRITICAL = { Weight=5, Icon="💀" }
  31 |     }
  32 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/ConfigSchema.luau</strong> (41 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/ConfigSchema.luau`

```lua
   1 | -- @Core: ConfigSchema
   2 | -- Validasi struktur config agar tidak crash di runtime
   3 | local ConfigSchema = {}
   4 | 
   5 | local REQUIRED = {
   6 |     Meta = { Name="string", Type="string", Version="string" }
   7 | }
   8 | 
   9 | local function validate(data, schema, path)
  10 |     local errors = {}
  11 |     for field, expected in pairs(schema) do
  12 |         local val = data[field]
  13 |         local ctx = path .. "." .. field
  14 |         
  15 |         if val == nil then
  16 |             table.insert(errors, "Missing: " .. ctx)
  17 |         elseif type(expected) == "table" then
  18 |             if type(val) ~= "table" then
  19 |                 table.insert(errors, ctx .. " must be table")
  20 |             else
  21 |                 for _, e in ipairs(validate(val, expected, ctx)) do 
  22 |                     table.insert(errors, e) 
  23 |                 end
  24 |             end
  25 |         elseif type(val) ~= expected then
  26 |             table.insert(errors, ctx .. " must be " .. expected)
  27 |         end
  28 |     end
  29 |     return errors
  30 | end
  31 | 
  32 | function ConfigSchema.Validate(cfg, name)
  33 |     local errs = validate(cfg, REQUIRED, name)
  34 |     if #errs > 0 then
  35 |         warn("[CONFIG ERROR] " .. name .. ":\n" .. table.concat(errs, "\n"))
  36 |         return false
  37 |     end
  38 |     return true
  39 | end
  40 | 
  41 | return ConfigSchema
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Context.luau</strong> (31 lines, 806B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Context.luau`

```lua
   1 | -- @Core: Context (DI Container)
   2 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   3 | local SmartLogger = Loader.Core("SmartLogger")
   4 | local Signals = Loader.Core("Signals")
   5 | local Manifest = Loader.Core("Manifest") -- [NEW] Import Manifest
   6 | 
   7 | local Context = {}
   8 | Context.__index = Context
   9 | 
  10 | function Context.New(services)
  11 |     local self = setmetatable({}, Context)
  12 |     
  13 |     -- 1. Inject Core Systems
  14 |     self.Manifest = Manifest -- [NEW] Exposed to Services
  15 |     self.Signals = Signals
  16 |     self.Services = services or {}
  17 |     
  18 |     -- 2. Logger Factory Helper
  19 |     function self:CreateLogger(domain)
  20 |         return SmartLogger.New(domain)
  21 |     end
  22 |     
  23 |     -- 3. Inject Dependencies
  24 |     for name, service in pairs(self.Services) do
  25 |         self[name] = service
  26 |     end
  27 | 
  28 |     return self
  29 | end
  30 | 
  31 | return Context
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Env.luau</strong> (22 lines, 351B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Env.luau`

```lua
   1 | -- @Core: Env
   2 | local RunService = game:GetService("RunService")
   3 | 
   4 | local Env = {}
   5 | 
   6 | function Env.IsStudio()
   7 |     return RunService:IsStudio()
   8 | end
   9 | 
  10 | function Env.IsServer()
  11 |     return RunService:IsServer()
  12 | end
  13 | 
  14 | function Env.IsClient()
  15 |     return RunService:IsClient()
  16 | end
  17 | 
  18 | function Env.MockDataStore()
  19 |     return Env.IsStudio()
  20 | end
  21 | 
  22 | return table.freeze(Env)
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/FrameworkTypes.luau</strong> (32 lines, 919B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/FrameworkTypes.luau`

```lua
   1 | -- @Core: FrameworkTypes
   2 | -- Definisi Kontrak untuk Type Checking Luau
   3 | local FrameworkTypes = {}
   4 | 
   5 | export type Logger = {
   6 |     Info: (self: Logger, msg: string, data: any?) -> (),
   7 |     Warn: (self: Logger, msg: string, data: any?) -> (),
   8 |     Error: (self: Logger, msg: string, data: any?) -> (),
   9 |     Debug: (self: Logger, msg: string, data: any?) -> (),
  10 | }
  11 | 
  12 | export type Manifest = {
  13 |     Identity: { Name: string, Namespace: string },
  14 |     Version: { Major: number, Minor: number, Patch: number, Full: string },
  15 |     Metadata: { BuildType: string }
  16 | }
  17 | 
  18 | export type Context = {
  19 |     Manifest: Manifest,
  20 |     Services: { [string]: any },
  21 |     CreateLogger: (self: Context, domain: string) -> Logger,
  22 |     [string]: any -- Allow dynamic injection
  23 | }
  24 | 
  25 | export type Service = {
  26 |     Init: (self: Service, ctx: Context) -> ()?,
  27 |     Start: (self: Service) -> ()?,
  28 |     Shutdown: (self: Service) -> ()?,
  29 |     [any]: any
  30 | }
  31 | 
  32 | return FrameworkTypes
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Loader.luau</strong> (54 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Loader.luau`

```lua
   1 | -- @Core: Loader v0.3.1 (Case Insensitive Package Fix)
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | 
   4 | local Loader = {}
   5 | 
   6 | local ROOT_RS = ReplicatedStorage:WaitForChild("OVHL")
   7 | local ROOT_PACKAGES = ReplicatedStorage:WaitForChild("Packages")
   8 | 
   9 | local function requireByPath(root, pathStr, contextName)
  10 |     local current = root
  11 |     local segments = string.split(pathStr, "/")
  12 |     
  13 |     for i, name in ipairs(segments) do
  14 |         local found = current:FindFirstChild(name)
  15 |         
  16 |         -- [FIX] Smart Search for Packages (Handle wally naming & casing)
  17 |         if not found and contextName == "Packages" then
  18 |             local lowerName = name:lower()
  19 |             for _, child in ipairs(current:GetChildren()) do
  20 |                 -- Matches "profileservice" or "author_profileservice@..."
  21 |                 local childName = child.Name:lower()
  22 |                 if childName == lowerName or childName:find("_" .. lowerName .. "@") then
  23 |                     found = child
  24 |                     break
  25 |                 end
  26 |             end
  27 |         end
  28 | 
  29 |         if not found then
  30 |             local available = {}
  31 |             for _, c in ipairs(current:GetChildren()) do table.insert(available, c.Name) end
  32 |             error(string.format(
  33 |                 "[Loader] Path Error in %s: '%s' not found inside '%s'.\nAvailable: %s", 
  34 |                 contextName, name, current.Name, table.concat(available, ", ")
  35 |             ))
  36 |         end
  37 |         current = found
  38 |     end
  39 |     
  40 |     return require(current)
  41 | end
  42 | 
  43 | function Loader.Core(path) return requireByPath(ROOT_RS.Core, path, "Core") end
  44 | function Loader.Config(path) return requireByPath(ROOT_RS.Config, path, "Config") end
  45 | function Loader.Pkg(name) return requireByPath(ROOT_PACKAGES, name, "Packages") end
  46 | function Loader.UI(path) return requireByPath(ROOT_RS.UI, path, "UI") end
  47 | 
  48 | function Loader.Module(featureName, scriptName)
  49 |     local feature = ROOT_RS.Modules:FindFirstChild(featureName)
  50 |     if not feature then error("[Loader] Feature folder '" .. featureName .. "' does not exist.") end
  51 |     return requireByPath(feature, scriptName, "Module:"..featureName)
  52 | end
  53 | 
  54 | return table.freeze(Loader)
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Manifest.luau</strong> (20 lines, 413B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Manifest.luau`

```lua
   1 | -- @Core: Manifest (Single Source of Truth)
   2 | -- Identitas & Versi Framework
   3 | return {
   4 |     Identity = {
   5 |         Name = "OVHL Framework",
   6 |         Namespace = "omniverse"
   7 |     },
   8 |     
   9 |     Version = {
  10 |         Major = 0,
  11 |         Minor = 1,
  12 |         Patch = 0,
  13 |         Full = "0.1.0"
  14 |     },
  15 |     
  16 |     Metadata = {
  17 |         BuildType = "Alpha", -- Development / Staging / Production
  18 |         LastUpdated = "2025-11-22"
  19 |     }
  20 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Networking/Bridge.luau</strong> (95 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Networking/Bridge.luau`

```lua
   1 | -- @Core: Bridge (Unified Networking)
   2 | local RunService = game:GetService("RunService")
   3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   4 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   5 | 
   6 | local Enums = Loader.Core("Networking/NetworkEnums")
   7 | local Promise = Loader.Pkg("Promise")
   8 | 
   9 | local Bridge = {}
  10 | Bridge.__index = Bridge
  11 | 
  12 | local IS_SERVER = RunService:IsServer()
  13 | local REMOTES_FOLDER_NAME = "OVHL_Remotes"
  14 | 
  15 | local function getRemotesFolder()
  16 |     if IS_SERVER then
  17 |         local f = ReplicatedStorage:FindFirstChild(REMOTES_FOLDER_NAME)
  18 |         if not f then
  19 |             f = Instance.new("Folder")
  20 |             f.Name = REMOTES_FOLDER_NAME
  21 |             f.Parent = ReplicatedStorage
  22 |         end
  23 |         return f
  24 |     else
  25 |         return ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME)
  26 |     end
  27 | end
  28 | 
  29 | function Bridge.New()
  30 |     local self = setmetatable({}, Bridge)
  31 |     self._folder = getRemotesFolder()
  32 |     return self
  33 | end
  34 | 
  35 | -- [[ SERVER API ]]
  36 | function Bridge:Register(name, middlewareList)
  37 |     if not IS_SERVER then error("Register is Server-Only") end
  38 |     
  39 |     local rf = self._folder:FindFirstChild(name) or Instance.new("RemoteFunction", self._folder)
  40 |     rf.Name = name
  41 |     
  42 |     local re = self._folder:FindFirstChild(name .. "_Event") or Instance.new("RemoteEvent", self._folder)
  43 |     re.Name = name .. "_Event"
  44 |     
  45 |     return {
  46 |         OnInvoke = function(callback)
  47 |             rf.OnServerInvoke = function(player, ...)
  48 |                 if middlewareList then
  49 |                     for _, mw in ipairs(middlewareList) do
  50 |                         local ok, err, code = mw(player, {...})
  51 |                         if not ok then
  52 |                             return { Success = false, Error = err, Code = code or Enums.Status.UNAUTHORIZED }
  53 |                         end
  54 |                     end
  55 |                 end
  56 |                 
  57 |                 local success, result = pcall(callback, player, ...)
  58 |                 if success then
  59 |                     return { Success = true, Data = result, Code = Enums.Status.OK }
  60 |                 else
  61 |                     warn("[Bridge Error]", result)
  62 |                     return { Success = false, Error = "Internal Server Error", Code = Enums.Status.INTERNAL_ERROR }
  63 |                 end
  64 |             end
  65 |         end,
  66 |         
  67 |         FireClient = function(_, player, data) re:FireClient(player, data) end,
  68 |         FireAll = function(_, data) re:FireAllClients(data) end
  69 |     }
  70 | end
  71 | 
  72 | -- [[ CLIENT API ]]
  73 | function Bridge:Request(name, ...)
  74 |     if IS_SERVER then error("Request is Client-Only") end
  75 |     local args = {...}
  76 |     return Promise.new(function(resolve, reject)
  77 |         local rf = self._folder:WaitForChild(name, 5)
  78 |         if not rf then return reject("Timeout: Service " .. name .. " not found") end
  79 |         
  80 |         local result = rf:InvokeServer(table.unpack(args))
  81 |         
  82 |         if type(result) == "table" and result.Success ~= nil then
  83 |             if result.Success then resolve(result.Data) else reject(result.Error) end
  84 |         else
  85 |             resolve(result)
  86 |         end
  87 |     end)
  88 | end
  89 | 
  90 | function Bridge:Listen(name, callback)
  91 |     local re = self._folder:WaitForChild(name .. "_Event", 5)
  92 |     if re then re.OnClientEvent:Connect(callback) end
  93 | end
  94 | 
  95 | return Bridge
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Networking/Middleware.luau</strong> (31 lines, 912B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Networking/Middleware.luau`

```lua
   1 | -- @Core: Middleware (Chain of Responsibility)
   2 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   3 | local Enums = Loader.Core("Networking/NetworkEnums")
   4 | 
   5 | local Middleware = {}
   6 | 
   7 | -- Tipe: function(player, requestData) -> (shouldContinue, errorMsg, statusCode)
   8 | 
   9 | function Middleware.RateLimiter(maxRequests, interval)
  10 |     return function(player, _)
  11 |         -- TODO: Implementasi Real Rate Limit di Phase 4
  12 |         return true
  13 |     end
  14 | end
  15 | 
  16 | function Middleware.AdminOnly(rankId)
  17 |     return function(player, _)
  18 |         -- Mockup: Selalu boleh di Studio
  19 |         if game:GetService("RunService"):IsStudio() then return true end
  20 |         return false, "Access Denied", Enums.Status.FORBIDDEN
  21 |     end
  22 | end
  23 | 
  24 | function Middleware.Validator(schema)
  25 |     return function(_, args)
  26 |         if not args then return false, "Missing Arguments", Enums.Status.BAD_REQUEST end
  27 |         return true
  28 |     end
  29 | end
  30 | 
  31 | return Middleware
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Networking/NetworkEnums.luau</strong> (17 lines, 400B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Networking/NetworkEnums.luau`

```lua
   1 | -- @Core: NetworkEnums
   2 | -- Standar Status Code ala HTTP untuk Game Networking
   3 | return table.freeze({
   4 |     Status = {
   5 |         OK = 200,
   6 |         BAD_REQUEST = 400,
   7 |         UNAUTHORIZED = 401,
   8 |         FORBIDDEN = 403,
   9 |         NOT_FOUND = 404,
  10 |         RATE_LIMITED = 429,
  11 |         INTERNAL_ERROR = 500
  12 |     },
  13 |     Events = {
  14 |         SystemHandshake = "SYS_HANDSHAKE",
  15 |         SystemPing = "SYS_PING"
  16 |     }
  17 | })
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/SharedConfigLoader.luau</strong> (38 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/SharedConfigLoader.luau`

```lua
   1 | -- @Core: SharedConfigLoader
   2 | -- Mencari dan memuat SharedConfig dari folder Modules
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   5 | local Schema = Loader.Core("ConfigSchema")
   6 | 
   7 | local ConfigLoader = {}
   8 | 
   9 | function ConfigLoader.Load(moduleName)
  10 |     -- Cari folder module
  11 |     local root = RS.OVHL.Modules
  12 |     local moduleFolder = root:FindFirstChild(moduleName)
  13 |     
  14 |     if not moduleFolder then
  15 |         warn("[Config] Module not found: " .. moduleName)
  16 |         return {}
  17 |     end
  18 |     
  19 |     -- Cari file config
  20 |     local configFile = moduleFolder:FindFirstChild("SharedConfig")
  21 |     if not configFile then
  22 |         return {} -- Config is optional, return empty
  23 |     end
  24 |     
  25 |     -- Require & Validate
  26 |     local success, data = pcall(require, configFile)
  27 |     if not success then
  28 |         warn("[Config] Syntax Error in " .. moduleName .. ": " .. tostring(data))
  29 |         return {}
  30 |     end
  31 |     
  32 |     -- Validasi Schema
  33 |     Schema.Validate(data, moduleName)
  34 |     
  35 |     return data
  36 | end
  37 | 
  38 | return ConfigLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Signals.luau</strong> (26 lines, 553B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Signals.luau`

```lua
   1 | -- @Core: Signals (Event Bus)
   2 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   3 | local Signal = Loader.Pkg("Signal")
   4 | 
   5 | local Signals = {}
   6 | Signals._registry = {}
   7 | 
   8 | function Signals:Get(name)
   9 |     if not self._registry[name] then
  10 |         self._registry[name] = Signal.new()
  11 |     end
  12 |     return self._registry[name]
  13 | end
  14 | 
  15 | function Signals:Fire(name, ...)
  16 |     local sig = self._registry[name]
  17 |     if sig then
  18 |         sig:Fire(...)
  19 |     end
  20 | end
  21 | 
  22 | function Signals:Connect(name, callback)
  23 |     return self:Get(name):Connect(callback)
  24 | end
  25 | 
  26 | return Signals
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/SmartLogger.luau</strong> (95 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/SmartLogger.luau`

```lua
   1 | -- @Core: SmartLogger
   2 | -- @PortedFrom: Snapshot V4.0
   3 | local HttpService = game:GetService("HttpService")
   4 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   5 | 
   6 | local Config = Loader.Config("LoggerConfig")
   7 | local Env = Loader.Core("Env")
   8 | 
   9 | local SmartLogger = {}
  10 | SmartLogger.__index = SmartLogger
  11 | 
  12 | local CONTEXT_TAG = Env.IsServer() and "[SERVER]" or "[CLIENT]"
  13 | 
  14 | function SmartLogger.New(domain, overrides)
  15 |     local self = setmetatable({}, SmartLogger)
  16 |     self._rawDomain = domain or "SYSTEM"
  17 |     
  18 |     local mapped = Config.Domains[self._rawDomain]
  19 |     if mapped then
  20 |         self._domainDisplay = mapped
  21 |     else
  22 |         self._domainDisplay = string.format("📦 %s", self._rawDomain:upper())
  23 |     end
  24 |     
  25 |     local defLvl = Config.DefaultLevel or "INFO"
  26 |     local myLvl = (overrides and overrides.LogLevel) or defLvl
  27 |     self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
  28 |     
  29 |     return self
  30 | end
  31 | 
  32 | function SmartLogger:_safeDump(data, depth)
  33 |     depth = depth or 0
  34 |     if depth > 2 then return "..." end
  35 |     
  36 |     local t = type(data)
  37 |     if t == "table" then
  38 |         local parts = {}
  39 |         for k, v in pairs(data) do
  40 |             if type(k) == "string" then
  41 |                 table.insert(parts, k .. "=" .. self:_safeDump(v, depth + 1))
  42 |             end
  43 |         end
  44 |         return "{" .. table.concat(parts, ", ") .. "}"
  45 |     elseif t == "userdata" then
  46 |         return typeof(data)
  47 |     else
  48 |         return tostring(data)
  49 |     end
  50 | end
  51 | 
  52 | function SmartLogger:_safeFormat(level, message, data)
  53 |     if not message then return nil end
  54 |     
  55 |     local cfg = Config.Levels[level]
  56 |     if not cfg then return nil end
  57 |     
  58 |     local meta = ""
  59 |     if data ~= nil then
  60 |         local success, result = pcall(function()
  61 |             return HttpService:JSONEncode(data)
  62 |         end)
  63 |         if success then
  64 |             meta = " │ " .. result
  65 |         else
  66 |             meta = " │ [RAW] " .. self:_safeDump(data)
  67 |         end
  68 |     end
  69 | 
  70 |     local levelIcon = cfg.Icon or "📝"
  71 |     -- [SAFE] Lune menangani karakter newline (\n) secara native di sini
  72 |     return string.format("%s %s %s\n   └── %s%s", 
  73 |         levelIcon, CONTEXT_TAG, self._domainDisplay, message, meta)
  74 | end
  75 | 
  76 | function SmartLogger:_log(level, message, data)
  77 |     local cfg = Config.Levels[level]
  78 |     if not cfg or cfg.Weight < self._weight then return end
  79 |     
  80 |     local logMessage = self:_safeFormat(level, message, data)
  81 |     if not logMessage then return end
  82 |     
  83 |     if level == "ERROR" or level == "CRITICAL" then
  84 |         warn(logMessage)
  85 |     else
  86 |         print(logMessage)
  87 |     end
  88 | end
  89 | 
  90 | function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
  91 | function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
  92 | function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
  93 | function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end
  94 | 
  95 | return SmartLogger
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Modules/Inventory/SharedConfig.luau</strong> (55 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Modules/Inventory/SharedConfig.luau`

```lua
   1 | -- @Feature: Inventory Config
   2 | -- @Standard: OVHL v0.1.1
   3 | 
   4 | return {
   5 |     Meta = {
   6 |         Name = "Inventory",
   7 |         Type = "Feature",
   8 |         Version = "3.2.0",
   9 |     },
  10 | 
  11 |     Topbar = {
  12 |         Enabled = true,
  13 |         Text = "BAG",
  14 |         Icon = "rbxassetid://96226541857519",
  15 |         Shortcut = Enum.KeyCode.B,
  16 |         Order = 1,
  17 |         Permission = 0,
  18 |     },
  19 | 
  20 |     Layout = {
  21 |         Mode = "Grid", -- Options: "Grid" | "List"
  22 |         
  23 |         Grid = {
  24 |             CellSize = {X = 100, Y = 120},
  25 |             Gap = {X = 10, Y = 10},
  26 |             Sort = Enum.SortOrder.LayoutOrder
  27 |         },
  28 |         
  29 |         List = {
  30 |             Height = 60,
  31 |             Gap = 5,
  32 |             Padding = 8
  33 |         }
  34 |     },
  35 | 
  36 |     UI = {
  37 |         Title = "MY BACKPACK",
  38 |         EmptyState = "No items found.",
  39 |         MaxSlots = 50,
  40 | 
  41 |         RarityColors = {
  42 |             Common = Color3.fromHex("94A3B8"),
  43 |             Uncommon = Color3.fromHex("10B981"),
  44 |             Rare = Color3.fromHex("3B82F6"),
  45 |             Epic = Color3.fromHex("8B5CF6"),
  46 |             Legendary = Color3.fromHex("F59E0B"),
  47 |             Mythic = Color3.fromHex("EF4444"),
  48 |         },
  49 |     },
  50 | 
  51 |     Network = {
  52 |         Route = "Inventory",
  53 |         Requests = {},
  54 |     },
  55 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/API.luau</strong> (70 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/API.luau`

```lua
   1 | -- @UI: API (Foundation Wrapper)
   2 | -- @Responsibility: Expose Fusion, Onyx, and Core Components via a single require.
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | 
   5 | -- [DEPENDENCIES]
   6 | local Fusion = Loader.Pkg("Fusion")
   7 | local Onyx = Loader.Pkg("onyx-ui")
   8 | local OVHLUtil = Loader.UI("Foundation/Util") -- Custom helper (ToFont, etc)
   9 | local OVHLTheme = Loader.UI("Foundation/OVHLTheme")
  10 | local SafeLoader = Loader.UI("Foundation/SafeLoader")
  11 | 
  12 | -- [UTIL MERGE STRATEGY]
  13 | -- Kita gabungkan Onyx.Util (UDim, Vector2, Spring, dll) dengan Custom Util kita.
  14 | local CombinedUtil = {}
  15 | 
  16 | -- 1. Copy Onyx Utils
  17 | for k, v in pairs(Onyx.Util) do
  18 |     CombinedUtil[k] = v
  19 | end
  20 | 
  21 | -- 2. Copy/Override with OVHL Utils
  22 | for k, v in pairs(OVHLUtil) do
  23 |     CombinedUtil[k] = v
  24 | end
  25 | 
  26 | local API = {}
  27 | 
  28 | -- [1] FUSION EXPORTS (Explicit)
  29 | API.New = Fusion.New
  30 | API.Value = Fusion.Value
  31 | API.Computed = Fusion.Computed
  32 | API.ForValues = Fusion.ForValues
  33 | API.ForPairs = Fusion.ForPairs
  34 | API.ForKeys = Fusion.ForKeys
  35 | API.Children = Fusion.Children
  36 | API.OnEvent = Fusion.OnEvent
  37 | API.OnChange = Fusion.OnChange
  38 | API.Out = Fusion.Out
  39 | API.Observer = Fusion.Observer
  40 | API.cleanup = Fusion.doCleanup
  41 | 
  42 | -- [2] LIBRARIES
  43 | API.Fusion = Fusion
  44 | API.Onyx = Onyx
  45 | API.Themer = Onyx.Themer
  46 | API.Util = CombinedUtil -- Gunakan yang sudah di-merge
  47 | API.Theme = OVHLTheme
  48 | API.SafeLoader = SafeLoader
  49 | 
  50 | -- [3] CUSTOM COMPONENTS
  51 | -- We require them here to avoid circular dependency issues during initialization
  52 | local Components = {
  53 |     ScreenWrapper = Loader.UI("Foundation/Components/ScreenWrapper")(API),
  54 |     SmartButton = Loader.UI("Foundation/Components/SmartButton")(API),
  55 |     Window = Loader.UI("Foundation/Components/Window")(API)
  56 | }
  57 | API.Components = Components
  58 | 
  59 | -- [4] SCOPE GENERATOR
  60 | function API.NewScope()
  61 |     -- Merge Onyx and Custom Components into the scope metatable
  62 |     local methods = {}
  63 |     for k, v in pairs(Onyx.Components) do methods[k] = v end
  64 |     for k, v in pairs(Components) do methods[k] = v end
  65 |     
  66 |     -- Pass CombinedUtil here so scope:UDim() works!
  67 |     return Fusion.scoped(Fusion, CombinedUtil, methods)
  68 | end
  69 | 
  70 | return table.freeze(API)
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Bridges/Topbar.lua</strong> (80 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Bridges/Topbar.lua`

```lua
   1 | -- @Bridge: TopbarPlus (With Security Check)
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Players = game:GetService("Players")
   4 | local Loader = require(RS.OVHL.Core.Loader)
   5 | local SmartLogger = Loader.Core("SmartLogger")
   6 | 
   7 | local TopbarPlus = Loader.Pkg("topbarplus")
   8 | local Fusion = Loader.Pkg("Fusion")
   9 | local API = Loader.UI("Foundation/API")
  10 | 
  11 | local TopbarBridge = {}
  12 | local _initialized = false
  13 | local Logger = nil 
  14 | 
  15 | function TopbarBridge.Init()
  16 |     if _initialized then return end
  17 |     _initialized = true
  18 |     Logger = SmartLogger.New("TOPBAR")
  19 |     
  20 |     local Theme = API.Theme
  21 |     local peek = Fusion.peek
  22 |     local C = Theme.Colors
  23 |     
  24 |     TopbarPlus.setDisplayOrder(10000)
  25 |     TopbarPlus.modifyBaseTheme({
  26 |         {"IconBackgroundColor", peek(C.Base.Main)},
  27 |         {"IconBorderColor", peek(C.Neutral.Main)},
  28 |         {"IconImageColor", peek(C.BaseContent.Main)},
  29 |         {"IconLabelColor", peek(C.BaseContent.Main)},
  30 |         {"WidgetBackgroundColor", peek(C.Base.Main)},
  31 |         {"WidgetBorderColor", peek(C.Neutral.Main)},
  32 |         {"IconCornerRadius", UDim.new(0, 8)},
  33 |     })
  34 |     
  35 |     Logger:Info("System", "Bridge Initialized")
  36 | end
  37 | 
  38 | function TopbarBridge.Register(name, config, toggleFunc)
  39 |     TopbarBridge.Init()
  40 |     
  41 |     if not config or not config.Enabled then return nil end
  42 |     
  43 |     -- [SECURITY CHECK] The Gatekeeper
  44 |     if config.Permission then
  45 |         local myRank = Players.LocalPlayer:GetAttribute("OVHL_Rank") or 0
  46 |         if myRank < config.Permission then
  47 |             Logger:Debug("Hidden", { 
  48 |                 Module = name, 
  49 |                 Reason = "Low Rank", 
  50 |                 Req = config.Permission, 
  51 |                 Got = myRank 
  52 |             })
  53 |             return nil -- Jangan bikin icon sama sekali!
  54 |         end
  55 |     end
  56 |     
  57 |     Logger:Info("Register", { Name = name, Perm = config.Permission or 0 })
  58 |     
  59 |     local icon = TopbarPlus.new()
  60 |         :setLabel(config.Text or name)
  61 |         :setImage(config.Icon)
  62 |         :setOrder(config.Order or 10)
  63 |         
  64 |     if config.Caption then icon:setCaption(config.Caption) end
  65 |     if config.Shortcut then icon:bindToggleKey(config.Shortcut) end
  66 |     
  67 |     icon.selected:Connect(function() 
  68 |         Logger:Debug("Interaction", {Action="Open", Module=name})
  69 |         toggleFunc(true) 
  70 |     end)
  71 |     
  72 |     icon.deselected:Connect(function() 
  73 |         Logger:Debug("Interaction", {Action="Close", Module=name})
  74 |         toggleFunc(false) 
  75 |     end)
  76 |     
  77 |     return icon
  78 | end
  79 | 
  80 | return TopbarBridge
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/ScreenWrapper.luau</strong> (51 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/ScreenWrapper.luau`

```lua
   1 | -- @Component: ScreenWrapper (Correctly Centered AutoScaler)
   2 | return function(API)
   3 | 	local Themer = API.Themer
   4 | 	local Theme = API.Theme
   5 | 
   6 | 	return function(scope, props)
   7 | 		local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
   8 | 
   9 | 		return scope:New("ScreenGui")({
  10 | 			Name = props.Name or "OVHL_Screen",
  11 | 			Parent = PlayerGui,
  12 | 			ResetOnSpawn = false,
  13 | 			IgnoreGuiInset = true,
  14 | 			DisplayOrder = props.Order or 10,
  15 | 			Enabled = props.Enabled,
  16 | 
  17 | 			[API.Children] = {
  18 | 				scope:AutoScaler({
  19 | 					Name = "ResponsiveCanvas",
  20 | 					BaseResolution = Vector2.new(1280, 720),
  21 | 					MinScale = 0.5,
  22 | 					MaxScale = 1.5,
  23 | 
  24 | 					-- [CRITICAL FIX]
  25 | 					-- AutoScaler SENDIRI harus di-center ke layar.
  26 | 					-- Jika tidak, saat scale < 1, dia akan lari ke pojok kiri atas.
  27 | 					AnchorPoint = Vector2.new(0.5, 0.5),
  28 | 					Position = UDim2.fromScale(0.5, 0.5),
  29 | 
  30 | 					Size = UDim2.fromScale(1, 1),
  31 | 					BackgroundTransparency = 1,
  32 | 
  33 | 					[API.Children] = {
  34 | 						Themer.Theme:is(Theme):during(function()
  35 | 							return scope:New("Frame")({
  36 | 								Name = "ProviderScope",
  37 | 								-- Child juga center (redundant tapi aman)
  38 | 								AnchorPoint = Vector2.new(0.5, 0.5),
  39 | 								Position = UDim2.fromScale(0.5, 0.5),
  40 | 								Size = UDim2.fromScale(1, 1),
  41 | 								BackgroundTransparency = 1,
  42 | 								Active = false,
  43 | 								[API.Children] = props[API.Children],
  44 | 							})
  45 | 						end),
  46 | 					},
  47 | 				}),
  48 | 			},
  49 | 		})
  50 | 	end
  51 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/SmartButton.luau</strong> (45 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/SmartButton.luau`

```lua
   1 | -- @Component: SmartButton (With Telemetry)
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Loader = require(RS.OVHL.Core.Loader)
   4 | local SmartLogger = Loader.Core("SmartLogger")
   5 | 
   6 | -- Logger khusus interaksi User
   7 | local UXLogger = SmartLogger.New("UX") 
   8 | 
   9 | return function(API)
  10 |     return function(scope, props)
  11 |         -- Map OVHL Style to Onyx Style
  12 |         local style = "Filled"
  13 |         if props.Style == "Outline" then style = "Outlined" end
  14 |         if props.Style == "Ghost" then style = "Ghost" end
  15 |         
  16 |         local color = nil
  17 |         if props.Style == "Danger" then color = API.Util.Colors.Red["500"] end
  18 |         
  19 |         -- Ambil Text untuk Log (Bisa string atau State)
  20 |         local btnText = props.Text or "Unknown"
  21 |         
  22 |         return scope:Button {
  23 |             Content = { props.Text },
  24 |             Style = style,
  25 |             Color = color,
  26 |             Size = props.Size,
  27 |             LayoutOrder = props.LayoutOrder,
  28 |             
  29 |             -- [TELEMETRY] Intercept Activation
  30 |             OnActivate = function()
  31 |                 -- 1. Lapor Dulu!
  32 |                 local txt = (type(btnText) == "string") and btnText or "DynamicState"
  33 |                 UXLogger:Info("Click", { 
  34 |                     Button = txt, 
  35 |                     Style = props.Style,
  36 |                     Context = props.Context or "UI"
  37 |                 })
  38 |                 
  39 |                 -- 2. Jalankan Logic Asli
  40 |                 if props.OnClick then props.OnClick() end
  41 |                 if props.OnActivate then props.OnActivate() end
  42 |             end
  43 |         }
  44 |     end
  45 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Components/Window.luau</strong> (46 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Components/Window.luau`

```lua
   1 | -- @Component: Window (Standard Offset)
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Loader = require(RS.OVHL.Core.Loader)
   4 | local SmartLogger = Loader.Core("SmartLogger")
   5 | 
   6 | local Logger = SmartLogger.New("UI_LAYOUT")
   7 | 
   8 | return function(API)
   9 |     return function(scope, props)
  10 |         local defaultSize = UDim2.fromOffset(500, 400) -- Sedikit diperlebar
  11 |         local targetSize = props.Size or defaultSize
  12 |         
  13 |         Logger:Debug("WindowInit", {
  14 |             Title = props.Title,
  15 |             Size = tostring(targetSize),
  16 |             Note = "Centered in Scaled Canvas"
  17 |         })
  18 |     
  19 |         return scope:Card {
  20 |             Name = "WindowFrame",
  21 |             
  22 |             -- [CRITICAL FIX] Pastikan Window juga Centered di dalam Canvas
  23 |             AnchorPoint = Vector2.new(0.5, 0.5),
  24 |             Position = UDim2.fromScale(0.5, 0.5),
  25 |             Size = targetSize,
  26 |             
  27 |             List = { FillDirection = Enum.FillDirection.Vertical, Padding = scope:UDim(0, 0) },
  28 |             Padding = { All = scope:UDim(0, 0) },
  29 |             
  30 |             [API.Children] = {
  31 |                 scope:TitleBar {
  32 |                     Content = { props.Title or "Window" },
  33 |                     OnClose = props.OnClose,
  34 |                     CloseButtonDisabled = (props.OnClose == nil)
  35 |                 },
  36 |                 scope:Frame {
  37 |                     Name = "Body",
  38 |                     Size = UDim2.new(1, 0, 1, -48),
  39 |                     BackgroundTransparency = 1,
  40 |                     Padding = { All = scope:UDim(0, 16) },
  41 |                     [API.Children] = props[API.Children]
  42 |                 }
  43 |             }
  44 |         }
  45 |     end
  46 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/OVHLTheme.luau</strong> (42 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/OVHLTheme.luau`

```lua
   1 | -- @UI: OVHLTheme (Smart Object)
   2 | -- @Standard: Onyx Native Spec + Pre-processed Assets
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | local Fusion = Loader.Pkg("Fusion")
   5 | local Onyx = Loader.Pkg("onyx-ui")
   6 | local Util = Loader.UI("Foundation/Util")
   7 | 
   8 | local Scope = Fusion.scoped(Fusion)
   9 | 
  10 | -- Zinc & Emerald Palette
  11 | local P = {
  12 |     Zinc900 = Color3.fromHex("18181b"),
  13 |     Zinc800 = Color3.fromHex("27272a"),
  14 |     Zinc700 = Color3.fromHex("3f3f46"),
  15 |     Emerald500 = Color3.fromHex("10b981"),
  16 |     Red500 = Color3.fromHex("ef4444"),
  17 |     White = Color3.fromHex("ffffff")
  18 | }
  19 | 
  20 | -- Create Native Onyx Theme with SMART ASSETS
  21 | local OVHLTheme = Onyx.Themer.NewTheme(Scope, {
  22 |     Colors = {
  23 |         Base = { Main = P.Zinc900 },
  24 |         BaseContent = { Main = P.White },
  25 |         Primary = { Main = P.Emerald500 },
  26 |         Neutral = { Main = P.Zinc800 },
  27 |         Error = { Main = P.Red500 },
  28 |     },
  29 |     CornerRadius = {
  30 |         Base = 8
  31 |     },
  32 |     StrokeThickness = {
  33 |         Base = 1
  34 |     },
  35 |     Font = {
  36 |         -- [SMART] Langsung return Font Object, bukan string!
  37 |         Body = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
  38 |         Heading = Util.ToFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  39 |     }
  40 | })
  41 | 
  42 | return OVHLTheme
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/SafeLoader.luau</strong> (46 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/SafeLoader.luau`

```lua
   1 | -- @Foundation: SafeLoader (With Telemetry)
   2 | local RS = game:GetService("ReplicatedStorage")
   3 | local Loader = require(RS.OVHL.Core.Loader)
   4 | local Fusion = Loader.Pkg("Fusion")
   5 | local SmartLogger = Loader.Core("SmartLogger")
   6 | 
   7 | local SafeLoader = {}
   8 | local Logger = SmartLogger.New("USER_INTERFACE")
   9 | 
  10 | function SafeLoader.Mount(scope, componentFunc, props)
  11 |     local viewName = "UnknownView"
  12 |     if props.Config and props.Config.Meta then
  13 |         viewName = props.Config.Meta.Name .. "View"
  14 |     end
  15 | 
  16 |     local success, result = xpcall(function()
  17 |         return componentFunc(scope, props)
  18 |     end, debug.traceback)
  19 | 
  20 |     if success then
  21 |         Logger:Info("MountSuccess", { -- Pakai Info agar pasti muncul
  22 |             View = viewName,
  23 |             Screen = props.Name or "Screen"
  24 |         })
  25 |         return result
  26 |     else
  27 |         Logger:Error("MountFailed", { View = viewName, Error = result })
  28 |         
  29 |         return scope:New "Frame" {
  30 |             Name = "ErrorBoundary",
  31 |             Size = UDim2.fromScale(1, 1),
  32 |             BackgroundColor3 = Color3.fromRGB(40, 0, 0),
  33 |             ZIndex = 9999,
  34 |             [Fusion.Children] = {
  35 |                 scope:New "TextLabel" {
  36 |                     Text = "UI ERROR: " .. tostring(result),
  37 |                     TextColor3 = Color3.new(1,0.5,0.5),
  38 |                     Size = UDim2.fromScale(1,1),
  39 |                     BackgroundTransparency = 0.5
  40 |                 }
  41 |             }
  42 |         }
  43 |     end
  44 | end
  45 | 
  46 | return SafeLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Theme.luau</strong> (0 lines, 33B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Theme.luau`

```lua
   1 | -- Deprecated. Use OVHLTheme.luau
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Foundation/Util.luau</strong> (37 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Foundation/Util.luau`

```lua
   1 | -- @Foundation: UI Utilities
   2 | -- @Responsibility: Data Conversion & Asset Normalization
   3 | local Util = {}
   4 | 
   5 | -- [[ FONT CONVERTER ]]
   6 | -- Mengubah string config menjadi Font Object yang valid
   7 | function Util.ToFont(fontSource, weight, style)
   8 |     if typeof(fontSource) == "Font" then
   9 |         return fontSource
  10 |     elseif type(fontSource) == "string" then
  11 |         -- Default fallback args
  12 |         local w = weight or Enum.FontWeight.Regular
  13 |         local s = style or Enum.FontStyle.Normal
  14 |         
  15 |         -- Cek apakah ini Enum.Font legacy (jarang dipakai di framework modern) atau Asset ID
  16 |         if fontSource:match("^rbxasset") then
  17 |             return Font.new(fontSource, w, s)
  18 |         else
  19 |             -- Fallback jika string nama font biasa (Gotham, etc) - though Font.new usually takes ID
  20 |             return Font.new("rbxasset://fonts/families/GothamSSm.json", w, s)
  21 |         end
  22 |     end
  23 |     -- Fallback total
  24 |     return Font.new("rbxasset://fonts/families/GothamSSm.json")
  25 | end
  26 | 
  27 | -- [[ ASSET ID CLEANER ]]
  28 | -- Memastikan ID selalu format "rbxassetid://..."
  29 | function Util.CleanAssetId(id)
  30 |     if not id then return "" end
  31 |     local str = tostring(id)
  32 |     if str:match("^rbxasset") then return str end
  33 |     if str:match("^%d+$") then return "rbxassetid://" .. str end
  34 |     return str
  35 | end
  36 | 
  37 | return table.freeze(Util)
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/UI/Views/Inventory/InventoryView.luau</strong> (152 lines, 5K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/UI/Views/Inventory/InventoryView.luau`

```lua
   1 | -- @View: InventoryView
   2 | -- @Standard: OVHL v0.1.1 (Strict API Usage)
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | 
   5 | -- [STRICT] Only use UI API.
   6 | local UI = Loader.UI("Foundation/API")
   7 | local Children = UI.Children
   8 | 
   9 | -- [[ SUB-COMPONENT: ITEM SLOT ]]
  10 | local function ItemSlot(scope, props)
  11 |     local C = UI.Theme.Colors
  12 |     local Config = props.Config
  13 |     local Item = props.Item
  14 |     
  15 |     local rarityColor = Config.UI.RarityColors[Item.Rarity] or C.Neutral.Main
  16 |     local layoutMode = Config.Layout.Mode
  17 | 
  18 |     local size
  19 |     if layoutMode == "List" then
  20 |         size = UDim2.new(1, 0, 0, Config.Layout.List.Height)
  21 |     else
  22 |         size = UDim2.fromOffset(Config.Layout.Grid.CellSize.X, Config.Layout.Grid.CellSize.Y)
  23 |     end
  24 | 
  25 |     -- [FIX] Explicit UI.New call.
  26 |     -- Using Raw "Frame" means we must manually add UIPadding if we want padding.
  27 |     return UI.New(scope, "Frame") {
  28 |         Name = "Slot_" .. Item.Id,
  29 |         Size = size,
  30 |         BackgroundColor3 = UI.Theme.Colors.Base.Main,
  31 |         BackgroundTransparency = 0,
  32 |         
  33 |         [Children] = {
  34 |             UI.New(scope, "UICorner") { CornerRadius = UDim.new(0, 6) },
  35 |             UI.New(scope, "UIStroke") {
  36 |                 Color = rarityColor,
  37 |                 Thickness = 2,
  38 |                 ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  39 |             },
  40 |             
  41 |             UI.New(scope, "Frame") {
  42 |                 Size = UDim2.fromScale(1, 1),
  43 |                 BackgroundTransparency = 1,
  44 |                 
  45 |                 [Children] = {
  46 |                     -- Fix Padding: Add explicit UIPadding child
  47 |                     UI.New(scope, "UIPadding") {
  48 |                         PaddingTop = UDim.new(0, 8),
  49 |                         PaddingBottom = UDim.new(0, 8),
  50 |                         PaddingLeft = UDim.new(0, 8),
  51 |                         PaddingRight = UDim.new(0, 8),
  52 |                     },
  53 |                     
  54 |                     UI.New(scope, "TextLabel") {
  55 |                         Text = Item.Name,
  56 |                         TextColor3 = C.BaseContent.Main,
  57 |                         TextSize = 14,
  58 |                         Size = UDim2.new(1, 0, 0, 20),
  59 |                         BackgroundTransparency = 1,
  60 |                         FontFace = UI.Theme.Font.Body
  61 |                     },
  62 |                     UI.New(scope, "TextLabel") {
  63 |                         Text = "x" .. Item.Count,
  64 |                         TextColor3 = C.Neutral.Main,
  65 |                         TextSize = 12,
  66 |                         Size = UDim2.new(1, 0, 0, 20),
  67 |                         Position = UDim2.fromScale(0, 1),
  68 |                         AnchorPoint = Vector2.new(0, 1),
  69 |                         BackgroundTransparency = 1,
  70 |                         FontFace = UI.Theme.Font.Body
  71 |                     }
  72 |                 }
  73 |             }
  74 |         }
  75 |     }
  76 | end
  77 | 
  78 | -- [[ LAYOUT STRATEGY ]]
  79 | local function RenderLayoutStrategy(scope, layoutConfig)
  80 |     if layoutConfig.Mode == "List" then
  81 |         return UI.New(scope, "UIListLayout") {
  82 |             Padding = UDim.new(0, layoutConfig.List.Gap),
  83 |             SortOrder = Enum.SortOrder.LayoutOrder,
  84 |             HorizontalAlignment = Enum.HorizontalAlignment.Center
  85 |         }
  86 |     else
  87 |         return UI.New(scope, "UIGridLayout") {
  88 |             CellSize = UDim2.fromOffset(layoutConfig.Grid.CellSize.X, layoutConfig.Grid.CellSize.Y),
  89 |             CellPadding = UDim2.fromOffset(layoutConfig.Grid.Gap.X, layoutConfig.Grid.Gap.Y),
  90 |             SortOrder = layoutConfig.Grid.Sort,
  91 |             HorizontalAlignment = Enum.HorizontalAlignment.Center
  92 |         }
  93 |     end
  94 | end
  95 | 
  96 | -- [[ MAIN VIEW ]]
  97 | return function(scope, props)
  98 |     local Config = props.Config
  99 |     local State = props.State
 100 |     
 101 |     -- 'scope' here is the Main Scope (Onyx Enabled).
 102 |     return scope:ScreenWrapper {
 103 |         Name = "InventoryScreen",
 104 |         Enabled = State.Visible,
 105 |         Order = 10,
 106 |         
 107 |         [Children] = {
 108 |             scope:Window {
 109 |                 Title = Config.UI.Title,
 110 |                 Size = UDim2.fromOffset(600, 450),
 111 |                 OnClose = props.OnClose,
 112 |                 
 113 |                 [Children] = {
 114 |                     UI.New(scope, "ScrollingFrame") {
 115 |                         Name = "Container",
 116 |                         Size = UDim2.fromScale(1, 1),
 117 |                         BackgroundTransparency = 1,
 118 |                         CanvasSize = UDim2.new(0, 0, 0, 0),
 119 |                         AutomaticCanvasSize = Enum.AutomaticSize.Y,
 120 |                         ScrollBarThickness = 4,
 121 |                         
 122 |                         [Children] = {
 123 |                             RenderLayoutStrategy(scope, Config.Layout),
 124 |                             
 125 |                             UI.ForValues(scope, State.Items, function(use, innerScope, item)
 126 |                                 return ItemSlot(innerScope, {
 127 |                                     Item = item,
 128 |                                     Config = Config
 129 |                                 })
 130 |                             end)
 131 |                         }
 132 |                     },
 133 |                     
 134 |                     UI.Computed(scope, function(use)
 135 |                         local items = use(State.Items)
 136 |                         if #items == 0 then
 137 |                             return UI.New(scope, "TextLabel") {
 138 |                                 Text = Config.UI.EmptyState,
 139 |                                 Size = UDim2.fromScale(1, 1),
 140 |                                 BackgroundTransparency = 1,
 141 |                                 TextColor3 = UI.Theme.Colors.Neutral.Main,
 142 |                                 TextSize = 16,
 143 |                                 FontFace = UI.Theme.Font.Body
 144 |                             }
 145 |                         end
 146 |                         return nil
 147 |                     end)
 148 |                 }
 149 |             }
 150 |         }
 151 |     }
 152 | end
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Config/PermissionConfig.luau</strong> (7 lines, 155B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Config/PermissionConfig.luau`

```lua
   1 | return {
   2 |     Provider = "HDAdmin", -- Options: "HDAdmin", "Internal"
   3 |     Settings = { 
   4 |         OwnerIsSuperAdmin = true,
   5 |         LogChanges = true
   6 |     }
   7 | }
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Permissions/Adapters/HDAdmin.luau</strong> (57 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Permissions/Adapters/HDAdmin.luau`

```lua
   1 | -- @Adapter: HDAdmin
   2 | -- Menghubungkan diri ke _G.HDAdminMain
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | local RunService = game:GetService("RunService")
   5 | 
   6 | local HD = {}
   7 | local _api = nil
   8 | local _scanning = false
   9 | 
  10 | function HD.StartScan(logger)
  11 |     if _api or _scanning then return end
  12 |     _scanning = true
  13 |     
  14 |     local start = os.clock()
  15 |     
  16 |     task.spawn(function()
  17 |         while (os.clock() - start) < 10 do
  18 |             if _G.HDAdminMain then
  19 |                 _api = _G.HDAdminMain
  20 |                 break
  21 |             end
  22 |             
  23 |             local setup = RS:FindFirstChild("HDAdminSetup")
  24 |             if setup then
  25 |                 local s, m = pcall(require, setup)
  26 |                 if s and m and m.GetMain then
  27 |                     _api = m:GetMain()
  28 |                     break
  29 |                 end
  30 |             end
  31 |             task.wait(1)
  32 |         end
  33 |         
  34 |         -- [FIX] Logger Check sebelum Info/Warn (untuk menghindari crash)
  35 |         if logger then
  36 |             if _api then
  37 |                 logger:Info("Link", "HD Admin API Connected")
  38 |             else
  39 |                 logger:Warn("Link", "HD Admin API Not Found (Timeout)")
  40 |             end
  41 |         end
  42 |         _scanning = false
  43 |     end)
  44 | end
  45 | 
  46 | function HD.GetRank(player)
  47 |     if not _api then return 0 end
  48 |     
  49 |     local s, cf = pcall(function() return _api:GetModule("cf") end)
  50 |     if s and cf then
  51 |         local id = cf:GetRankId(player)
  52 |         return tonumber(id) or 0
  53 |     end
  54 |     return 0
  55 | end
  56 | 
  57 | return HD
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/Permissions/Adapters/InternalDB.luau</strong> (24 lines, 607B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/Permissions/Adapters/InternalDB.luau`

```lua
   1 | -- @Adapter: InternalDB
   2 | -- Menyimpan Rank admin custom (selain HD Admin)
   3 | local DataStoreService = game:GetService("DataStoreService")
   4 | local Store = DataStoreService:GetDataStore("OVHL_Perms_V1")
   5 | 
   6 | local DB = {}
   7 | 
   8 | function DB.Get(userId)
   9 |     local s, r = pcall(function() return Store:GetAsync(tostring(userId)) end)
  10 |     if s and r then return r end
  11 |     return 0
  12 | end
  13 | 
  14 | function DB.Set(userId, rank)
  15 |     local key = tostring(userId)
  16 |     if rank <= 0 then
  17 |         pcall(function() Store:RemoveAsync(key) end)
  18 |     else
  19 |         pcall(function() Store:SetAsync(key, rank) end)
  20 |     end
  21 |     return true
  22 | end
  23 | 
  24 | return DB
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Core/ServerKernel.luau</strong> (97 lines, 3K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Core/ServerKernel.luau`

```lua
   1 | -- @Kernel: Server v0.6.0 (Smart Naming & Network Ready)
   2 | local ServerScriptService = game:GetService("ServerScriptService")
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | 
   5 | local Context = Loader.Core("Context")
   6 | local SmartLogger = Loader.Core("SmartLogger")
   7 | local Manifest = Loader.Core("Manifest")
   8 | local Bridge = Loader.Core("Networking/Bridge")
   9 | 
  10 | local Adapters = {
  11 |     DB = require(ServerScriptService.OVHL.Core.Permissions.Adapters.InternalDB),
  12 |     HD = require(ServerScriptService.OVHL.Core.Permissions.Adapters.HDAdmin)
  13 | }
  14 | 
  15 | local ServerKernel = {}
  16 | 
  17 | function ServerKernel.Boot()
  18 |     local Log = SmartLogger.New("SYSTEM")
  19 |     Log:Info(string.format("🚀 %s v%s (%s) SERVER STARTING...", Manifest.Identity.Name, Manifest.Version.Full, Manifest.Metadata.BuildType))
  20 |     
  21 |     local services = {} 
  22 |     
  23 |     -- [[ SMART REGISTRAR ]]
  24 |     local function register(module, featureName)
  25 |         if module:IsA("ModuleScript") then
  26 |             local ok, res = pcall(require, module)
  27 |             if ok then 
  28 |                 local finalName = module.Name
  29 |                 if featureName and (module.Name == "Service" or module.Name == "Service.luau") then
  30 |                     finalName = featureName .. "Service"
  31 |                 end
  32 |                 
  33 |                 services[finalName] = res
  34 |                 Log:Debug(string.format("   + Service Registered: %-20s (Source: %s)", finalName, module.Name))
  35 |             else
  36 |                 Log:Error("   x Failed to load: " .. module.Name, res)
  37 |             end
  38 |         end
  39 |     end
  40 | 
  41 |     Log:Info("🔍 Scanning Services...")
  42 |     
  43 |     local coreFolder = ServerScriptService.OVHL.Services
  44 |     for _, mod in ipairs(coreFolder:GetChildren()) do register(mod) end
  45 |     
  46 |     local modulesFolder = ServerScriptService.OVHL.Modules
  47 |     for _, feature in ipairs(modulesFolder:GetChildren()) do
  48 |         if feature:IsA("Folder") then
  49 |             for _, file in ipairs(feature:GetChildren()) do
  50 |                 if file.Name:match("Service$") then 
  51 |                     register(file, feature.Name) 
  52 |                 end
  53 |             end
  54 |         end
  55 |     end
  56 |     
  57 |     services.Adapters = Adapters
  58 |     
  59 |     local ctx = Context.New(services)
  60 |     
  61 |     -- [FIX] Initialize Network Bridge
  62 |     ctx.Network = Bridge.New()
  63 |     Log:Info("🌐 Network Bridge Initialized")
  64 |     
  65 |     -- [[ LIFECYCLE ]]
  66 |     Log:Info("Phase 1: Init")
  67 |     for name, srv in pairs(services) do
  68 |         if srv.Init then 
  69 |             task.spawn(function() 
  70 |                 local s, r = pcall(srv.Init, srv, ctx)
  71 |                 if not s then Log:Error("Init Failed: " .. name, r) end
  72 |             end) 
  73 |         end
  74 |     end
  75 |     
  76 |     Log:Info("Phase 2: Start")
  77 |     for name, srv in pairs(services) do
  78 |         if srv.Start then 
  79 |             task.spawn(function() 
  80 |                 local s, r = pcall(srv.Start, srv)
  81 |                 if not s then Log:Error("Start Failed: " .. name, r) end
  82 |             end) 
  83 |         end
  84 |     end
  85 |     
  86 |     game:BindToClose(function()
  87 |         Log:Warn("⚠️ SERVER SHUTTING DOWN...")
  88 |         for _, srv in pairs(services) do
  89 |             if srv.Shutdown then pcall(srv.Shutdown, srv) end
  90 |         end
  91 |         task.wait(2)
  92 |     end)
  93 |     
  94 |     Log:Info("✅ SERVER BOOT COMPLETE")
  95 | end
  96 | 
  97 | return ServerKernel
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/Inventory/InventoryService.luau</strong> (55 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/Inventory/InventoryService.luau`

```lua
   1 | -- @Service: InventoryService
   2 | -- @Standard: OVHL v0.1.1 (Correct Bridge API)
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | local Loader = require(RS.OVHL.Core.Loader)
   5 | local Cfg = Loader.Module("Inventory", "SharedConfig")
   6 | 
   7 | local Hub = {}
   8 | 
   9 | local MOCK_ITEMS = {
  10 | 	{ Id = 1, Name = "ini pedang mahal", Rarity = "Epic", Count = 1 },
  11 | 	{ Id = 2, Name = "Health Potion", Rarity = "Common", Count = 5 },
  12 | 	{ Id = 3, Name = "Mana Crystal", Rarity = "Rare", Count = 2 },
  13 | 	{ Id = 4, Name = "Legendary Orb", Rarity = "Legendary", Count = 1 },
  14 | 	{ Id = 5, Name = "Scrap Metal", Rarity = "Common", Count = 10 },
  15 | 	{ Id = 6, Name = "Mythic Crown", Rarity = "Mythic", Count = 1 },
  16 | }
  17 | 
  18 | function Hub:Init(ctx)
  19 | 	self.Logger = ctx:CreateLogger("INVENTORY")
  20 | 	self.Network = ctx.Network
  21 | 	self.RateLimitCache = {}
  22 | 
  23 | 	-- Register Handler using Bridge v0.1.1 API
  24 | 	self.Handler = self.Network:Register("Inventory", {})
  25 | 
  26 | 	self.Handler.OnInvoke(function(player, requestName, ...)
  27 | 		if requestName == "GetItems" then
  28 | 			return self:GetItems(player)
  29 | 		end
  30 | 		return { Success = false, Error = "Unknown Request" }
  31 | 	end)
  32 | 
  33 | 	self.Logger:Info("System", "Inventory Network Active.")
  34 | end
  35 | 
  36 | function Hub:Start() end
  37 | 
  38 | function Hub:GetItems(player)
  39 | 	local userId = player.UserId
  40 | 	local currentTime = os.time()
  41 | 	local lastFetch = self.RateLimitCache[userId] or 0
  42 | 	local rateLimitSeconds = 1
  43 | 
  44 | 	if currentTime - lastFetch < rateLimitSeconds then
  45 | 		return { Success = false, Error = "RateLimited", Wait = rateLimitSeconds - (currentTime - lastFetch) }
  46 | 	end
  47 | 
  48 | 	self.RateLimitCache[userId] = currentTime
  49 | 
  50 | 	self.Logger:Info("Data", { User = player.Name, Action = "FetchItems" })
  51 | 
  52 | 	return { Success = true, Data = MOCK_ITEMS }
  53 | end
  54 | 
  55 | return Hub
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/ServerRuntime.server.luau</strong> (2 lines, 79B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/ServerRuntime.server.luau`

```lua
   1 | -- Server Runtime
   2 | require(game.ReplicatedStorage.OVHL.Bootstrap).StartServer()
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/DataManager.luau</strong> (99 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/DataManager.luau`

```lua
   1 | -- @Service: DataManager
   2 | -- @Standard: Enterprise (Retry Mechanism & Env Aware)
   3 | local Players = game:GetService("Players")
   4 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   5 | 
   6 | local ProfileService = Loader.Pkg("ProfileService")
   7 | local Env = Loader.Core("Env")
   8 | 
   9 | local DataManager = {}
  10 | local ProfileStore = nil
  11 | local Profiles = {}
  12 | 
  13 | local DATA_TEMPLATE = {
  14 |     Coins = 0,
  15 |     Level = 1,
  16 |     Inventory = {},
  17 |     Meta = { FirstJoin = 0, LastLogin = 0 },
  18 | }
  19 | 
  20 | function DataManager:Init(ctx)
  21 |     self.Logger = ctx:CreateLogger("DATA")
  22 | 
  23 |     local storeName = Env.IsStudio() and "OVHL_Dev_01" or "OVHL_Prod_01"
  24 |     if Env.MockDataStore() then
  25 |         self.Logger:Warn("⚠️ USING MOCK DATASTORE")
  26 |         ProfileStore = ProfileService.GetProfileStore({ Name = storeName, Scope = "Mock" }, DATA_TEMPLATE)
  27 |         ProfileStore = ProfileStore.Mock
  28 |     else
  29 |         ProfileStore = ProfileService.GetProfileStore(storeName, DATA_TEMPLATE)
  30 |     end
  31 | 
  32 |     Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
  33 |     Players.PlayerRemoving:Connect(function(p) self:OnQuit(p) end)
  34 | end
  35 | 
  36 | function DataManager:Start()
  37 |     for _, player in ipairs(Players:GetPlayers()) do
  38 |         task.spawn(function() self:OnJoin(player) end)
  39 |     end
  40 | end
  41 | 
  42 | function DataManager:Shutdown()
  43 |     self.Logger:Warn("🛑 DataManager Shutting Down...")
  44 |     for _, profile in pairs(Profiles) do
  45 |         profile:Release()
  46 |     end
  47 | end
  48 | 
  49 | function DataManager:OnJoin(player)
  50 |     if Profiles[player] then return end
  51 | 
  52 |     local profile = nil
  53 |     local attempts = 0
  54 |     local maxAttempts = 3
  55 |     
  56 |     while attempts < maxAttempts and player:IsDescendantOf(Players) do
  57 |         attempts += 1
  58 |         profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
  59 |         
  60 |         if profile then
  61 |             break 
  62 |         else
  63 |             self.Logger:Warn("LoadRetry", { User = player.Name, Attempt = attempts })
  64 |             task.wait(2) 
  65 |         end
  66 |     end
  67 | 
  68 |     if profile then
  69 |         profile:AddUserId(player.UserId)
  70 |         profile:Reconcile()
  71 | 
  72 |         profile:ListenToRelease(function()
  73 |             Profiles[player] = nil
  74 |             player:Kick("Session Released")
  75 |         end)
  76 | 
  77 |         if player:IsDescendantOf(Players) then
  78 |             Profiles[player] = profile
  79 |             self.Logger:Info("Profile Loaded", { User = player.Name })
  80 |         else
  81 |             profile:Release()
  82 |         end
  83 |     else
  84 |         self.Logger:Error("LoadFail", { User = player.Name, Attempts = attempts })
  85 |         player:Kick("Critical Data Error: Failed to load profile after retries.")
  86 |     end
  87 | end
  88 | 
  89 | function DataManager:OnQuit(player)
  90 |     local profile = Profiles[player]
  91 |     if profile then profile:Release() end
  92 | end
  93 | 
  94 | function DataManager:Get(player)
  95 |     local profile = Profiles[player]
  96 |     return profile and profile.Data
  97 | end
  98 | 
  99 | return DataManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/MonetizationService.luau</strong> (44 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/MonetizationService.luau`

```lua
   1 | -- @Service: MonetizationService
   2 | local MarketplaceService = game:GetService("MarketplaceService")
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | 
   5 | local MonetizationService = {}
   6 | local Handlers = {}
   7 | 
   8 | function MonetizationService:Init(ctx)
   9 |     self.Logger = ctx:CreateLogger("SHOP")
  10 | end
  11 | 
  12 | function MonetizationService:Start()
  13 |     MarketplaceService.ProcessReceipt = function(info)
  14 |         return self:Process(info)
  15 |     end
  16 | end
  17 | 
  18 | function MonetizationService:Shutdown() 
  19 |     -- No critical cleanup needed for receipts, handled by Roblox retry
  20 | end
  21 | 
  22 | function MonetizationService:RegisterProduct(id, func)
  23 |     Handlers[id] = func
  24 | end
  25 | 
  26 | function MonetizationService:Process(info)
  27 |     local handler = Handlers[info.ProductId]
  28 |     local player = game.Players:GetPlayerByUserId(info.PlayerId)
  29 |     
  30 |     if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
  31 |     
  32 |     if handler then
  33 |         local s, r = pcall(handler, player, info)
  34 |         if s then
  35 |             self.Logger:Info("Purchase OK", {Product=info.ProductId})
  36 |             return Enum.ProductPurchaseDecision.PurchaseGranted
  37 |         else
  38 |             self.Logger:Error("Purchase Error", {Error=r})
  39 |         end
  40 |     end
  41 |     return Enum.ProductPurchaseDecision.NotProcessedYet
  42 | end
  43 | 
  44 | return MonetizationService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Services/PermissionService.luau</strong> (76 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Services/PermissionService.luau`

```lua
   1 | -- @Service: PermissionService (Lifecycle Fixed)
   2 | local Players = game:GetService("Players")
   3 | local SSS = game:GetService("ServerScriptService")
   4 | local Cfg = require(SSS.OVHL.Config.PermissionConfig)
   5 | 
   6 | local Hub = {}
   7 | 
   8 | function Hub:Init(ctx)
   9 |     -- [1] PRIORITAS: Logger harus dibuat di Init
  10 |     self.Logger = ctx:CreateLogger("PERMISSION")
  11 |     
  12 |     self.DB = ctx.Adapters.DB
  13 |     self.HD = ctx.Adapters.HD
  14 |     self._cache = {}
  15 |     self.RANKS = { GUEST=0, VIP=1, MOD=2, ADMIN=3, HEAD=4, OWNER=5 }
  16 | 
  17 |     Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
  18 |     
  19 |     -- [2] FIX TIMING: Defer StartScan agar Init selesai
  20 |     if Cfg.Provider == "HDAdmin" then
  21 |         task.defer(function()
  22 |             self.HD.StartScan(self.Logger) -- self.Logger sekarang pasti non-nil
  23 |             -- Re-scan players setelah HD connect
  24 |             task.wait(3) 
  25 |             for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
  26 |         end)
  27 |     end
  28 | end
  29 | 
  30 | function Hub:Start()
  31 |     -- Logika HDAdmin dipindahkan ke Init/Defer.
  32 | end
  33 | 
  34 | function Hub:OnJoin(p)
  35 |     -- Delay sedikit untuk memastikan DataStore/HD siap
  36 |     task.delay(1, function() 
  37 |         if p.Parent then self:Resolve(p) end 
  38 |     end)
  39 | end
  40 | 
  41 | function Hub:Resolve(p)
  42 |     -- 1. Fetch Sources
  43 |     local rawDB = self.DB.Get(p.UserId) or 0
  44 |     local rawHD = 0
  45 |     
  46 |     -- [FIX] Gunakan pcall untuk GetRank agar tidak crash jika adapter nil
  47 |     if Cfg.Provider == "HDAdmin" and self.HD and self.HD.GetRank then 
  48 |         local s, r = pcall(self.HD.GetRank, self.HD, p)
  49 |         if s and type(r) == "number" then rawHD = r end
  50 |     end
  51 |     
  52 |     local isOwnerConfig = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
  53 |     
  54 |     -- 2. WINNING SOURCE LOGIC (OWNER PRIORITY)
  55 |     local r, s = 0, "GUEST"
  56 |     if rawDB > r then r=rawDB; s="INTERNAL_DB" end -- Internal DB can set rank
  57 |     if rawHD > r then r=rawHD; s="HD_ADMIN" end    -- HD Admin can set rank
  58 |     if isOwnerConfig then r=5; s="OWNER" end       -- Owner ALWAYS wins (Override)
  59 |     
  60 |     -- 3. Cache & REPLICATE
  61 |     p:SetAttribute("OVHL_Rank", r) -- Client can read this
  62 |     p:SetAttribute("OVHL_Role", s)
  63 |     
  64 |     self.Logger:Info("Identity", {
  65 |         User = p.Name,
  66 |         Rank = r,
  67 |         Source = s,
  68 |         Details = string.format("[HD:%d] [DB:%d]", rawHD, rawDB)
  69 |     })
  70 | end
  71 | 
  72 | function Hub:GetRank(p)
  73 |     return p:GetAttribute("OVHL_Rank") or 0
  74 | end
  75 | 
  76 | return Hub
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.luau</strong> (2 lines, 79B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.luau`

```lua
   1 | -- Client Runtime
   2 | require(game.ReplicatedStorage.OVHL.Bootstrap).StartClient()
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/PermissionController.luau</strong> (37 lines, 932B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/PermissionController.luau`

```lua
   1 | -- @Controller: PermissionController
   2 | -- @Responsibility: Listen to Rank updates and notify system
   3 | local Players = game:GetService("Players")
   4 | local Ctrl = {}
   5 | 
   6 | function Ctrl:Init(ctx)
   7 |     self.Logger = ctx:CreateLogger("PERMISSION")
   8 |     self.Player = Players.LocalPlayer
   9 | end
  10 | 
  11 | function Ctrl:Start()
  12 |     -- Listen to Attribute Changes (Replication from Server)
  13 |     self.Player:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
  14 |         self:OnRankChanged()
  15 |     end)
  16 |     
  17 |     -- Initial Check
  18 |     self:OnRankChanged()
  19 | end
  20 | 
  21 | function Ctrl:OnRankChanged()
  22 |     local rank = self.Player:GetAttribute("OVHL_Rank") or 0
  23 |     local role = self.Player:GetAttribute("OVHL_Role") or "Guest"
  24 |     
  25 |     self.Logger:Info("Update", { 
  26 |         Rank = rank, 
  27 |         Role = role 
  28 |     })
  29 |     
  30 |     -- TODO: Trigger UI Refresh jika perlu (via Signals)
  31 | end
  32 | 
  33 | function Ctrl:GetRank()
  34 |     return self.Player:GetAttribute("OVHL_Rank") or 0
  35 | end
  36 | 
  37 | return Ctrl
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Core/ClientKernel.luau</strong> (87 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Core/ClientKernel.luau`

```lua
   1 | -- @Kernel: Client v0.4.0 (Standardized)
   2 | local Players = game:GetService("Players")
   3 | local RS = game:GetService("ReplicatedStorage")
   4 | local Loader = require(RS.OVHL.Core.Loader)
   5 | 
   6 | -- [STANDARD] Load Core Systems yang BENAR-BENAR ADA
   7 | local ConfigLoader = Loader.Core("SharedConfigLoader")
   8 | local Bridge = Loader.Core("Networking/Bridge")
   9 | local Context = Loader.Core("Context")
  10 | local SmartLogger = Loader.Core("SmartLogger")
  11 | local Manifest = Loader.Core("Manifest")
  12 | 
  13 | local ClientKernel = {}
  14 | 
  15 | function ClientKernel.Boot()
  16 |     local Log = SmartLogger.New("SYSTEM")
  17 |     Log:Info(string.format("🎮 %s v%s (%s) CLIENT STARTING...", Manifest.Identity.Name, Manifest.Version.Full, Manifest.Metadata.BuildType))
  18 |     
  19 |     -- [STANDARD] Systems Container
  20 |     local systems = {
  21 |         ConfigLoader = ConfigLoader,
  22 |         Network = Bridge.New(), 
  23 |         Controllers = {} 
  24 |     }
  25 |     
  26 |     local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
  27 |     local Root = PlayerScripts:WaitForChild("OVHL")
  28 |     
  29 |     -- [[ DISCOVERY FUNCTION ]]
  30 |     local function register(module)
  31 |         if module:IsA("ModuleScript") then
  32 |             local ok, res = pcall(require, module)
  33 |             if ok then 
  34 |                 systems.Controllers[module.Name] = res
  35 |                 systems[module.Name] = res 
  36 |                 Log:Debug("   + Controller: " .. module.Name)
  37 |             else
  38 |                 Log:Error("   x Failed: " .. module.Name, res)
  39 |             end
  40 |         end
  41 |     end
  42 |     
  43 |     -- 1. Scan Controllers & Modules
  44 |     Log:Info("🔍 Scanning Client Modules...")
  45 |     if Root:FindFirstChild("Controllers") then
  46 |         for _, mod in ipairs(Root.Controllers:GetChildren()) do register(mod) end
  47 |     end
  48 |     if Root:FindFirstChild("Modules") then
  49 |         for _, feature in ipairs(Root.Modules:GetChildren()) do
  50 |             if feature:IsA("Folder") then
  51 |                 for _, file in ipairs(feature:GetChildren()) do
  52 |                     if file.Name:match("Controller$") then register(file) end
  53 |                 end
  54 |             end
  55 |         end
  56 |     end
  57 |     
  58 |     -- [STANDARD] Context New (Context akan auto-inject SmartLogger helper)
  59 |     local ctx = Context.New(systems)
  60 |     
  61 |     -- Lifecycle: Init
  62 |     Log:Info("Phase 1: Init")
  63 |     for name, ctrl in pairs(systems.Controllers) do
  64 |         if ctrl.Init then 
  65 |             task.spawn(function()
  66 |                 local s, r = pcall(function() ctrl:Init(ctx) end)
  67 |                 if not s then Log:Error("Init Fail: " .. name, r) end
  68 |             end)
  69 |         end
  70 |     end
  71 |     
  72 |     -- Lifecycle: Start
  73 |     task.delay(0.1, function()
  74 |         Log:Info("Phase 2: Start")
  75 |         for name, ctrl in pairs(systems.Controllers) do
  76 |             if ctrl.Start then 
  77 |                 task.spawn(function() 
  78 |                     local s, r = pcall(function() ctrl:Start() end)
  79 |                     if not s then Log:Error("Start Fail: " .. name, r) end
  80 |                 end) 
  81 |             end
  82 |         end
  83 |         Log:Info("✅ CLIENT BOOT COMPLETE")
  84 |     end)
  85 | end
  86 | 
  87 | return ClientKernel
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/InventoryController.luau</strong> (81 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/InventoryController.luau`

```lua
   1 | -- @Controller: InventoryController
   2 | -- @Standard: OVHL v0.1.1 (Trove Lifecycle)
   3 | local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
   4 | 
   5 | local Fusion = Loader.Pkg("Fusion")
   6 | local Trove = Loader.Pkg("Trove")
   7 | local Bridge = Loader.Core("Networking/Bridge").New()
   8 | 
   9 | local SharedConfig = Loader.Module("Inventory", "SharedConfig")
  10 | local UI = Loader.UI("Foundation/API")
  11 | local Topbar = Loader.UI("Foundation/Bridges/Topbar")
  12 | local InventoryView = Loader.UI("Views/Inventory/InventoryView")
  13 | 
  14 | local Ctrl = {}
  15 | 
  16 | function Ctrl:Init(ctx)
  17 |     self.Logger = ctx:CreateLogger("INVENTORY")
  18 |     self._trove = Trove.new()
  19 |     
  20 |     local scope = UI.NewScope()
  21 |     self.Scope = scope
  22 |     
  23 |     self.State = {
  24 |         Visible = scope:Value(false),
  25 |         Items = scope:Value({})
  26 |     }
  27 |     
  28 |     self._trove:Add(function()
  29 |         Fusion.doCleanup(scope)
  30 |     end)
  31 |     
  32 |     local mounted = UI.SafeLoader.Mount(scope, InventoryView, {
  33 |         Config = SharedConfig,
  34 |         State = self.State,
  35 |         OnClose = function() self:Toggle(false) end
  36 |     })
  37 |     
  38 |     if mounted then
  39 |         self._trove:Add(mounted)
  40 |     end
  41 | 
  42 |     self.Icon = Topbar.Register("Inventory", SharedConfig.Topbar, function(isOpened)
  43 |         self:Toggle(isOpened)
  44 |     end)
  45 |     
  46 |     self.Logger:Info("System", "Inventory Initialized (Trove Active)")
  47 | end
  48 | 
  49 | function Ctrl:Start()
  50 |     self:FetchData()
  51 | end
  52 | 
  53 | function Ctrl:FetchData()
  54 |     self.Logger:Debug("Fetch", "Requesting items...")
  55 |     Bridge:Request("Inventory", "GetItems")
  56 |         :andThen(function(res)
  57 |             if res.Success then
  58 |                 self.State.Items:set(res.Data)
  59 |                 self.Logger:Info("Data", { Count = #res.Data })
  60 |             end
  61 |         end)
  62 |         :catch(function(err)
  63 |             self.Logger:Error("FetchFail", err)
  64 |         end)
  65 | end
  66 | 
  67 | function Ctrl:Toggle(forceState)
  68 |     local current = Fusion.peek(self.State.Visible)
  69 |     local newState = if forceState ~= nil then forceState else not current
  70 |     self.State.Visible:set(newState)
  71 |     
  72 |     if self.Icon then
  73 |         if newState then self.Icon:select() else self.Icon:deselect() end
  74 |     end
  75 |     
  76 |     if newState then
  77 |         self:FetchData()
  78 |     end
  79 | end
  80 | 
  81 | return Ctrl
```

</details>




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
