--!strict
return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	-- NetworkGuard akan log warning ke console, itu tanda dia bekerja.
	local Guard = require(ServerScriptService.OVHL.Core.NetworkGuard)

	describe("[UNIT-TEST] NetworkGuard (CPU Firewall)", function()
		it("should BLOCK Instances (Anti-Injection)", function()
			local maliciousPart = Instance.new("Part")
			maliciousPart.Name = "Virus"

			local clean = Guard.CleanIn(maliciousPart, 0, nil)
			expect(clean).to.equal(nil) -- Harus dimusnahkan jadi nil

			maliciousPart:Destroy()
		end)

		it("should TRUNCATE massive strings (Memory Protect)", function()
			-- Buat string 5000 karakter
			local longString = string.rep("A", 5000)

			local clean = Guard.CleanIn(longString, 0, nil)
			expect(#clean).to.equal(4096) -- Batas max di config Guard
			expect(clean).never.to.equal(longString)
		end)

		it("should NEUTRALIZE NaN and Infinity (Math Protect)", function()
			local nan = 0 / 0
			local inf = math.huge

			expect(Guard.CleanIn(nan, 0)).to.equal(0)
			expect(Guard.CleanIn(inf, 0)).to.equal(0)
			expect(Guard.CleanIn(-inf, 0)).to.equal(0)
			expect(Guard.CleanIn(123, 0)).to.equal(123) -- Angka normal aman
		end)

		it("should RECURSIVELY clean nested tables", function()
			local dirtyTable = {
				Safe = "Yes",
				Deep = {
					Bad = math.huge, -- Nested Bad Number
					Deeper = {
						Part = Instance.new("Folder"), -- Nested Instance
					},
				},
			}

			local clean = Guard.CleanIn(dirtyTable, 0)

			expect(clean.Safe).to.equal("Yes")
			expect(clean.Deep.Bad).to.equal(0) -- Jadi 0
			expect(clean.Deep.Deeper.Part).to.equal(nil) -- Jadi nil
		end)
	end)
end
