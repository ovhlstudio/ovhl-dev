--!strict
-- @Component: SmartButton (With Telemetry)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")

-- Logger khusus interaksi User
local UXLogger = SmartLogger.New("UX") 

return function(API)
    return function(scope, props)
        -- Map OVHL Style to Onyx Style
        local style = "Filled"
        if props.Style == "Outline" then style = "Outlined" end
        if props.Style == "Ghost" then style = "Ghost" end
        
        local color = nil
        if props.Style == "Danger" then color = API.Util.Colors.Red["500"] end
        
        -- Ambil Text untuk Log (Bisa string atau State)
        local btnText = props.Text or "Unknown"
        
        return scope:Button {
            Content = { props.Text },
            Style = style,
            Color = color,
            Size = props.Size,
            LayoutOrder = props.LayoutOrder,
            
            -- [TELEMETRY] Intercept Activation
            OnActivate = function()
                -- 1. Lapor Dulu!
                local txt = (type(btnText) == "string") and btnText or "DynamicState"
                UXLogger:Info("Click", { 
                    Button = txt, 
                    Style = props.Style,
                    Context = props.Context or "UI"
                })
                
                -- 2. Jalankan Logic Asli
                if props.OnClick then props.OnClick() end
                if props.OnActivate then props.OnActivate() end
            end
        }
    end
end
