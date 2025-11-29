--!strict
-- @Atom: Button v3.1 (Enterprise Standard)
-- @Role: Interactive Element with Configurable Anti-Spam
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Telemetry = Loader.Get("Telemetry")
local Style = Loader.Get("Style")
local Players = game:GetService("Players")
local UIConfig = require(RS.OVHL.Config.UISystemConfig) -- The Law

local e = React.createElement
local useState = React.useState

export type Props = { 
    Text: string, Variant: string?, Size: UDim2?, 
    OnClick: (() -> ())?, Disabled: boolean?, 
    Permission: number?, LayoutOrder: number?,
    
    -- [OPTIONAL] Override Global Default
    DebounceTime: number? 
}

return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("UX") end, {})
    
    local hover, setHover = useState(false)
    local press, setPress = useState(false)
    local locked, setLocked = useState(false) -- Internal Cooldown State
    
    local myRank = Players.LocalPlayer:GetAttribute("OVHL_Rank") or 0
    local isPermLocked = myRank < (props.Permission or 0)
    
    -- Tombol mati jika: Disabled Owner / Permision / Sedang Cooldown
    local isDisabled = props.Disabled or isPermLocked or locked

    -- Style Resolution
    local variant = props.Variant or "Primary"
    local palette = Style.Colors.Action[variant] or Style.Colors.Action.Primary
    local bgColor = palette.Default
    
    if props.Disabled or isPermLocked then bgColor = Style.Colors.Background.Surface 
    elseif locked then bgColor = palette.Press -- Visual Feedback: Tahan di warna 'Press' saat cooldown
    elseif press then bgColor = palette.Press 
    elseif hover then bgColor = palette.Hover end

    local function handleClick()
        if isPermLocked then 
            logger:Interact(props.Text, {Res="Denied", Rank=myRank}) 
            return 
        end
        
        -- The Shield: Blokir jika sedang cooldown
        if locked or props.Disabled then return end

        -- 1. Lock
        setLocked(true)
        logger:Interact(props.Text, "Click")
        
        -- 2. Execute
        if props.OnClick then task.spawn(props.OnClick) end
        
        -- 3. Determine Cooldown Time (Prop > Global Default)
        local cooldown = props.DebounceTime or UIConfig.Behavior.DefaultDebounce
        
        -- 4. Unlock after delay
        task.delay(cooldown, function()
            setLocked(false)
        end)
    end

    return e("TextButton", {
        Text = isPermLocked and "🔒 " .. props.Text or props.Text, 
        Font = Style.Fonts.Header, 
        TextSize = Style.TextSize.Body,
        TextColor3 = (isDisabled and not locked) and Style.Colors.Text.Muted or palette.Content, 
        
        Size = props.Size or UDim2.fromOffset(140, 44),
        BackgroundColor3 = bgColor, 
        
        -- Opacity Feedback: Agak transparan saat cooldown agar user 'merasakan' delay
        BackgroundTransparency = (variant == "Ghost" and not hover and not locked) and 1 or (locked and 0.2 or 0), 
        
        AutoButtonColor = false, 
        LayoutOrder = props.LayoutOrder,
        
        [React.Event.Activated] = handleClick,
        [React.Event.MouseEnter] = function() if not isDisabled then setHover(true) end end,
        [React.Event.MouseLeave] = function() setHover(false); setPress(false) end,
        [React.Event.MouseButton1Down] = function() if not isDisabled then setPress(true) end end,
        [React.Event.MouseButton1Up] = function() setPress(false) end
    }, { 
        Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Medium }), 
        Padding = e("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4) }) 
    })
end
