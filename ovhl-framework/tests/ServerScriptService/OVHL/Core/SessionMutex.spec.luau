--!strict
return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	local SessionMutex = require(ServerScriptService.OVHL.Core.SessionMutex)

	describe("[UNIT-TEST] SessionMutex (Anti-Race Condition)", function()
		it("should allow first transaction and return result", function()
			local userId = 1001
			local success, res = SessionMutex.Run(userId, function()
				return "Transaction OK"
			end)

			expect(success).to.equal(true)
			expect(res).to.equal("Transaction OK")
			-- Pastikan lock terbuka setelah selesai
			expect(SessionMutex.IsLocked(userId)).to.equal(false)
		end)

		it("should FAIL if user is already locked (Concurrency Check)", function()
			local userId = 1002

			-- Kita simulasikan lock manual (seolah-olah sedang ada transaksi berjalan)
			-- Hack internal state via API public jika ada, atau simulasi nested call

			-- Cara test: Panggil Run di dalam Run (Recursive attempt)
			local doubleLockSuccess = false
			local innerError = ""

			SessionMutex.Run(userId, function()
				-- Di dalam sini, User 1002 sedang TERKUNCI.
				-- Coba transaksi kedua:
				local s, e = SessionMutex.Run(userId, function() end)
				doubleLockSuccess = s
				innerError = e
			end)

			expect(doubleLockSuccess).to.equal(false)
			expect(innerError).to.be.a("string")
		end)

		it("should AUTO-UNLOCK if code errors (Safety Valve)", function()
			local userId = 1003

			-- Jalankan fungsi yang PASTI error
			local success, err = SessionMutex.Run(userId, function()
				error("Simulated Crash")
			end)

			expect(success).to.equal(false)
			-- Pastikan Mutex TIDAK macet (IsLocked harus false)
			-- Kalau true, artinya sistem kita cacat bikin player stuck selamanya
			expect(SessionMutex.IsLocked(userId)).to.equal(false)
		end)
	end)
end
