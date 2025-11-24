return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
	local Promise = Loader.Get("Promise")

	-- Load Controller Asli
	-- Catatan: Di Framework V4, CreateController mengembalikan table controller.
	local InventoryCtrl = require(game.StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.InventoryController)

	describe("InventoryController (Client Logic)", function()
		-- [SETUP] Mocking Dependencies sebelum tes jalan
		-- Kita pasang "Jebakan Batman" biar dia gak error nyari Server beneran
		InventoryCtrl.Bridge = {
			Request = function(self, service, method)
				-- Pura-pura jadi Server yang ngebales sukses
				if method == "GetItems" then
					return Promise.resolve({ { Id = 1, Name = "MockSword" } })
				end
				return Promise.reject("Unknown Method")
			end,
			Listen = function() end, -- Mock Listen biar gak error
		}

		-- Mock Logger biar gak spam console
		InventoryCtrl.Logger = { Info = function() end, Warn = function() end }

		-- Mock State (Fusion Value)
		-- Kita asumsi Init sudah jalan atau kita inject state manual jika perlu
		-- Tapi InventoryCtrl.Init meload UI, ini bisa error di test environment tanpa PlayerGui.
		-- Skenario terbaik: Pisahkan Logic dari UI Mounting.
		-- Tapi untuk sekarang, kita tes function yang aman aja.

		it("should be a valid controller table", function()
			expect(InventoryCtrl).to.be.ok()
			expect(InventoryCtrl.Name).to.equal("Inventory")
		end)

		it("should fetch data and update state", function()
			-- Kita tes fungsi FetchData langsung
			-- Karena kita sudah Mock Bridge di atas, dia gak bakal error network.

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
			-- Cek apakah state berubah sesuai return dari Mock Bridge
			expect(mockStateVal[1].Name).to.equal("MockSword")
		end)
	end)
end
