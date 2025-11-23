--!strict
return {
    DefaultLevel = "DEBUG", -- [FIX] Ganti dari INFO ke DEBUG agar semua narasi muncul
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
        
        -- UI Domains (Telemetry)
        UX             = "👆 UX",
        USER_INTERFACE = "🎨 UI",
        TOPBAR         = "🔘 TOPBAR",
        
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
