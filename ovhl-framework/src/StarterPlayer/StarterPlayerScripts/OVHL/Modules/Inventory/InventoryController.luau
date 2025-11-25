--!strict
-- @Controller: InventoryController v0.3.1
-- @Role: Inventory UI Logic
-- @Features: Retry Policy, Toast Notification, Auto-Keyed Guard

local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework)

local UI = Loader.Get("API")
local Fusion = UI.Fusion
local Trove = Loader.Get("Trove")
local Topbar = Loader.Get("Topbar")
local InventoryView = Loader.UI.Views.Inventory.InventoryView

local Ctrl = OVHL.CreateController({
	Name = "Inventory",
	ConfigName = "Inventory",
})

function Ctrl:Init()
	self._trove = Trove.new()
	self.Scope = UI.NewScope()

	-- [DEPENDENCY] Signals wajib ada untuk Notification System
	self.Signals = Loader.Get("Signals")

	self.State = {
		Visible = self.Scope:Value(false),
		Items = self.Scope:Value({}),
	}

	local mounted = UI.SafeLoader.Mount(self.Scope, InventoryView, {
		Config = self.Config,
		State = self.State,
		OnClose = function()
			self:Toggle(false)
		end,
		OnAction = function(item, actionId, unlockUI)
			self:HandleAction(item, actionId, unlockUI)
		end,
	})
	if mounted then
		self._trove:Add(mounted)
	end

	self.Icon = Topbar.Register("Inventory", self.Config.Topbar, function(isOpened)
		self:Toggle(isOpened)
	end)
end

function Ctrl:Start()
	self:FetchData()
end

function Ctrl:Shutdown()
	if self._trove then
		self._trove:Destroy()
		self._trove = nil
	end
	if self.Scope and self.Scope.doCleanup then
		self.Scope:doCleanup()
		self.Scope = nil
	end
end

function Ctrl:HandleAction(item, actionId, unlockUI)
	-- [ZERO TOLERANCE] Validasi Data Mentah
	if not item or not item.Id then
		self.Logger:Warn("DataError", "Invalid Item ID")
		if self.Signals then
			self.Signals:Fire("Notify", { Type = "Error", Msg = "Data Error: Invalid Item" })
		end
		unlockUI()
		return
	end

	-- [ENTERPRISE] Gunakan Helper Otomatis Framework
	-- ID Lock otomatis menjadi: "Inventory:<Action>:<ItemID>"
	-- Tidak perlu string.format manual lagi.

	self:SafeRunEx({
		Action = actionId,
		Key = item.Id,
		Debounce = 1.0,
	}, function()
		-- Network Request dengan Retry Policy (Anti-Fail)
		self.Bridge
			:RequestWithRetry("Inventory", "PerformAction", { Retries = 3 }, item.Id, actionId)
			:andThen(function(res)
				self.Logger:Info("ActionSuccess", res.Msg)

				-- Notifikasi Sukses (Dynamic Message)
				local itemName = item.Name
				local actionText = (actionId == "Equip") and "Equipped" or "Dropped"

				if self.Signals then
					self.Signals:Fire("Notify", {
						Type = "Success",
						Msg = string.format("%s %s", actionText, itemName),
					})
				end

				return self:FetchData()
			end)
			:catch(function(err)
				self.Logger:Warn("ActionFail", err)
				-- Notifikasi Error dari Server
				if self.Signals then
					self.Signals:Fire("Notify", { Type = "Error", Msg = tostring(err) })
				end
			end)
			:finally(function()
				unlockUI()
			end)
	end)
end

function Ctrl:FetchData()
	-- Retry Policy agar tidak crash saat boot awal
	return self.Bridge
		:RequestWithRetry("Inventory", "GetItems", { Retries = 5, Interval = 1 })
		:andThen(function(items)
			self.State.Items:set(items)
		end)
		:catch(function(err)
			self.Logger:Warn("FetchError", "Failed to load items after retries: " .. tostring(err))
		end)
end

function Ctrl:Toggle(forceState)
	local current = Fusion.peek(self.State.Visible)
	local newState = if forceState ~= nil then forceState else not current
	self.State.Visible:set(newState)
	if self.Icon then
		if newState then
			self.Icon:select()
		else
			self.Icon:deselect()
		end
	end
	if newState then
		self:FetchData()
	end
end

return Ctrl
