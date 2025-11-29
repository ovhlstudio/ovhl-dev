--!strict
-- @Atom: Text v3.0 (Smart Typography)
-- @Role: Renders text scaled to Device Metrics
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local Style = Loader.Get("Style")
local DeviceUtil = Loader.Get("DeviceUtil") -- Untuk Scale Factor
local UIConfig = require(RS.OVHL.Config.UISystemConfig) -- The Law

local e = React.createElement

export type Props = { 
    Content: string, 
    Variant: string?, -- "H1", "Body", "Caption"
    Color: string?, 
    Align: Enum.TextXAlignment?, 
    Size: UDim2?, -- Container Size
    RichText: boolean?, 
    LayoutOrder: number?,
    Wrapped: boolean? 
}

return function(props: Props)
    -- 1. Ambil Scale Factor Realtime (atau dari Context nanti kalau mau reactive resize text)
    -- Note: Untuk performa super tinggi, kita ambil statis saat render. 
    -- Jika layar resize, React akan re-render layout, text juga ikut.
    local metrics = DeviceUtil.GetMetrics()
    local scale = metrics.Scale
    
    -- 2. Tentukan Token Typography
    local variantKey = props.Variant or "Body"
    local token = UIConfig.Typography[variantKey] or UIConfig.Typography.Body
    
    -- 3. Kalkulasi Ukuran Font Proporsional
    -- BaseSize * DeviceScale.
    -- Contoh: Body(16px) * Scale(0.5) = 8px di HP. Rapi.
    local finalSize = math.round(token.Size * scale)
    
    -- Safety clamp minimal 8px agar terbaca
    finalSize = math.max(finalSize, 8)

    local colorKey = props.Color or "Main"
    local textColor = Style.Colors.Text[colorKey] or Style.Colors.Text.Main

    return e("TextLabel", {
        Text = props.Content,
        Font = token.Font,
        TextSize = finalSize, -- Dynamic Scaled Size
        TextColor3 = textColor,
        
        BackgroundTransparency = 1,
        Size = props.Size or UDim2.fromScale(1, 0),
        AutomaticSize = props.Size and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
        
        TextXAlignment = props.Align or Enum.TextXAlignment.Left,
        RichText = props.RichText,
        TextWrapped = (props.Wrapped ~= nil) and props.Wrapped or true, -- Default Wrap True for Enterprise
        LayoutOrder = props.LayoutOrder
    })
end
