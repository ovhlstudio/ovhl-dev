--!strict
-- @Core: Framework (Central Factory)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")
local Bridge = Loader.Get("Bridge")
local Trove = Loader.Get("Trove")

local Framework = {}

function Framework.CreateController(def)
	local ctrl = def or {}
	local name = ctrl.Name or "UnknownController"

	-- Auto-Inject Tools
	ctrl.Logger = SmartLogger.New(name:upper())
	ctrl.Bridge = Bridge.New()
	ctrl.Trove = Trove.new()

	-- Auto-Load Config
	if ctrl.ConfigName then
		local loadedConfig = nil
		local loadSource = "None"

		-- Try Module Feature
		local successA, resA = pcall(function()
			return require(Loader.Module(ctrl.ConfigName).SharedConfig)
		end)
		if successA and resA then
			loadedConfig = resA
			loadSource = "Module"
		else
			-- Try Global Config
			local successB, resB = pcall(function()
				return require(RS.OVHL.Config:FindFirstChild(ctrl.ConfigName))
			end)
			if successB and resB then
				loadedConfig = resB
				loadSource = "GlobalConfig"
			end
		end

		if loadedConfig then
			ctrl.Config = loadedConfig
			ctrl.Logger:Debug("ConfigLoaded", { Source = loadSource, Name = ctrl.ConfigName })
		else
			ctrl.Logger:Warn("ConfigMissing", "Failed to load config: " .. ctrl.ConfigName)
			ctrl.Config = { Meta = { Error = "Missing" }, UI = {}, Topbar = {} }
		end
	end

	-- Lifecycle Wrapper
	local originalInit = ctrl.Init
	function ctrl:Init(ctx)
		if originalInit then
			local s, err = pcall(originalInit, self, ctx)
			if not s then ctrl.Logger:Error("InitCrash", err) end
		end
	end

	-- Auto Cleanup
	function ctrl:Destroy()
		if self.Shutdown then self:Shutdown() end
		if self.Trove then
			self.Trove:Destroy()
			self.Trove = nil
		end
	end

	return ctrl
end

return Framework
