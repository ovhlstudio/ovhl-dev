# 📘 OVHL FRAMEWORK

**Master Technical Blueprint v0.1.0**
_Standardized Single Script Architecture for Robust Roblox Development_

---

## 1. Rangkuman Singkat (Overview)

### Identitas Project

**OVHL (Omniverse Highland Studio) Framework** adalah sebuah arsitektur pengembangan game Roblox berbasis **Single Script Architecture (SSA)**. Framework ini saat ini berada di versi **v0.1.0 (Alpha/Foundation)**.

### Latar Belakang & Visi

Framework ini lahir dari inisiatif seorang _Solo Developer_ yang menghadapi tantangan dalam manajemen proyek skala besar. Visi utamanya adalah **Demokratisasi Arsitektur Robust**:

1.  **Membantu Developer Awam:** Menyediakan struktur yang "siap pakai" (_Plug and Play_) sehingga developer baru tidak perlu memikirkan cara membuat sistem core, melainkan langsung fokus pada konten game.
2.  **AI Alignment Strategy:** Menjadi standar baku bagi _AI Coding Assistant_. AI seringkali "teledor" dalam hal manajemen _path_ dan struktur file. Dengan framework ini, AI dipaksa mengikuti jalur yang aman dan terstandarisasi.

### Core Concept

OVHL bukan sekadar kumpulan library, melainkan ekosistem terintegrasi yang mengatur:

-   Bagaimana kode dimuat (**Loader**).
-   Bagaimana data dikirim (**Bridge & Guard**).
-   Bagaimana UI ditampilkan dengan aman (**SafeLoader**).
-   Bagaimana data disimpan (**Profile Wrapper**).

---

## 2. Filosofi Desain (Design Philosophy)

Pondasi mental model framework ini dibangun di atas 4 pilar yang tidak boleh dilanggar:

### A. Observability as AI's Vision (Mata & Telinga AI)

AI itu canggih tapi "buta". Dia tidak tahu apa yang sebenarnya terjadi di layar Studio.

-   **Masalah:** Seringkali kode berjalan tanpa error, tapi UI tidak muncul atau data tidak tersimpan, dan AI menganggap itu "sukses".
-   **Aturan Mutlak:** Level log **DEBUG** wajib **VERBOSE**.
-   **Implementasi:** Sistem harus "berisik" secara terstruktur. Setiap mounting UI, setiap kalkulasi ukuran window, setiap klik tombol, dan setiap perubahan state data harus dicatat oleh `SmartLogger`. Ini memberikan feedback loop bagi developer (dan AI) untuk memverifikasi logika.

### B. AI-Proof Pathing (Anti-Spaghetti)

Menghilangkan kebiasaan buruk menggunakan referensi file relatif yang rapuh.

-   **Masalah:** Penggunaan `script.Parent.Parent.Parent` sangat rentan rusak jika struktur folder diubah.
-   **Aturan Mutlak:** Dilarang menggunakan _Relative Path_ untuk modul sistem.
-   **Solusi:** Menggunakan **Centralized Loader**. Pemanggilan modul wajib menggunakan alias (contoh: `Loader.Get("InventoryService")`). Jika file dipindah, kode tidak perlu diubah, cukup update registry di Loader.

### C. Zero Trust Networking (Security First)

Framework mengasumsikan Client (Pemain) adalah entitas yang tidak bisa dipercaya dan berpotensi memanipulasi data.

-   **Aturan Mutlak:** Dilarang membuat `RemoteEvent` atau `RemoteFunction` secara manual.
-   **Solusi:** Komunikasi WAJIB melalui **NetworkBridge**. Setiap paket data yang masuk akan dicegat, disanitasi, dan divalidasi oleh **NetworkGuard** sebelum diizinkan menyentuh logika Server.

### D. Fail-Safe Engineering (Crash Proof)

Kegagalan pada satu fitur kecil tidak boleh menyebabkan fatal error pada seluruh game.

-   **Aturan Mutlak:** UI Error harus terisolasi.
-   **Solusi:** Penerapan `SafeLoader` (Error Boundary) pada UI dan pembungkusan lifecycle `Init/Start` dengan `pcall`. Jika Inventory gagal loading, pemain harus tetap bisa berjalan dan berinteraksi dengan dunia game.

---

## 3. Arsitektur Fundamental (Core Architecture)

