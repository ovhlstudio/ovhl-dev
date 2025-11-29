--!strict
-- @Controller: ShowcaseController v5.3 (Ping Tester)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local UIManager = Loader.Get("UIManager")
local Observable = Loader.Get("Observable")
local LayoutUtil = Loader.Get("LayoutUtil")
local Topbar = Loader.Get("Topbar")

local Ctrl = {}

function Ctrl:Init(ctx)
    local mod = Loader.Module("Showcase")
    local s, cfg = pcall(function() return require(mod.SharedConfig) end)
    self.Config = s and cfg or {Topbar={Enabled=false}, UI={Title="ERR"}, Security={ButtonSpamLimit={Max=5,Interval=1}}, Layout={DefaultSize={X=600,Y=450}}}
    self.Network = ctx.Network 

    local defCfg = self.Config.Layout.DefaultSize or {X=600,Y=450}
    
    self.State = {
        Visible = Observable.New(false):Log("ShowcaseVis"),
        CurrentTab = Observable.New("Home"):Log("NavTab"),
        WindowSize = Observable.New(UDim2.fromOffset(defCfg.X, defCfg.Y)), 
        WindowPos  = Observable.New(UDim2.fromScale(0.5, 0.5)),
        WindowAnchor = Observable.New(Vector2.new(0.5, 0.5)),
        InventoryList = Observable.New({}):Log("InvData"),
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
            end,
            ResetWindow = function()
                local def = self.Config.Layout.DefaultSize or {X=600,Y=450}
                local smartSize = LayoutUtil.GetSmartSize(Vector2.new(def.X, def.Y))
                self.State.WindowSize:Set(smartSize)
                self.State.Actions.SetLayout("Center")
            end,
            EquipItem = function(itemId, itemName)
                self.Logger:Info("Action", "Requesting Equip: " .. itemName)
                self.Network:Request("Inventory", "PerformAction", itemId, "Equip")
                    :andThen(function(result)
                        self.State.Actions.TriggerToast(result.Msg, "Success")
                        self:FetchData()
                    end)
                    :catch(function(err)
                        self.State.Actions.TriggerToast("Error: " .. tostring(err), "Error")
                        self.Logger:Warn("EquipFail", err)
                    end)
            end,
            
            -- [PING TESTER]
            PingServer = function() 
                self.Logger:Info("Network", "Sending Ping Request...")
                
                -- Panggil sebagai Request agar bisa ditangkap balasan/errornya
                self.Network:Request("Showcase", "Ping")
                    :andThen(function(res)
                        -- SUKSES: Server membalas
                        self.Logger:Info("PingOK", res)
                        self.State.Actions.TriggerToast("Pong! Server Alive.", "Success")
                    end)
                    :catch(function(err)
                        -- GAGAL: Bisa karena Timeout atau RATE LIMIT
                        self.Logger:Warn("PingFail", err)
                        
                        -- Cek apakah errornya Rate Limit (Code 429)
                        if string.find(tostring(err), "429") or string.find(tostring(err), "Rate Limit") then
                            self.State.Actions.TriggerToast("⛔ SPAM DETECTED (Rate Limit)", "Error")
                        else
                            self.State.Actions.TriggerToast("Ping Error: " .. tostring(err), "Error")
                        end
                    end)
            end,
            
            TriggerModal = function() self.State.ActiveModal:Set({ Title = "CONFIRM", Body = "Delete?", ActionLabel = "Yes", OnConfirm = function() self.State.ActiveModal:Set(nil) end, OnCancel = function() self.State.ActiveModal:Set(nil) end }) end,
            TriggerToast = function(msg, var) self.State.ActiveToast:Set({ID=os.clock(), Message=msg, Variant=var}) end,
            DismissToast = function() self.State.ActiveToast:Set(nil) end,
            SetVolume = function(val) self.State.Slider:Set(val) end
        }
    }
end

function Ctrl:FetchData()
    self.Network:Request("Inventory", "GetItems")
        :andThen(function(data) self.State.InventoryList:Set(data) end)
        :catch(function(err) self.State.Actions.TriggerToast("Connection Failed", "Error") end)
end

function Ctrl:Start()
    self:SetupTopbar()
    local renderConfig = { 
        Mode = "Code", View = require(script.Parent.Views.MainView), TargetScreen = "OVHL_Showcase",
        Config = self.Config, UI = self.Config.UI, Security = self.Config.Security,
        Topbar = self.Config.Topbar, Layout = self.Config.Layout, Navigation = self.Config.Navigation
    }
    UIManager.Render("MainView", self.State, renderConfig)
    
    local defCfg = self.Config.Layout.DefaultSize or {X=600,Y=450}
    task.delay(0.5, function()
        local newSize = LayoutUtil.GetSmartSize(Vector2.new(defCfg.X, defCfg.Y))
        self.State.WindowSize:Set(newSize)
        self:FetchData()
    end)
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local newSize = LayoutUtil.GetSmartSize(Vector2.new(defCfg.X, defCfg.Y))
        self.State.WindowSize:Set(newSize)
    end)
end

function Ctrl:SetupTopbar()
    if not self.Config.Topbar.Enabled then return end
    local icon = Topbar.new():setLabel(self.Config.Topbar.Text):setImage(self.Config.Topbar.Icon)
    icon.selected:Connect(function() self.State.Visible:Set(true) end)
    icon.deselected:Connect(function() self.State.Visible:Set(false) end)
    self.State.Visible:Subscribe(function(vis) if vis then icon:select() else icon:deselect() end end)
end

return Ctrl
