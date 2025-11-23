--!strict
-- @Component: SmartText
-- @Role: Standardized Typography
return function(API)
    local Theme = API.Theme
    local function New(scope, class) return API.New(scope, class) end

    local VARIANTS = {
        Header = { Size = 24, Font = "Heading", Color = "BaseContent" },
        SubHeader = { Size = 18, Font = "Body", Color = "BaseContent" },
        Body = { Size = 14, Font = "Body", Color = "BaseContent" },
        Caption = { Size = 12, Font = "Body", Color = "Neutral" },
    }

    return function(scope, props)
        local variant = VARIANTS[props.Variant or "Body"]
        
        return New(scope, "TextLabel") {
            Name = props.Name or "Text",
            Text = props.Text or "",
            LayoutOrder = props.LayoutOrder,
            
            -- Styling
            BackgroundTransparency = 1,
            TextColor3 = Theme.Colors[variant.Color].Main,
            TextSize = props.Size or variant.Size,
            FontFace = Theme.Font[variant.Font],
            TextXAlignment = props.Align or Enum.TextXAlignment.Left,
            
            -- Auto Size
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.fromScale(0, 0),
        }
    end
end
