--!strict
-- @Config: UISystemConfig
-- @Role: Single Source of Truth for Behavior, Motion & Layers
-- @Standard: Enterprise Design Tokens

return {
    -- Global Behavior
    Behavior = {
        ScaleLocked = false,
        BaseResolution = Vector2.new(1920, 1080),
        
        -- [NEW] Standar Global anti double-click.
        -- Cukup cepat agar tidak mengganggu, cukup lambat agar tidak glitch.
        DefaultDebounce = 0.2 
    },

    -- Typography Tokens
    Typography = {
        H1 = { Size = 32, Font = Enum.Font.GothamBold },
        H2 = { Size = 24, Font = Enum.Font.GothamBold },
        Header = { Size = 20, Font = Enum.Font.GothamBold },
        Body = { Size = 16, Font = Enum.Font.GothamMedium },
        Caption = { Size = 14, Font = Enum.Font.Gotham },
        Small = { Size = 12, Font = Enum.Font.Gotham },
    },

    -- Motion Presets
    Motion = {
        WindowEntrance = "Bouncy", WindowExit = "Stiff",
        ModalEntrance = "Snappy", ModalExit = "Snappy",
        ToastEntrance = "Bouncy", ToastExit = "Smooth",
        Hover = "Snappy"
    },

    -- Z-Index Layers
    ZIndex = {
        Base = 1, Window = 10, Dropdown = 50,
        Modal = 100, Toast = 1000, Cursor = 9999
    }
}