Sistem ini menggunakan pola terpusat. Tidak ada script yang berjalan liar di dalam Workspace.

### 3.1 The Bootstrapper (Pemicu)

Hanya ada dua entry point dalam game:

1.  **ServerRuntime:** `require(OVHL.Bootstrap).StartServer()`
2.  **ClientRuntime:** `require(OVHL.Bootstrap).StartClient()`
    Tugasnya hanya satu: Membangunkan Kernel.

### 3.2 The Kernel (Otak Sistem)

Kernel (`ServerKernel` & `ClientKernel`) bertugas melakukan manajemen otomatis:

-   **Auto-Discovery:** Kernel memindai folder `Services`, `Controllers`, dan `Modules` (untuk fitur modular).
-   **Dependency Injection (DI):** Kernel membuat `Context` (`ctx`). Semua Service dimasukkan ke dalam `ctx` ini.
    -   _Manfaat:_ Menghilangkan _Circular Dependency_. Service A bisa memanggil `ctx.ServiceB` tanpa `require` di atas file.

### 3.3 Lifecycle Pipeline (Alur Deterministik)

Untuk mencegah _Race Condition_ (balapan eksekusi kode), framework membagi waktu loading:

1.  **Loader Scan:** Mendaftarkan semua file.
2.  **Phase 1: Init(ctx):**
    -   Tempat setup event listener, load Config, dan deklarasi variable.
    -   Akses ke `ctx` sudah tersedia, tapi Service lain mungkin belum siap.
3.  **Phase 2: Start():**
    -   Dijalankan hanya setelah SEMUA modul selesai Init.
    -   Tempat menjalankan game loop, memunculkan UI awal, dan interaksi antar-service.

### 3.4 Framework Factory (Standardizer)

Fitur _Plug-and-Play_ untuk mempercepat development. Saat developer membuat Controller via `Framework.CreateController`, sistem otomatis menyuntikkan properti vital:

-   `self.Logger`: Instance SmartLogger sesuai nama modul.
-   `self.Bridge`: Akses jalur networking.
-   `self.Config`: Otomatis me-load `SharedConfig` dari folder modul terkait.
-   `self.Trove`: Wadah sampah otomatis (_Maid Pattern_) untuk membersihkan koneksi/memory.
-   `self.Guard`: Akses ke ActionGuard untuk proteksi UI.

---

## 4. Ekosistem Jaringan & Keamanan (Networking & Security)

### 4.1 The Bridge (Virtual Networking)

Sistem ini meniadakan pembuatan RemoteEvent manual.

-   **Konsep:** Developer mendefinisikan "Rute" di `SharedConfig` (misal: `Request: { Equip = {...} }`).
-   **Automation:** Saat server start, Framework membaca config ini dan membuat jalur komunikasi fisik secara dinamis.
-   **Usage:** Client cukup panggil `self.Bridge:Request("Inventory", "Equip", itemId)`.

### 4.2 Network Guard (The Firewall)

Layer keamanan yang berjalan otomatis di tengah Bridge:

1.  **Instance Blocking:** Otomatis menolak argumen berupa `Instance` (Part/GUI) dari Client untuk mencegah exploit manipulasi map.
2.  **String Sanitization:** Memotong string input yang melebihi 2048 karakter.
3.  **Recursion Limit:** Mencegah crash server akibat pengiriman table nested yang terlalu dalam (DoS attack).
4.  **Sensitive Data Redaction:** Menyensor kata kunci seperti "token", "key", "pass" dari log sistem.

### 4.3 Contract Validation (Runtime Type Checking)

-   **Sistem:** Menggunakan modul `TypeValidator`.
-   **Cara Kerja:** Membandingkan input pemain dengan kontrak di `SharedConfig`.
    -   _Kontrak:_ `Args = { { name="id", type="string" } }`
    -   _Input:_ `123` (Number)
    -   _Hasil:_ Request ditolak (`400 Bad Request`) sebelum masuk fungsi Server.

### 4.4 Traffic Control (Anti-Spam)

-   **Rate Limiter:** Menggunakan algoritma _Token Bucket_. Membatasi frekuensi request per-pemain per-fungsi.
-   **Middleware:** Mendukung pemasangan filter logika (misal: `AdminOnly`) di jalur komunikasi.

---

## 5. Antarmuka & UX Foundation (UI/UX System)

### 5.1 Fail-Safe Rendering (SafeLoader)

