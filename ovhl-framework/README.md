# 🎮 OVHL Core Framework

![Version](https://img.shields.io/badge/Version-0.1.0-blue?style=flat-square)
![Fusion](https://img.shields.io/badge/UI-Fusion_0.3_+_Onyx-purple?style=flat-square)
![Security](https://img.shields.io/badge/Security-Paranoid_Mode-red?style=flat-square)

**The OVHL Core Framework** is the runtime engine powering the Omniverse ecosystem. It is a strictly typed, modular, and secure architecture built on Luau. It enforces a hard separation between **Core Foundation** (The Engine) and **Modules** (Game Logic).

---

## ⚡ Quick Start

Ensure you are inside the `ovhl-framework` directory.

```bash
# 1. Install Dependencies
wally install

# 2. Generate Sourcemap (Required for Lune)
rojo sourcemap default.project.json --output sourcemap.json

# 3. Start Rojo Server
rojo serve
```

---

## 🏗️ System Architecture

### 1. The Smart Kernel (`ServerScriptService/OVHL/Core`)

The Kernel is the bootstrapper that manages the game lifecycle to prevent race conditions.

-   **Boot Sequence:** `Bridge` Init -> `Adapters` Load -> `Service` Injection -> `Init()` -> `Start()`.
-   **Smart Discovery:** Automatically detects `Service.luau` files within Modules and registers them as `[FeatureName]Service` to prevent naming collisions in the Dependency Injection container.

### 2. The API Gateway (`ReplicatedStorage/OVHL/UI/Foundation`)

The UI framework is a hybrid of **Fusion 0.3** and **OnyxUI**.

-   **One Source of Truth:** Views MUST require `Loader.UI("Foundation/API")`. Direct package imports are forbidden.
-   **Util Merger:** The API automatically merges `Onyx.Util` (Springs, UDim) with `OVHL.Util` (Asset cleaning, Font wrappers).
-   **Explicit Construction:** Uses `UI.New(scope, "Class")` to avoid Scope Inheritance issues common in Fusion loops.

### 3. The Paranoid Network (`ReplicatedStorage/OVHL/Core/Networking`)

All client-server communication flows through the **Bridge**.

-   **NetworkGuard:** Automatically strips `Instance` types from remote arguments (anti-exploit) and checks recursion depth.
-   **RateLimiter:** Implements Token Bucket algorithm per player/endpoint.
-   **Data Sanitization:** Outbound traffic automatically redacts keys like `Token` or `Secret`.

---

## 📂 Directory Structure

```text
src/
├── 📂 ReplicatedStorage/OVHL/
│   ├── 📂 Core/            # The Brain (Loader, Logger, Networking)
│   ├── 📂 UI/              # The View (API, Theme, Components)
│   └── 📂 Modules/         # Shared Data (Config, State)
├── 📂 ServerScriptService/OVHL/
│   ├── 📂 Core/            # Server Kernel & Security
│   ├── 📂 Services/        # Global Singletons (Data, Permission)
│   └── 📂 Modules/         # Game Business Logic
└── 📂 StarterPlayer/OVHL/
    ├── 📂 Core/            # Client Kernel & FinderService
    └── 📂 Modules/         # User Interaction Logic (Controllers)
```

---

## 🛠️ Module Development Standard

Every feature (e.g., `Inventory`, `Shop`) MUST follow the **Triad Pattern**:

1.  **SharedConfig (`ReplicatedStorage`)**:
    -   Defines `Layout.Mode` ("Grid" vs "List").
    -   Defines Network Routes.
    -   Contains static data (Item Names, Colors).
2.  **Service (`ServerScriptService`)**:
    -   Handles business logic.
    -   Registers Network Listeners.
    -   Validates Input Types.
3.  **Controller (`StarterPlayer`)**:
    -   Manages Client State (Fusion).
    -   Mounts UI via `SafeLoader`.
    -   Manages Lifecycle via `Trove`.

### ⚠️ The "Anti-Decay" Rules

1.  **No Relative Paths:** `script.Parent` is banned. Use `Loader.Core("...")`.
2.  **Lune Automation:** Do not edit Core files manually. Use Lune scripts for surgical patches.
3.  **Smart Logs:** Use `ctx.Logger`. Do not use `print()`.

---

## 🐛 Debugging

The **SmartLogger** is your primary debugging tool.

-   **Visual Tree:** Logs are formatted as trees (`└──`) to show execution flow.
-   **Domain Icons:**
    -   🎒 = Inventory
    -   🔐 = Permission/Security
    -   💾 = DataStore
    -   🌐 = Networking
-   **Recovery:** If you see `❌ MountFailed`, check your API injection in `InventoryView`.

---

**Copyright © 2025 Omniverse Highland Studio.**
