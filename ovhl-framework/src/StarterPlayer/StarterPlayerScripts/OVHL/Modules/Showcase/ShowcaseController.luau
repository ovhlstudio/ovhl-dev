--!strict
-- @Controller: ShowcaseController v3.2 (Data Restore)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local UIManager = Loader.Get("UIManager")
local Observable = Loader.Get("Observable")
local LayoutUtil = Loader.Get("LayoutUtil")
local Topbar = Loader.Get("Topbar")
local DeviceUtil = Loader.Get("DeviceUtil")

local Ctrl = {}

function Ctrl:Init(ctx)
    local mod = Loader.Module("Showcase")
    local s, cfg = pcall(function() return require(mod.SharedConfig) end)
    self.Config = s and cfg or {Topbar={Enabled=false}, UI={Title="ERR"}, Security={ButtonSpamLimit={Max=5,Interval=1}}, Layout={DefaultSize={X=600,Y=450}}}
    self.Network = ctx.Network 

    local defSize = self.Config.Layout.DefaultSize or {X=600,Y=450}

    self.State = {
        Visible = Observable.New(false):Log("ShowcaseVis"),
        CurrentTab = Observable.New("Home"):Log("NavTab"),
        
        WindowSize = Observable.New(UDim2.fromOffset(defSize.X, defSize.Y)),
        WindowPos  = Observable.New(UDim2.fromScale(0.5, 0.5)),
        WindowAnchor = Observable.New(Vector2.new(0.5, 0.5)),
        
        ActiveModal = Observable.New(nil),
        ActiveToast = Observable.New(nil),
        Toggles = { Music = Observable.New(true):Log("Music"), SFX = Observable.New(false) },
        Inputs  = { Search = Observable.New(""):Log("Input_Search") },
        Slider = Observable.New(0.5):Log("Volume"),
        
        Actions = {
            Navigate = function(tab) self.State.CurrentTab:Set(tab) end,
            SetLayout = function(pos) 
                local l = LayoutUtil.Get({Position=pos, Margin=20})
                self.State.WindowPos:Set(l.Position); self.State.WindowAnchor:Set(l.AnchorPoint)
                local m = DeviceUtil.GetMetrics()
                local abs = m.Viewport * Vector2.new(l.Position.X.Scale, l.Position.Y.Scale)
                self.Logger:Info("Layout", { Preset=pos, AbsX=math.floor(abs.X), AbsY=math.floor(abs.Y) })
            end,
            ResetWindow = function() self.State.WindowSize:Set(UDim2.fromOffset(defSize.X, defSize.Y)); self.State.Actions.SetLayout("Center") end,
            
            PingServer = function()
                self.Logger:Info("Network", "Sending Ping...")
                self.Network:Fire("Showcase", "Ping")
            end,
            
            TriggerModal = function() self.State.ActiveModal:Set({ Title = "CONFIRM", Body = "Delete?", ActionLabel = "Yes", OnConfirm = function() self.State.ActiveModal:Set(nil) end, OnCancel = function() self.State.ActiveModal:Set(nil) end }) end,
            TriggerToast = function(msg, var) self.State.ActiveToast:Set({ID=os.clock(), Message=msg, Variant=var}) end,
            DismissToast = function() self.State.ActiveToast:Set(nil) end,
            SetVolume = function(val) self.State.Slider:Set(val) end
        }
    }
end

function Ctrl:Start()
    self:SetupTopbar()
    
    -- [FIX] RESTORE ALL CONFIG DATA
    local renderConfig = { 
        Mode = "Code", 
        View = require(script.Parent.Views.MainView), 
        TargetScreen = "OVHL_Showcase",
        
        -- DATA INJECTION RESTORED:
        Config = self.Config,         -- Full Config
        UI = self.Config.UI,          -- UI settings
        Security = self.Config.Security,
        Topbar = self.Config.Topbar,
        Layout = self.Config.Layout,  -- Initial Layout info
        Navigation = self.Config.Navigation -- [CRITICAL] This was missing, causing empty HomeView
    }
    
    UIManager.Render("MainView", self.State, renderConfig)
end

function Ctrl:SetupTopbar()
    if not self.Config.Topbar.Enabled then return end
    local icon = Topbar.new():setLabel(self.Config.Topbar.Text):setImage(self.Config.Topbar.Icon)
    icon.selected:Connect(function() self.State.Visible:Set(true) end)
    icon.deselected:Connect(function() self.State.Visible:Set(false) end)
    self.State.Visible:Subscribe(function(vis) if vis then icon:select() else icon:deselect() end end)
end

return Ctrl
