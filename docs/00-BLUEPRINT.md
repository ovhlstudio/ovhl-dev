# 🏛️ OVHL ENTERPRISE FRAMEWORK: THE GENESIS CODEX (V5.0)

**Version:** 5.0.0 (Monolithic Source of Truth)
**Author:** Omniverse Highland Studio
**Enforcement:** SUPREME AUTHORITY
**Context:** Fusion 0.3 + Onyx UI + Lune Automation + Paranoid Security

> **⚠️ TO AI AGENTS:**
> This document is the **HISTORY, LAW, AND FUTURE** of OVHL.
> You are forbidden from simplifying or ignoring any section.
> Your task is to build upon this foundation, not reinvent it.

---

## 🚫 SECTION 1: THE CONSTITUTION (NON-NEGOTIABLE)

### 1.1. The "Anti-Decay" Protocols

1.  **LUNE AUTOMATION PROTOCOL:**
    -   **RULE:** No raw Lua blocks. Output ONLY `.luau` scripts using `@lune/fs`.
    -   **MODE:** _Surgical Injection_ (`string.gsub`) for existing files. _Overwrite_ ONLY for new files.
2.  **PATH RESOLUTION LAW:**
    -   ❌ BANNED: `script.Parent`, `game.ReplicatedStorage...`.
    -   ✅ MANDATORY: `Loader.Core("...")`, `Loader.UI("...")`.
3.  **FUSION 0.3 STRICTNESS (SCOPE SAFETY):**
    -   **FATAL ERROR:** Using `scope:New` inside `ForValues` loops (Baby Scopes do not inherit methods).
    -   **MANDATORY:** Use explicit `UI.New(scope, "ClassName") { ... }`.
4.  **CONTEXT-DI PATTERN:**
    -   No Globals (`_G`). Dependencies injected via `Init(ctx)`.
5.  **SMART LOGGER SUPREMACY:**
    -   The Log is your UI. Analyze the tree (`└──`) before fixing errors.

---

## 🏗️ SECTION 2: THE MASTER SCAFFOLD

```text
src/
├── ReplicatedStorage/OVHL/
│   ├── Bootstrap.luau          # Entry Point
│   ├── Config/                 # Global Configs
│   ├── Core/
│   │   ├── Loader.luau         # [CRITICAL] Smart Path Resolver
│   │   ├── Context.luau        # Dependency Container
│   │   ├── SmartLogger.luau    # Telemetry
│   │   ├── SharedConfigLoader.luau
│   │   ├── AssetSystem.luau    # ID Normalizer (123 -> rbxassetid://)
│   │   ├── TagService.luau     # Binder Pattern (Workspace Interaction)
│   │   ├── TypeValidator.luau  # Runtime Schema Check
│   │   ├── Logging/DomainResolver.luau
│   │   └── Networking/
│   │       ├── Bridge.luau     # [CRITICAL] Network Wrapper
│   │       └── Remotes/        # (Auto-created)
│   ├── UI/
│   │   ├── Foundation/
│   │   │   ├── API.luau        # [CRITICAL] Gateway (Fusion+Onyx+Util)
│   │   │   ├── Theme.luau      # Smart Asset Object
│   │   │   ├── Util.luau       # Helpers
│   │   │   └── SafeLoader.luau # Error Boundary
│   │   └── Views/              # Pure Functional Components
│   └── Modules/                # [SHARED STATE & CONFIG]
│       └── [FeatureName]/
│           └── SharedConfig.luau
├── ServerScriptService/OVHL/
│   ├── Core/
│   │   ├── ServerKernel.luau   # Bootstrapper
│   │   ├── RateLimiter.luau    # Token Bucket Algo
│   │   ├── NetworkGuard.luau   # Sanitizer & Redactor
│   │   └── Permissions/
│   │       ├── Adapters/       # (HDAdmin.luau, InternalDB.luau)
│   │       └── PermissionCore.luau
│   ├── Services/               # [GLOBAL SINGLETONS]
│   │   ├── DataManager.luau    # ProfileService Wrapper
│   │   ├── PermissionService.luau # The Authority
│   │   └── NotificationService.luau
│   └── Modules/                # [FEATURE BUSINESS LOGIC]
│       └── [FeatureName]/
│           └── Service.luau
└── StarterPlayer/OVHL/
    ├── Core/
    │   ├── ClientKernel.luau   # Bootstrapper
    │   ├── FinderService.luau  # [CRITICAL] UI Auto Scanner
    │   └── AssetLoader.luau    # ContentProvider Wrapper
    └── Modules/                # [FEATURE CONTROLLERS]
        └── [FeatureName]/
            └── Controller.luau
```

---

## 🧠 SECTION 3: CORE SYSTEMS & LOGIC

### 3.1. Permission Harmonization (The "Winning Source" Logic)

