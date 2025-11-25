--!strict
return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local Promise = Loader.Get("Promise")

	-- Load Controller Asli
	local InventoryCtrl = require(game.StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.InventoryController)

	describe("InventoryController (Client Logic)", function()
		-- [SETUP] Mocking Dependencies
		-- Update Mock Bridge agar sesuai dengan API v0.2.0
		InventoryCtrl.Bridge = {
			Request = function(self, service, method)
				if method == "GetItems" then
					return Promise.resolve({ { Id = 1, Name = "MockSword" } })
				end
				return Promise.reject("Unknown Method")
			end,

			-- [FIX] Mocking method baru RequestWithRetry
			-- Di test environment, kita tidak butuh delay/retry loop asli.
			-- Kita cukup bypass langsung ke Request biasa agar tes cepat selesai.
			RequestWithRetry = function(self, service, method, options, ...)
				return self:Request(service, method, ...)
			end,

			Listen = function() end,
		}

		-- Mock Logger
		InventoryCtrl.Logger = { Info = function() end, Warn = function() end }

		it("should be a valid controller table", function()
			expect(InventoryCtrl).to.be.ok()
			expect(InventoryCtrl.Name).to.equal("Inventory")
		end)

		it("should fetch data and update state", function()
			-- Inject State Manual (Mocking Fusion State)
			local mockStateVal = {}
			InventoryCtrl.State = {
				Items = {
					set = function(self, val)
						mockStateVal = val
					end,
				},
			}

			-- Jalanin Logic
			local p = InventoryCtrl:FetchData()

			-- Tunggu Promise selesai
			local success = p:awaitStatus()

			expect(success).to.equal(Promise.Status.Resolved)
			-- Validasi hasil mock
			expect(mockStateVal[1].Name).to.equal("MockSword")
		end)
	end)
end