-   **Masalah:** Satu error pada logic UI (misal: data `nil`) sering membuat seluruh ScreenGui gagal render (_White Screen_).
-   **Solusi:** `SafeLoader` membungkus fungsi render dalam `xpcall`. Jika error, ia me-return komponen fallback (**Red Error Box**) hanya pada bagian yang rusak, disertai pesan debug visual.

### 5.2 User Experience Guardians

-   **ActionGuard:** Sistem sentral untuk proteksi interaksi.
    -   **Auto Debounce:** Mencegah klik ganda yang tidak sengaja.
    -   **Global Confirmation:** Menangani alur "Are you sure?" secara terpusat. Controller cukup kirim sinyal, System UI yang menampilkan popup.
-   **AsyncButton:** Komponen tombol pintar yang terintegrasi dengan **Telemetry** (mencatat kapan diklik, kapan loading selesai).

### 5.3 Robust Element Finder

-   **FinderService:** Solusi cerdas pencarian elemen UI.
-   **Strategi:** Mencari berdasarkan urutan prioritas: **Attribute** -> **CollectionTag** -> **Instance Name**. Ini membuat kode UI tahan banting meskipun artist mengubah hierarki folder di Explorer.

### 5.4 Centralized Design System

-   **OVHL Theme:** _Single Source of Truth_ untuk desain (Warna, Font, Radius). Mendukung pergantian tema global.
-   **Asset Registry (`Assets.luau`):** Sentralisasi ID aset. Tidak ada lagi _magic string_ ID gambar di dalam kode logika.
-   **Helper Utils:** Modul `Util.luau` untuk konversi Font dan normalisasi Asset ID.

---

## 6. Integritas & Penyimpanan Data (Data Persistence)

### 6.1 Data Manager (Wrapper)

Menggunakan **ProfileService** dengan lapisan keamanan tambahan:

-   **Session Locking:** Menjamin data pemain hanya aktif di satu server pada satu waktu (Anti-Dupe).
-   **Critical Kick:** Jika data gagal dimuat, pemain di-kick dengan pesan jelas. Ini pengaman vital agar data kosong tidak menimpa data asli saat _Auto-Save_.
-   **Mock Support:** Otomatis mendeteksi lingkungan Studio dan menggunakan penyimpanan RAM (Mock) agar tidak mengotori database produksi.

### 6.2 Schema Evolution (Data Migrator)

-   **Masalah:** Perubahan fitur game seringkali mengubah struktur data save.
-   **Solusi:** `DataMigrator` mengecek versi data (`_SchemaVersion`) saat pemain join.
-   **Logic:** Jika versi data pemain tertinggal (misal v1, server v3), sistem menjalankan skrip migrasi secara berurutan (v1->v2, v2->v3) untuk memutakhirkan format data tanpa menghapus progress pemain.

---

## 7. Showcase Implementasi (Proof of Concept)

### Case Study 1: Permission System (Hybrid Adapter)

Contoh penerapan prinsip **Modularitas**.

-   **Logika:** `PermissionService` hanya butuh tahu "Rank Pemain".
-   **Adapter:** Data bisa bersumber dari **HDAdmin** (Library External) atau **InternalDB** (Custom DataStore).
-   **Config:** Pilihan sumber data diatur via `PermissionConfig.luau`, tanpa menyentuh kode service.

### Case Study 2: Inventory System (Full Stack Flow)

Contoh penerapan **Zero Trust** dan **Safety**:

1.  **Config:** Developer mendefinisikan endpoint `Equip` di `SharedConfig`.
2.  **Network:** Framework membuat jalur virtual.
3.  **Client:** Controller memanggil via Bridge.
4.  **Security:** Request dicegat **RateLimiter** (cek spam) dan **Validator** (cek tipe data).
5.  **UI:** Item ditampilkan menggunakan **SafeLoader** (cegah crash jika icon item error).

---

## 8. Pengalaman Pengembang (DX) & Tooling

### 8.1 Automated Testing

Framework terintegrasi dengan **TestEZ**.

-   **Runners:** Script `TestRunner` tersedia di Server dan Client.
-   **Workflow:** Saat Studio berjalan, tes otomatis dieksekusi. Jika ada logika core yang rusak, Console akan memberikan peringatan dini.

### 8.2 Config Integrity

-   **Schema Validation:** Modul `ConfigSchema` memvalidasi setiap file konfigurasi yang dimuat. Menjamin field wajib (seperti `Meta`, `Version`) selalu ada untuk mencegah _Runtime Error_ konyol.

