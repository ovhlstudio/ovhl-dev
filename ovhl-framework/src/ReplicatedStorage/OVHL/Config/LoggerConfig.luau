--!strict
-- @Config: LoggerConfig
-- @Role: Central Logging Rules
local RunService = game:GetService("RunService")

-- [SMART CONFIG]
local MANUAL_OVERRIDE: string? = nil 
local AUTO_LEVEL = RunService:IsStudio() and "DEBUG" or "INFO"

return {
    DefaultLevel = MANUAL_OVERRIDE or AUTO_LEVEL,
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    Domains = {
        SYSTEM      = "⚙️ SYSTEM",
        NETWORK     = "🌐 NETWORK", 
        SECURITY    = "🔐 SECURITY",
        DATA        = "💾 DATA",
        INVENTORY   = "🎒 INVENTORY",
        SHOP        = "🏪 SHOP", 
        ADMIN       = "👑 ADMIN",
        PERMISSION  = "🔐 PERMISSION",
        TEST        = "🧪 TEST",
        UX             = "👆 UX",
        USER_INTERFACE = "🎨 UI",
        DEFAULT     = "📦 GENERAL"
    },

    Levels = {
        DEBUG    = { Weight=1, Icon="🔍" },
        INFO     = { Weight=2, Icon="ℹ️" },
        WARN     = { Weight=3, Icon="⚠️" },
        ERROR    = { Weight=4, Icon="❌" },
        CRITICAL = { Weight=5, Icon="💀" }
    }
}
