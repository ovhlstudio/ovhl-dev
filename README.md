# 🪐 OVHL: The Enterprise Monorepo

![Luau](https://img.shields.io/badge/Luau-00a2ff?style=for-the-badge&logo=lua&logoColor=white)
![Rojo](https://img.shields.io/badge/Rojo-722206?style=for-the-badge&logo=roblox&logoColor=white)
![Wally](https://img.shields.io/badge/Wally-ad4646?style=for-the-badge&logo=npm&logoColor=white)
![Lune](https://img.shields.io/badge/Lune-Automation-blueviolet?style=for-the-badge)
![Status](https://img.shields.io/badge/Architecture-Enterprise_Grade-success?style=for-the-badge)

> **"Logic without Assumption. Structure without Decay."**

**OVHL (Omniverse Highland)** is a strict, opinionated, and high-performance framework designed for scalable Roblox development. It enforces a rigid architectural separation between Logic, State, and View, utilizing a custom Kernel and a Paranoid Security Layer.

---

## 🏗️ The Ecosystem

This repository is a **Monorepo** managed via [Rokit](https://github.com/rojo-rbx/rokit).

```text
OMNIVERSE-DEV/
├── 📂 ovhl-framework/      # The Core Roblox Game Framework (Lua/Luau)
│   ├── 📦 Packages/        # Managed by Wally (Fusion, OnyxUI, ProfileService)
│   └── 🧠 src/             # Source Code (Kernel, Modules, UI Foundation)
├── 📂 ovhl-tools/          # CLI & SDK Tools (Node/Rust/Lune Scripts)
└── 📄 rokit.toml           # Toolchain Manager (Aftman successor)
```

---

## 🌟 Key Architecture

### 1. The Hybrid UI Engine (Fusion 0.3 + Onyx)

We do not write UI; we **compose** it.

-   **API Gateway:** All Views consume a centralized `Loader.UI("Foundation/API")`.
-   **Explicit Construction:** `UI.New(scope, "Class")` prevents scope inheritance leaks.
-   **Data-Driven Layouts:** Switch between `Grid` or `List` layouts purely via Config, without touching code.

### 2. Paranoid Security Layer

We assume every remote call is an attack.

-   **NetworkGuard:** Recursively sanitizes inbound data (strips Instances, checks depth).
-   **RateLimiter:** Token-bucket algorithm per player/endpoint.
-   **Smart Redaction:** Outbound logs automatically mask keys like `Token` or `Secret`.

### 3. The Smart Kernel & Loader

-   **Case-Insensitive Resolution:** The Loader finds `profileservice` even if you ask for `ProfileService`.
-   **Auto-Discovery:** The Kernel scans `Service.luau` files and registers them as `[Feature]Service` to prevent naming collisions.
-   **Telemetry:** `SmartLogger` visualizes execution flow with tree structures (`└──`) and domain-specific icons (🎒, 🔐, 💾).

---

## ⚡ Quick Start

### Prerequisites

Ensure you have [Rokit](https://github.com/rojo-rbx/rokit) installed.

```bash
# 1. Initialize Toolchain
rokit install

# 2. Install Dependencies (Wally)
cd ovhl-framework
wally install

# 3. Build/Serve
rojo serve
```

---

## 📜 Development Constitution

Contributors (and AI Agents) must adhere to the **OVHL Codex**:

1.  **Lune Protocol:** NEVER edit files manually. Use Lune scripts for surgical patches to ensure integrity.
2.  **No Relative Paths:** `script.Parent` is banned. Use `Loader.Core(...)`.
3.  **Strict DI:** No Globals (`_G`). Dependencies are injected via `Init(ctx)`.
4.  **Log-Driven Debugging:** Read the `SmartLogger` output before fixing bugs. The log _is_ the documentation.

---

## 🗺️ Roadmap

-   [x] **Foundation:** Loader, Context, API Gateway.
-   [x] **Core:** SmartLogger, Network Bridge.
-   [x] **Refactor:** Inventory Module (Gold Standard).
-   [ ] **Security:** Implement Token Bucket RateLimiter logic.
-   [ ] **Tools:** CLI for auto-generating Modules.
-   [ ] **Release:** Public Distribution.

---

**Copyright © 2025 Omniverse Highland Studio.**
_Built for stability. Engineered for scale._
