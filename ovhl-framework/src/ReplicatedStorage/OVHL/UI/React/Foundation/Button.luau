--!strict
-- @Atom: Button v3.3 (Math Debounce)
-- @Role: Interactive Element with Precise Timestamp Checking
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Telemetry = Loader.Get("Telemetry")
local Style = Loader.Get("Style")
local Players = game:GetService("Players")
local UIConfig = require(RS.OVHL.Config.UISystemConfig)

local e = React.createElement
local useState = React.useState
local useRef = React.useRef

export type Props = { 
    Text: string, Variant: string?, Size: UDim2?, 
    OnClick: (() -> ())?, Disabled: boolean?, 
    Permission: number?, LayoutOrder: number?,
    DebounceTime: number?
}

return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("UX") end, {})
    
    local hover, setHover = useState(false)
    local press, setPress = useState(false)
    
    -- [MATH GUARD]
    -- Simpan waktu klik terakhir. Jangan andalkan state boolean semata.
    local lastClickRef = useRef(0)
    local isLockedVisually, setVisualLock = useState(false)
    
    local myRank = Players.LocalPlayer:GetAttribute("OVHL_Rank") or 0
    local isPermLocked = myRank < (props.Permission or 0)
    local isDisabled = props.Disabled or isPermLocked or isLockedVisually

    local variant = props.Variant or "Primary"
    local palette = Style.Colors.Action[variant] or Style.Colors.Action.Primary
    local bgColor = palette.Default
    
    if props.Disabled or isPermLocked then bgColor = Style.Colors.Background.Surface 
    elseif isLockedVisually then bgColor = palette.Press 
    elseif press then bgColor = palette.Press 
    elseif hover then bgColor = palette.Hover end

    local function handleClick()
        if isPermLocked then 
            logger:Interact(props.Text, {Res="Denied", Rank=myRank}) 
            return 
        end
        
        if props.Disabled then return end

        local now = os.clock()
        local cooldown = props.DebounceTime or UIConfig.Behavior.DefaultDebounce
        
        -- [PRECISION CHECK]
        -- Jika waktu sekarang - waktu terakhir < cooldown, TOLAK.
        if (now - lastClickRef.current) < cooldown then 
            return 
        end

        -- Update waktu klik terakhir
        lastClickRef.current = now
        
        -- Visual Feedback (Async, gak masalah telat dikit, yg penting logic di atas aman)
        setVisualLock(true)
        logger:Interact(props.Text, "Click")
        
        if props.OnClick then task.spawn(props.OnClick) end
        
        task.delay(cooldown, function()
            setVisualLock(false)
        end)
    end

    return e("TextButton", {
        Text = isPermLocked and "🔒 " .. props.Text or props.Text, 
        Font = Style.Fonts.Header, 
        TextSize = Style.TextSize.Body,
        TextColor3 = (isDisabled and not isLockedVisually) and Style.Colors.Text.Muted or palette.Content, 
        
        Size = props.Size or UDim2.fromOffset(140, 44),
        BackgroundColor3 = bgColor, 
        BackgroundTransparency = (variant == "Ghost" and not hover and not isLockedVisually) and 1 or (isLockedVisually and 0.2 or 0), 
        
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
