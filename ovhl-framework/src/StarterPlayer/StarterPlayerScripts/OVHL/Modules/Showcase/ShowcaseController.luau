--!strict
-- @Controller: ShowcaseController v5.2 (Wired & Networked)
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
        
        -- [WIRED] Start Kosong! Data akan diisi oleh Server.
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
            
            -- [WIRED ACTION] Equip Item ke Server
            EquipItem = function(itemId, itemName)
                self.Logger:Info("Action", "Requesting Equip: " .. itemName)
                
                -- Kirim Paket ke Server
                self.Network:Request("Inventory", "PerformAction", itemId, "Equip")
                    :andThen(function(result)
                        -- Sukses: Tampilkan pesan dari server & Refresh Data
                        self.State.Actions.TriggerToast(result.Msg, "Success")
                        self:FetchData() -- Pull data terbaru (Status Equipped berubah)
                    end)
                    :catch(function(err)
                        -- Gagal: Tampilkan Error (misal: Spam, Item hilang)
                        self.State.Actions.TriggerToast("Error: " .. tostring(err), "Error")
                        self.Logger:Warn("EquipFail", err)
                    end)
            end,
            
            PingServer = function() self.Network:Fire("Showcase", "Ping") end,
            TriggerModal = function() self.State.ActiveModal:Set({ Title = "CONFIRM", Body = "Delete?", ActionLabel = "Yes", OnConfirm = function() self.State.ActiveModal:Set(nil) end, OnCancel = function() self.State.ActiveModal:Set(nil) end }) end,
            TriggerToast = function(msg, var) self.State.ActiveToast:Set({ID=os.clock(), Message=msg, Variant=var}) end,
            DismissToast = function() self.State.ActiveToast:Set(nil) end,
            SetVolume = function(val) self.State.Slider:Set(val) end
        }
    }
end

-- [NEW] Fungsi Fetch Data dari Server
function Ctrl:FetchData()
    self.Logger:Debug("Net", "Fetching Inventory from Server...")
    
    self.Network:Request("Inventory", "GetItems")
        :andThen(function(data)
            -- [SUCCESS] Server merespon dengan Array Item
            self.Logger:Info("Net", "Inventory Received: " .. #data .. " items")
            self.State.InventoryList:Set(data)
        end)
        :catch(function(err)
            -- [FAIL] Server Error / Timeout
            self.Logger:Error("NetFail", "Failed to fetch inventory: " .. tostring(err))
            self.State.Actions.TriggerToast("Connection Failed", "Error")
        end)
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
        
        -- [AUTO FETCH] Ambil data saat aplikasi mulai
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
