--!strict
return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	local RateLimiter = require(ServerScriptService.OVHL.Core.RateLimiter)

	-- Mock Player
	local MockPlayer = { UserId = 99999 }

	describe("[UNIT-TEST] RateLimiter (Traffic Control)", function()
		it("should initialize correctly", function()
			local limiter = RateLimiter.New()
			expect(limiter).to.be.ok()
		end)

		it("should BLOCK requests exceeding quota", function()
			local limiter = RateLimiter.New()
			local action = "SpamTest"
			local limit = 5
			local interval = 10 -- 5 request per 10 detik

			-- Tembak 5 kali (Harus OK)
			for i = 1, limit do
				local allowed = limiter:Check(MockPlayer, action, limit, interval)
				expect(allowed).to.equal(true)
			end

			-- Tembak ke-6 (Harus GAGAL)
			local spam = limiter:Check(MockPlayer, action, limit, interval)
			expect(spam).to.equal(false)
		end)

		it("should REFILL tokens over time", function()
			local limiter = RateLimiter.New()
			local action = "RefillTest"

			-- Habiskan token (Limit 1, Interval 0.1 detik)
			limiter:Check(MockPlayer, action, 1, 0.1)

			-- Cek langsung (Harus gagal)
			expect(limiter:Check(MockPlayer, action, 1, 0.1)).to.equal(false)

			-- Tunggu 0.2 detik (Token harusnya nambah)
			task.wait(0.2)

			-- Cek lagi (Harus sukses)
			expect(limiter:Check(MockPlayer, action, 1, 0.1)).to.equal(true)
		end)
	end)
end
