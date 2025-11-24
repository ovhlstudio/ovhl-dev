-- @Bridge: TopbarPlus (With Security Check)
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")

local TopbarPlus = Loader.Pkg("topbarplus")
local Fusion = Loader.Get("Fusion")
local API = Loader.Get("API")

local TopbarBridge = {}
local _initialized = false
local Logger = nil 

function TopbarBridge.Init()
    if _initialized then return end
    _initialized = true
    Logger = SmartLogger.New("TOPBAR")
    
    local Theme = API.Theme
    local peek = Fusion.peek
    local C = Theme.Colors
    
    TopbarPlus.setDisplayOrder(10000)
    TopbarPlus.modifyBaseTheme({
        {"IconBackgroundColor", peek(C.Base.Main)},
        {"IconBorderColor", peek(C.Neutral.Main)},
        {"IconImageColor", peek(C.BaseContent.Main)},
        {"IconLabelColor", peek(C.BaseContent.Main)},
        {"WidgetBackgroundColor", peek(C.Base.Main)},
        {"WidgetBorderColor", peek(C.Neutral.Main)},
        {"IconCornerRadius", UDim.new(0, 8)},
    })
    
    Logger:Info("System", "Bridge Initialized")
end

function TopbarBridge.Register(name, config, toggleFunc)
    TopbarBridge.Init()
    
    if not config or not config.Enabled then return nil end
    
    -- [SECURITY CHECK] The Gatekeeper
    if config.Permission then
        local myRank = Players.LocalPlayer:GetAttribute("OVHL_Rank") or 0
        if myRank < config.Permission then
            Logger:Debug("Hidden", { 
                Module = name, 
                Reason = "Low Rank", 
                Req = config.Permission, 
                Got = myRank 
            })
            return nil -- Jangan bikin icon sama sekali!
        end
    end
    
    Logger:Info("Register", { Name = name, Perm = config.Permission or 0 })
    
    local icon = TopbarPlus.new()
        :setLabel(config.Text or name)
        :setImage(config.Icon)
        :setOrder(config.Order or 10)
        
    if config.Caption then icon:setCaption(config.Caption) end
    if config.Shortcut then icon:bindToggleKey(config.Shortcut) end
    
    icon.selected:Connect(function() 
        Logger:Debug("Interaction", {Action="Open", Module=name})
        toggleFunc(true) 
    end)
    
    icon.deselected:Connect(function() 
        Logger:Debug("Interaction", {Action="Close", Module=name})
        toggleFunc(false) 
    end)
    
    return icon
end

return TopbarBridge
