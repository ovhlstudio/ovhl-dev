--!strict
-- @Component: AsyncButton (Telemetry Enabled)
-- @Standard: OVHL Gold (With UX Logs)

local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local UXLogger = SmartLogger.New("UX") -- [CRITICAL] Logger khusus User Experience

return function(API)
    local Onyx = API.Onyx
    
    return function(scope, props)
        local isProcessing = scope:Value(false)
        
        -- Ambil nama tombol untuk log
        local btnName = props.Text or "UnknownButton"
        
        return Onyx.Components.Button(scope, {
            Size = props.Size,
            LayoutOrder = props.LayoutOrder,
            Style = props.Style or "Filled",
            Color = props.Color,
            
            Disabled = API.Computed(scope, function(use)
                return props.Disabled or use(isProcessing)
            end),
            
            Content = API.Computed(scope, function(use)
                if use(isProcessing) then return { "..." } else return { btnName } end
            end),
            
            OnActivate = function()
                -- [TELEMETRY] Log detik ini juga saat klik terjadi
                UXLogger:Info("Interact", { 
                    Element = btnName, 
                    State = "Clicked",
                    Processing = API.Fusion.peek(isProcessing) 
                })

                -- Debounce Check
                if API.Fusion.peek(isProcessing) then 
                    UXLogger:Debug("Debounce", "Click ignored (Processing)")
                    return 
                end
                
                if props.OnClick then
                    isProcessing:set(true)
                    
                    -- Bungkus xpcall
                    local success, result = xpcall(function()
                        return props.OnClick()
                    end, debug.traceback)
                    
                    if not success then
                        UXLogger:Error("ClickError", { Element = btnName, Trace = result })
                        isProcessing:set(false)
                        return
                    end
                    
                    -- Handle Promise
                    if result and typeof(result) == "table" and result.andThen then
                        result:finally(function()
                            isProcessing:set(false)
                            UXLogger:Info("TaskDone", { Element = btnName })
                        end)
                    else
                        task.wait(0.1)
                        isProcessing:set(false)
                    end
                end
            end
        })
    end
end
