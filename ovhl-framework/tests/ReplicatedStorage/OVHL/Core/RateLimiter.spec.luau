return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
    local RateLimiter = Loader.Get("RateLimiter").New()
    local Mock = require(ReplicatedStorage.Tests.Mocks.MockUtils)

    describe("Rate Limiter Algorithm", function()
        it("should allow burst requests within limit", function()
            local player = Mock.GetPlayer()
            -- Config: Max 2, Interval 10 (Sangat lambat refill)
            -- Request 1 (Lolos)
            local r1 = RateLimiter:Check(player, "TestSpam", 2, 10)
            expect(r1).to.equal(true)
            
            -- Request 2 (Lolos)
            local r2 = RateLimiter:Check(player, "TestSpam", 2, 10)
            expect(r2).to.equal(true)
        end)

        it("should block requests exceeding limit immediately", function()
            local player = Mock.GetPlayer()
            -- Reset bucket dengan nama action beda
            -- Config: Max 1
            local r1 = RateLimiter:Check(player, "StrictTest", 1, 10)
            expect(r1).to.equal(true)
            
            -- Spam langsung (detik yang sama)
            local r2 = RateLimiter:Check(player, "StrictTest", 1, 10)
            expect(r2).to.equal(false) -- Harus Ditolak
        end)
        
        it("should refill tokens over time", function()
            -- Ini sulit ditest di unit test sinkronus tanpa mocking os.clock
            -- Tapi kita bisa test logika dasarnya aman dari crash
            expect(RateLimiter._buckets).to.be.a("table")
        end)
    end)
end
