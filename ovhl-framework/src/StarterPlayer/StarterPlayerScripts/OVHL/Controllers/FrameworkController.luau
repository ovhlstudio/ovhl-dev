--!strict
-- @Controller: FrameworkController (V2 Standard)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework) -- Central Import

-- Libs (View & Utils tetap manual)
local Fusion = Loader.Pkg("Fusion")
local Trove = Loader.Pkg("Trove")
local UI = Loader.UI.Foundation.API
local Topbar = Loader.UI.Foundation.Bridges.Topbar
local FrameworkPanelView = Loader.UI("Views/System/FrameworkPanelView")

local Ctrl = OVHL.CreateController({
    Name = "Framework",
    ConfigName = "SystemPanelConfig" -- Auto-load Config ke self.Config
})

function Ctrl:Init()
    self.Player = game.Players.LocalPlayer
    self._trove = Trove.new()
    self.Scope = UI.NewScope()
    
    self.State = {
        Visible = self.Scope:Value(false),
        CurrentTab = self.Scope:Value("Dashboard"), 
        PlayerList = self.Scope:Value({}),
        IsLoading = self.Scope:Value(false),
        SelectedPlayer = self.Scope:Value(nil),
        Confirmation = self.Scope:Value(nil)
    }

    local mounted = UI.SafeLoader.Mount(self.Scope, FrameworkPanelView, {
        Config = self.Config,
        State = self.State,
        OnClose = function() self:Toggle(false) end,
        
        Actions = {
            RefreshPlayers = function() self:FetchPlayers() end,
            OpenInspector = function(p) self.State.SelectedPlayer:set(p) end,
            CloseInspector = function() self.State.SelectedPlayer:set(nil) end,
            
            -- [GUARDED ACTION via self.Guard]
            RequestRankChange = function(targetData, newRankId, rankLabel)
                self.Guard.Run({ 
                    Confirm = {
                        Title = "CONFIRM RANK CHANGE",
                        Msg = "Are you sure you want to promote/demote\n" .. targetData.Name .. " to " .. rankLabel .. "?"
                    }
                }, function()
                    self:SetRank(targetData.UserId, newRankId)
                end)
            end,

            ResolveConfirmation = function(confirmed)
                self:HandleConfirmationUI(confirmed)
            end
        }
    })
    
    if mounted then self._trove:Add(mounted) end
    self:UpdateTopbar()
    
    -- [LISTENERS via self.Bridge]
    self.Bridge:Listen("Permission", "RankChanged", function(u, r)
        if u == self.Player.UserId then self:UpdateTopbar() end
        if Fusion.peek(self.State.Visible) then self:FetchPlayers() end
    end)

    -- [GLOBAL SIGNAL]
    Loader.Core("Signals"):Connect("SystemUI:RequestConfirm", function(payload)
        self:ShowConfirmationUI(payload)
    end)
end

function Ctrl:ShowConfirmationUI(payload)
    self._pendingGuardCallback = payload.OnResult
    self.State.Confirmation:set({ Title = payload.Title, Message = payload.Message })
    task.delay(5, function()
        local current = Fusion.peek(self.State.Confirmation)
        if current and current.Title == payload.Title then
            self.Logger:Info("AutoCancel", "Timeout 5s reached")
            self:HandleConfirmationUI(false)
        end
    end)
end

function Ctrl:HandleConfirmationUI(confirmed)
    if self._pendingGuardCallback then self._pendingGuardCallback(confirmed) end
    if confirmed then self.Logger:Info("UserConfirmed", "Action executed")
    else self.Logger:Info("UserCanceled", "Action aborted") end
    self.State.Confirmation:set(nil)
    self._pendingGuardCallback = nil
end

function Ctrl:UpdateTopbar()
    if self.Icon then return end 
    self.Icon = Topbar.Register("Framework", self.Config.Topbar, function(isOpened) self:Toggle(isOpened) end)
end

function Ctrl:Toggle(forceState)
    local current = Fusion.peek(self.State.Visible)
    local newState = if forceState ~= nil then forceState else not current
    self.State.Visible:set(newState)
    if self.Icon then if newState then self.Icon:select() else self.Icon:deselect() end end
    if newState then self:FetchPlayers() end
end

function Ctrl:FetchPlayers()
    self.State.IsLoading:set(true)
    self.Bridge:Request("Permission", "GetPlayers")
        :andThen(function(res)
            self.State.PlayerList:set(res)
            self.State.IsLoading:set(false)
        end)
        :catch(function(err)
            self.State.IsLoading:set(false)
        end)
end

function Ctrl:SetRank(targetId, newRank)
    self.State.IsLoading:set(true)
    self.State.SelectedPlayer:set(nil) 
    self.Bridge:Request("Permission", "SetRank", tonumber(targetId), tonumber(newRank))
        :andThen(function(res)
            self.Logger:Info("Success", res)
            self:FetchPlayers()
        end)
        :catch(function(err)
            warn("[Framework] SetRank Failed: " .. tostring(err))
            self.State.IsLoading:set(false)
        end)
end

return Ctrl
