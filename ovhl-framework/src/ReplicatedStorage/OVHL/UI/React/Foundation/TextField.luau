--!strict
-- @Atom: TextField v2.1 (Safe)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Style = Loader.Get("Style")
local Telemetry = Loader.Get("Telemetry")

local e = React.createElement
local useState = React.useState

export type Props = { Text: any, Placeholder: string?, OnChanged: any, OnSubmit: any, LayoutOrder: number? }

return function(props: Props)
    local logger = React.useMemo(function() return Telemetry.New("Input") end, {})
    local focused, setFocused = useState(false)
    
    return e("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Style.Colors.Background.Main,
        BorderSizePixel = 0, LayoutOrder = props.LayoutOrder
    }, {
        Corner = e("UICorner", { CornerRadius = Style.Metrics.Corner.Small }),
        Stroke = e("UIStroke", { 
            Color = focused and Style.Colors.Action.Primary.Default or Style.Colors.Background.Surface, 
            Thickness = 1 
        }),
        Input = e("TextBox", {
            Text = props.Text, PlaceholderText = props.Placeholder,
            Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1, TextColor3 = Style.Colors.Text.Main,
            Font = Style.Fonts.Body, TextSize = Style.TextSize.Body,
            ClearTextOnFocus = false,
            -- [FIX] Absolutely no TextSecure prop here
            
            [React.Change.Text] = function(rbx) if props.OnChanged then props.OnChanged(rbx.Text) end end,
            [React.Event.Focused] = function() setFocused(true); logger:Interact("TextField", "Focus Gained") end,
            [React.Event.FocusLost] = function(rbx, enter) 
                setFocused(false)
                logger:Interact("TextField", { Action="FocusLost", Value=rbx.Text, Submitted=enter })
                if enter and props.OnSubmit then props.OnSubmit(rbx.Text) end 
            end
        })
    })
end