-   **Problem:** Conflict between `HD Admin`, `Internal DataStore`, and `Game Owner`.
-   **Solution:** `PermissionService` resolves rank (0-5) based on priority:
    1.  **Config Override:** If `UserId == OwnerId`, Rank = 5 (Absolute).
    2.  **HD Admin:** Check via `Adapters/HDAdmin.luau`. If present & higher than DB, use HD.
    3.  **Internal DB:** Check `Adapters/InternalDB.luau`. Use if higher than HD.
    4.  **Default:** Guest (0).
-   **Replication:** Rank is set as Attribute `OVHL_Rank` on the Player object for Client access.

### 3.2. Data Resilience (DataManager)

-   **Environment Awareness:**
    -   If `RunService:IsStudio()`, force `MockProfileStore`. NEVER overwrite Production data from Studio.
-   **Session Locking:** Use `Profile:ListenToRelease` to kick players if session is stolen.
-   **Retry Logic:** `LoadProfileAsync` must loop 3x with `task.wait(2)` before failing/kicking.

### 3.3. "Paranoid" Network Layer

-   **Bridge:** All traffic flows through `OVHL_Remotes`.
-   **NetworkGuard:**
    -   **Inbound:** Strip `Instance` types (exploit prevention). Check recursion depth.
    -   **Outbound:** Redact keys ("Token", "Secret").
-   **RateLimiter:** Token Bucket algorithm. Returns `{ Error="RateLimit", Wait=X }` if exceeded.

### 3.4. UI Auto-Scanner (`FinderService`)

-   **Problem:** Renaming GUI instances breaks scripts.
-   **Solution:** Client never hardcodes paths.
    -   `Finder.Get("BuyButton")` searches by:
        1.  **Attribute:** `Root:GetAttribute("BuyButtonRef")`.
        2.  **Tag:** `CollectionService:GetTagged("BuyButton")` inside Root.
        3.  **Recursive Name:** `Root:FindFirstChild("BuyButton", true)`.

---

## 🎨 SECTION 4: UI ARCHITECTURE (THE HYBRID)

### 4.1. The API Gateway (`Foundation/API`)

-   **Role:** Merges `Fusion 0.3`, `OnyxUI`, and `OVHL.Util` into one table.
-   **Mandate:** View files MUST `require` this API. Never import packages directly.

### 4.2. Data-Driven Layout Engine

-   **SharedConfig:** `Layout = { Mode = "Grid", GridSpec={...}, ListSpec={...} }`.
-   **View Implementation:**
    ```lua
    local function RenderLayout(scope, config)
        if config.Mode == "List" then return UI.New(scope, "UIListLayout") { ... }
        else return UI.New(scope, "UIGridLayout") { ... }
    end
    ```

---

## 🗓️ SECTION 5: THE GRAND ROADMAP (PAST, PRESENT, FUTURE)

### Phase 0: Initialization (DONE)

-   [x] Environment Setup (Rokit, Wally, Rojo).
-   [x] File Structure Scaffold.

### Phase 1: Foundation Construction (DONE)

-   [x] `Loader` (Smart Path Resolution).
-   [x] `ServerKernel` (Smart Naming & Bootstrapper).
-   [x] `API.luau` (The Gateway).
-   [x] `SmartLogger` (Telemetry).

### Phase 2: Legacy Intelligence Migration (DONE)

-   [x] `PermissionService` (Logic Harmonization).
-   [x] `DataManager` (Retry & Mock logic).
-   [x] `Inventory Module` (The Reference Implementation).

### Phase 3: The Current Gap (YOU ARE HERE)

-   [ ] **Implement RateLimiter Logic:** File exists, logic is mocked. Needs Token Bucket.
-   [ ] **Implement NetworkGuard:** Ensure recursive cleaning is active.
-   [ ] **Implement FinderService:** Ensure Client Core has the 3-step lookup.
-   [ ] **Implement TagService:** Binder pattern for Workspace objects.

### Phase 4: Feature Migration

-   [ ] **Admin System:** Port from Legacy to `Modules/Admin`.
-   [ ] **Shop System:** Refactor `PrototypeShop` -> `Modules/Shop` using Inventory Standard.
-   [ ] **Pet Inventory:** Refactor complex UI using Data-Driven Layout.

### Phase 5: Polish & Release

-   [ ] **Unit Tests:** Populate `tests` folder.
-   [ ] **CI/CD:** Github Actions pipeline.
-   [ ] **Public Distribution.**

---

## 🧬 SECTION 6: REFERENCE DNA (DO NOT GUESS - USE THIS)

### A. `Core/Loader.luau` (Smart Resolution)

```lua
-- ... (Logic to find 'profileservice' when 'ProfileService' is requested) ...
```

### B. `Foundation/API.luau` (The Merger)

```lua
local CombinedUtil = setmetatable({}, {__index = function(_,k) return Util[k] or Onyx.Util[k] end})
-- ... API.Themer = Onyx.Themer ...
```

### C. `ServerKernel.luau` (Smart Naming)

```lua
-- ... if file.Name == "Service" then finalName = featureName .. "Service" ...
```

---

**END OF CODEX V5.0.**
