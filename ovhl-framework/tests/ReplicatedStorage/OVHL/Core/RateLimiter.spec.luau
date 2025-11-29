--!strict
return function()
	local RS = game:GetService("ReplicatedStorage")
    -- [FIX] Load via Loader
	local Loader = require(RS.OVHL.Core.Loader)
	local RateLimiter = Loader.Get("RateLimiter")

	local MockPlayer = { UserId = 99999 }

	describe("[UNIT-TEST] RateLimiter (Shared)", function()
		it("should initialize correctly", function()
			local limiter = RateLimiter.New()
			expect(limiter).to.be.ok()
		end)

		it("should BLOCK requests exceeding quota", function()
			local limiter = RateLimiter.New()
			local action = "SpamTest"
			local limit = 5
            local interval = 10

			for i = 1, limit do
				local allowed = limiter:Check(MockPlayer, action, limit, interval)
				expect(allowed).to.equal(true)
			end

			local spam = limiter:Check(MockPlayer, action, limit, interval)
			expect(spam).to.equal(false)
		end)
	end)
end