### 8.3 Luau Type System

File `FrameworkTypes.luau` menyediakan definisi tipe (`export type`) untuk Service, Context, dan Logger. Ini mengaktifkan fitur _Intellisense/Autocomplete_ di code editor, sangat membantu developer baru memahami API framework.

---

## 9. Tech Stack & Environment Setup

OVHL mewajibkan penggunaan **External Workflow** modern untuk manajemen kode:

### The Toolchain (Wajib Install)

1.  **Rokit:** Manajer versi tools (menjamin setiap developer di tim menggunakan versi tools yang sama).
2.  **Rojo:** Sinkronisasi file sistem (VS Code) ke Roblox Studio.
3.  **Visual Studio Code:** IDE utama dengan ekstensi **Luau LSP**.
4.  **Git/GitHub:** Version Control System.

### Core Dependencies (Wally Packages)

Framework ini dibangun di atas raksasa:

-   **Fusion & Onyx UI:** Untuk UI Reaktif dan Komponen Standar.
-   **ProfileService:** Standar industri untuk DataStore aman.
-   **Trove:** Manajemen memori (Cleanup) untuk mencegah kebocoran memori.
-   **Promise:** Penanganan logika _asynchronous_.
-   **TestEZ:** Framework unit testing.

---

## 10. Konsultasi Teknis (Principal & Senior Dev Review)

Berikut adalah daftar pertanyaan strategis yang dirancang untuk memvalidasi arsitektur OVHL v0.1.0 dan meminta arahan roadmap teknis menuju standar Enterprise:

1.  **Scalability of "The Bridge" (Single Remote Architecture)**
    _"Saat ini seluruh traffic networking (Inventory, Combat, Data) melalui satu pipa utama (`NetworkBridge`). Untuk game dengan concurrent user tinggi (100+ pemain) dan frekuensi event cepat (misal: spam skill/combat), apakah arsitektur Single Remote ini berisiko menjadi bottleneck network? Apakah perlu strategi 'Sharding' (memisahkan remote combat vs remote data) di level Framework?"_

2.  **Lifecycle & Automatic Memory Management**
    _"Di fase `Shutdown`, saya belum menerapkan cleanup yang agresif di level Kernel. Saat ini Controller hanya punya `Init` dan `Start`. Seberapa krusial penerapan `Deinit/Destroy` otomatis (misal: auto-destroy `self.Trove` saat Controller dimatikan) untuk mencegah Memory Leak jangka panjang di sesi server yang berjalan berhari-hari?"_

3.  **Strict Typing vs. Dependency Injection (DX Trade-off)**
    _"Kami menggunakan `Context` (DI Container) untuk memutus ketergantungan antar-module (`require` hell). Namun, kelemahannya adalah Luau LSP (Intellisense) sulit mendeteksi method di dalam `ctx` secara otomatis tanpa casting tipe manual. Apakah ada design pattern lain di industri Roblox yang menyeimbangkan antara 'Loose Coupling' dengan 'Strict Typing' yang lebih baik?"_

4.  **Production Observability (Beyond Console Log)**
    _"Filosofi kami adalah 'No Blind Logic' dengan `SmartLogger` yang verbose. Namun saat ini log hanya lari ke Output Console. Untuk standar Enterprise, tool eksternal apa yang wajib diintegrasikan untuk memantau error di live server? (Apakah perlu integrasi ke Sentry, GameAnalytics, atau Google Analytics via HttpService?)"_

5.  **Missing Foundational Layers (Architectural Roadmap)**
    _"Saat ini OVHL memiliki layer Core, Network, dan UI. Untuk membangun game yang kompleks, **Pondasi atau Service apa lagi yang WAJIB dibangun secara native di framework ini?** (Misalnya: Apakah saya perlu membangun Layer State Replication sendiri seperti ReplicaService? Atau perlu native support untuk Entity Component System (ECS)? Atau CLI bawaan?)"_

6.  **"Enterprise Grade" Assessment**
    _"Melihat struktur snapshot saat ini (SSA, Guard, Config-Driven), jika Anda harus memberi nilai 'Readiness' dari 1-10 untuk masuk ke tahap Produksi game Mid-Core, berapa nilainya? Dan apa **satu hal fatal** yang harus saya perbaiki hari ini juga?"_

---
