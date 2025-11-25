--!strict
-- @Controller: NotificationController
-- @Role: Central Toast Manager via Signals
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local OVHL = require(RS.OVHL.Core.Framework)

local UI = Loader.Get("API")
local Fusion = UI.Fusion
local Trove = Loader.Get("Trove")

local NotificationView = Loader.UI("Views/System/NotificationView") -- Kita buat habis ini

local Ctrl = OVHL.CreateController({
	Name = "Notification",
	-- No config needed for now
})

function Ctrl:Init()
	self._trove = Trove.new()
	self.Scope = UI.NewScope()

	-- [STATE] Daftar Notifikasi Aktif
	-- Format: { { Id=1, Type="Success", Msg="Hello", Time=os.clock() }, ... }
	self.State = {
		Toasts = self.Scope:Value({}),
	}

	-- Mount UI (Layer paling atas)
	local mounted = UI.SafeLoader.Mount(self.Scope, NotificationView, {
		State = self.State,
	})
	if mounted then
		self._trove:Add(mounted)
	end

	-- [LISTENER] Mendengarkan Sinyal dari Modul Lain
	-- Usage: Signals:Fire("Notify", { Type="Success", Msg="Saved!" })
	Loader.Get("Signals"):Connect("Notify", function(payload)
		self:Add(payload)
	end)
end

function Ctrl:Add(payload)
	local msg = payload.Msg or "Notification"
	local style = payload.Type or "Info" -- Success, Error, Info, Warning
	local duration = payload.Duration or 3

	local current = Fusion.peek(self.State.Toasts)
	local newId = os.clock() -- Unique ID based on time

	local newToast = {
		Id = newId,
		Type = style,
		Msg = msg,
		Duration = duration,
	}

	-- Tambahkan ke list (Copy table biar Fusion detect change)
	local newList = table.clone(current)
	table.insert(newList, newToast)
	self.State.Toasts:set(newList)

	-- Auto Remove Timer
	task.delay(duration, function()
		self:Remove(newId)
	end)
end

function Ctrl:Remove(targetId)
	local current = Fusion.peek(self.State.Toasts)
	local newList = {}
	for _, toast in ipairs(current) do
		if toast.Id ~= targetId then
			table.insert(newList, toast)
		end
	end
	self.State.Toasts:set(newList)
end

return Ctrl
