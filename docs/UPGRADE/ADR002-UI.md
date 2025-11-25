Siap, **Commander**.

Ini adalah dokumen **ADR (Architecture Decision Record)** yang vital. Dokumen ini berfungsi sebagai **"Kitab Suci"** bagi sesi AI berikutnya (atau developer manusia) agar tidak ada konteks yang hilang, tidak ada _reinventing the wheel_, dan tidak ada pelanggaran standar yang sudah kita tetapkan dengan susah payah.

Silakan simpan dokumen ini di root folder dokumentasi project Anda (misal: `docs/ADR-002_UI_DesignSystem.md`).

---

# 📄 ADR-002: OVHL ENTERPRISE DESIGN SYSTEM & UI ARCHITECTURE

**Status:** 🟢 ACCEPTED / IN-PROGRESS
**Date:** 2025-11-25
**Context:** OVHL Framework v0.2.x -> v0.3.0
**Author:** Gemini Principal Engineer (Session ID: OVHL-ARCH-02)

---

## 1. KONTEKS & PERMASALAHAN (CONTEXT)

### 1.1 Latar Belakang

Setelah pembenahan Core & Network, fokus beralih ke **User Interface (UI)**. Saat ini, pengembangan UI masih bersifat _ad-hoc_ (dibuat saat butuh). Hal ini menyebabkan:

1.  **Fragmentasi Visual:** Inkonsistensi ukuran, warna, dan animasi antar modul.
2.  **Isu UX Kritis:** Ditemukan bug _"Phantom Click-Through"_ dimana klik pada window tembus ke tombol di belakangnya karena manajemen `Active` property yang buruk pada `CanvasGroup`.
3.  **Hardcoding:** Banyak nilai posisi (`UDim2`) dan warna yang di-hardcode di dalam View, menyulitkan perubahan tema global.
4.  **Kurangnya Standarisasi Layout:** Belum ada helper untuk posisi (Grid 9 Titik), menyebabkan perhitungan pixel manual yang rentan salah.

### 1.2 Tujuan

Membangun **OVHL Design System** yang terpusat, reusable, dan _config-driven_. Setiap modul (Inventory, Shop, Admin) **DILARANG** membuat komponen dasar sendiri. Mereka wajib mengambil dari `UI/Foundation`.

---

## 2. KEPUTUSAN ARSITEKTUR (DECISIONS)

### 2.1 Single Source of Truth (Theme & Config)

-   **Visual:** `OVHLTheme.luau` adalah satu-satunya sumber warna, font, radius, dan spacing. Dilarang hardcode Hex Color di View.
-   **Behavior:** Logika UI (seperti durasi toast, kecepatan animasi) akan diatur oleh Config terpusat atau Config per-modul yang mematuhi skema global.

### 2.2 Pattern: "Input Sink" Separation (CRITICAL FIX)

Berdasarkan investigasi bug `SmartWindow`, ditetapkan standar baru untuk Container/Window:

-   **Masalah:** `CanvasGroup` dengan `Active=true` di Roblox Studio sering menyebabkan glitch kursor (berubah jadi tangan) atau hit-box yang tidak akurat.
-   **Solusi:** Pisahkan layer **Visual** dan **Fisika**.
    -   Layer 1 (Belakang): **`InputSink`** (`Frame`, Transparency=1, `Active=true`, ZIndex=1). Bertugas murni memblokir raycast mouse.
    -   Layer 2 (Depan): **`Canvas`** (`CanvasGroup`, `Active=false`, ZIndex=2). Bertugas murni rendering visual (ClipDescendants).

### 2.3 Centralized Notification System (Pub/Sub)

-   Menggunakan pola **Publish-Subscribe** via `Signals` (`App:Notify`).
-   Controller Module tidak boleh membuat UI notifikasi sendiri. Mereka hanya boleh mem-fire signal data: `{ Type, Msg, Duration }`.
-   `NotificationController` bertugas me-render tumpukan pesan (Stacking) dengan batasan Max Item (mencegah spam visual).

---

