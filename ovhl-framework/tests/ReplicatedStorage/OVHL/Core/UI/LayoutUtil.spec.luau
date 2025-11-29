return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
    local LayoutUtil = Loader.Get("LayoutUtil")

    describe("LayoutUtil Smart Scaling", function()
        -- Kita tidak bisa mock workspace.CurrentCamera di TestEZ standard dengan mudah
        -- Jadi kita test fungsi Get() yang deterministik
        
        it("should return correct anchor points", function()
            local res = LayoutUtil.Get({ Position = "TopLeft" })
            expect(res.AnchorPoint.X).to.equal(0)
            expect(res.AnchorPoint.Y).to.equal(0)
            
            local res2 = LayoutUtil.Get({ Position = "Center" })
            expect(res2.AnchorPoint.X).to.equal(0.5)
            expect(res2.AnchorPoint.Y).to.equal(0.5)
        end)
        
        it("should handle margins correctly", function()
            local res = LayoutUtil.Get({ Position = "BottomRight", Margin = 20 })
            -- BottomRight logic: moveY = -margin
            expect(res.Position.Y.Offset).to.equal(-20)
        end)
    end)
end
