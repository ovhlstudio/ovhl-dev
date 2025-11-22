-- @Lune: Phase 9 Surgical Fix
-- @Target: API.luau (Inject Missing Themer)
-- @Method: Read-Modify-Write (No Overwrite)
-- @Strictness: MAX

local fs = require("@lune/fs")
local stdio = require("@lune/stdio")

local TARGET_PATH = "src/ReplicatedStorage/OVHL/UI/Foundation/API.luau"
local MISSING_KEY = "API.Themer"
local INJECTION_PAYLOAD = "API.Themer = Onyx.Themer"
local ANCHOR_PATTERN = "API%.Onyx%s*=%s*Onyx" -- Mencari baris: API.Onyx = Onyx

local function log(emoji, msg)
	stdio.write(string.format("%s %s\n", emoji, msg))
end

log("🔍", "STARTING SURGICAL OPERATION ON API.LUAU...")

-- 1. VERIFIKASI FILE
if not fs.isFile(TARGET_PATH) then
	log("❌", "CRITICAL: File not found! " .. TARGET_PATH)
	process.exit(1)
end

-- 2. BACA KONTEN ASLI (READ)
local content = fs.readFile(TARGET_PATH)
local originalSize = #content

-- 3. CEK KEBERADAAN (ANTI-DUPLIKASI)
if content:find(MISSING_KEY, 1, true) then
	log("✅", "API.Themer already exists. Operation aborted to prevent duplication.")
	return
end

-- 4. OPERASI SUNTIK (INJECT)
-- Kita cari definisi API.Onyx, lalu selipkan API.Themer di bawahnya.
local newContent, count = content:gsub(ANCHOR_PATTERN, "%0\n" .. INJECTION_PAYLOAD)

if count == 0 then
	log("❌", "FAILED: Could not find anchor point (" .. ANCHOR_PATTERN .. ").")
	log("ℹ️", "Cannot inject safely. Please check file structure.")
	process.exit(1)
end

-- 5. VERIFIKASI INTEGRITAS (CHECK SIZE)
if #newContent <= originalSize then
	log("⚠️", "WARNING: Content size did not increase. Injection might have failed.")
	process.exit(1)
end

-- 6. SIMPAN PERUBAHAN (WRITE)
fs.writeFile(TARGET_PATH, newContent)

log("💉", "INJECTION SUCCESSFUL.")
log("📝", "Added: " .. INJECTION_PAYLOAD)
log("📂", "File preserved: " .. TARGET_PATH)