## 3. SPESIFIKASI TEKNIS (TECHNICAL SPECS)

Bagi AI/Developer selanjutnya, berikut adalah komponen yang **SUDAH ADA** dan **AKAN DIBUAT**.

### 3.1 Foundation (Existing & Must Use)

Lokasi: `src/ReplicatedStorage/OVHL/UI/Foundation`

| Komponen            | Fungsi & Aturan Pakai                                                                                  | Status    |
| :------------------ | :----------------------------------------------------------------------------------------------------- | :-------- |
| **`API.luau`**      | Entry point Fusion & Components. Wajib pakai `Loader.Get("API")`.                                      | ✅ Active |
| **`Layout.luau`**   | **[BARU]** Helper posisi 9 titik (TopLeft, Center, BottomRight). Gantikan `UDim2.new` manual.          | ✅ Active |
| **`ActionGuard`**   | **[UPDATED]** Gatekeeper logika. Wajib pakai `self:SafeRun` di Controller. Mendukung ID Unik per item. | ✅ Active |
| **`MotionPresets`** | Standar animasi (`Slide`, `PopUp`). Jangan buat Spring manual di View.                                 | ✅ Active |

### 3.2 Components Library (The Building Blocks)

Lokasi: `src/ReplicatedStorage/OVHL/UI/Foundation/Components`

| Komponen               | Deskripsi Teknis                                                                                                        | Status      |
| :--------------------- | :---------------------------------------------------------------------------------------------------------------------- | :---------- |
| **`SmartWindow`**      | Window standar dengan Header & Close Button. Sudah menerapkan **Input Sink Separation**.                                | ✅ Fixed    |
| **`ModalWrapper`**     | **[BARU]** Overlay layar penuh (Hitam Transparan) untuk memblokir input global saat Dialog muncul. Wajib `Active=true`. | ✅ Active   |
| **`SmartText`**        | Label teks yang otomatis mengikuti Font Theme. Mendukung `Variant` (Header/Body/Caption).                               | ✅ Active   |
| **`NotificationView`** | Render engine untuk Toast. Sudah menerapkan **Defensive Programming** (Fallback jika Theme nil).                        | ✅ Active   |
| **`SmartFrame`**       | Container dasar dengan Theme otomatis (Background, Border).                                                             | 🚧 **TODO** |
| **`TabBar`**           | Navigasi horizontal/vertikal untuk menu tab.                                                                            | 🚧 **TODO** |

---

## 4. STRATEGI IMPLEMENTASI (ROADMAP)

### Fase 1: Hardening & Standardization (DONE)

-   [x] Refactor `SmartWindow` untuk memperbaiki bug klik tembus.
-   [x] Implementasi `Layout.luau` untuk posisi Grid.
-   [x] Implementasi `NotificationSystem` (Controller + View).
-   [x] Hardening `NotificationView` dengan fallback values (Anti-Crash).

### Fase 2: Reusable Component Expansion (NEXT)

-   [ ] Membuat `SmartFrame`.
-   [ ] Refactor `ConfirmationDialog` (Admin Panel) agar menggunakan `ModalWrapper` standar (bukan hardcode frame sendiri).
-   [ ] Membuat `SystemUIController` untuk mengelola dialog global (Alert, Confirm, Prompt).

### Fase 3: Developer Tools (FUTURE)

-   [ ] Membuat `DevTools` (Rank 5 Only) sebagai "Kitchen Sink" / Showcase untuk mengetes semua komponen UI tanpa harus memicu gameplay.

---

## 5. ATURAN KEPATUHAN (COMPLIANCE RULES)

**HARAM (STRICTLY PROHIBITED):**

1.  **Haram Hardcode Dimensi/Warna:** Jangan ketik `Color3.fromRGB(255,0,0)`. Gunakan `UI.Theme.Colors.Error.Main`.
2.  **Haram Bypass `ScreenWrapper`:** Semua Root UI View wajib dibungkus `ScreenWrapper` agar fitur AutoScale bekerja.
3.  **Haram `Active=true` di CanvasGroup:** Gunakan pola "Input Sink" (Frame terpisah) jika butuh interaksi mouse pada area kompleks.
4.  **Haram Notifikasi Lokal:** Jangan buat `Frame` notifikasi di dalam View modul. Kirim Signal ke `NotificationController`.

**KEWAJIBAN (MANDATORY):**

1.  **Config-Driven:** View harus menerima `props.Config`. Jika config kosong, wajib punya nilai **DEFAULT/FALLBACK** agar tidak crash.
2.  **Telemetry:** Gunakan `UXLogger` untuk mencatat kapan UI penting muncul/diklik.
3.  **SafeRun:** Controller wajib menggunakan `self:SafeRun` atau `self:SafeRunEx` untuk aksi yang mengubah data.

---

## 6. CATATAN KHUSUS UNTUK NEXT AI (CONTEXT HANDOVER)

> _"Halo AI Penerus. Anda sedang bekerja pada Framework OVHL v0.3.0. Sistem ini baru saja melalui refactoring besar-besaran."_

**Poin Kritis yang Perlu Diketahui:**

1.  **Loader System:** Menggunakan Strict Caching. Jangan pakai `Loader.Get("NamaSalah")`, itu akan error fatal. Cek `Loader.luau` untuk Alias.
2.  **UI System:** Kami baru saja memperbaiki bug engine Roblox terkait `CanvasGroup`. **JANGAN MENGUBAH STRUKTUR `SmartWindow`** kembali menjadi satu layer, karena itu akan mengembalikan bug "Cursor Tangan".
3.  **Networking:** Menggunakan Single Gateway (`Bridge`). Jangan buat `RemoteEvent` manual di folder. Gunakan `Bridge:Register`.
4.  **Data Flow:** `Action` -> `Guard (Client)` -> `Bridge` -> `Server Guard` -> `Mutex` -> `Logic`. Jangan bypass urutan ini.

**Tugas Anda Selanjutnya:**
Fokus pada **Fase 2 (Expansion)**. Mulailah dengan membuat komponen `SmartFrame` atau me-refactor `ConfirmationDialog` agar menggunakan `ModalWrapper`.

_Good luck. Keep it Enterprise._

---

_End of ADR-002_

KEBUTUHAN KOMPONEN STANDAR (DAFTAR BELANJA)
Untuk mencapai level "Enterprise Design System", folder UI/Foundation/Components kita masih kurang lengkap. Saat ini kita baru punya SmartText dan AsyncButton.
Berikut adalah Komponen Wajib yang harus kita bangun satu per satu:
Kategori Nama Komponen Fungsi Status Saat Ini
Container SmartFrame Frame dasar dengan Theme (Background, Corner, Stroke) otomatis. ❌ Belum Ada
Input SmartInput Kotak ketik (TextBox) dengan placeholder, focus state, dan error message. ❌ Belum Ada
Feedback Badge Lingkaran merah kecil (misal: notif jumlah item). ❌ Belum Ada
Navigation TabBar Tombol navigasi atas (Inventory Stats
Overlay ModalWrapper Layar hitam transparan untuk popup penting (seperti ConfirmationDialog kemarin). ⚠️ Hardcode
Utility Divider Garis pemisah tipis antar konten. ❌ Belum Ada
Layout Layout (Module) Helper posisi (9 Titik) yang Anda minta. ❌ Belum Ada 4. STRATEGI KONFIGURASI (CONFIG VS THEME)
Anda bertanya tentang UISystemConfig. Ini cara membaginya agar rapi:
OVHLTheme.luau (VISUAL): Mengatur "Kecantikan".
Warna, Font, Spacing, Radius, Ketebalan Garis.
Contoh: "Tombol Danger warnanya Merah".
UISystemConfig.luau (BEHAVIOR): Mengatur "Perilaku".
Kecepatan animasi (0.5s vs 0.2s).
Durasi Toast (3 detik).
Default Posisi Notifikasi (Pojok Kanan Bawah).
Suara (Sound ID untuk klik tombol).
