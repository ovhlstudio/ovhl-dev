return function()
    local ServerScriptService = game:GetService("ServerScriptService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Loader = require(ReplicatedStorage.OVHL.Core.Loader)
    
    -- Load Service secara manual (Bypass ServerKernel boot)
    local InventoryService = require(ServerScriptService.OVHL.Modules.Inventory.InventoryService)
    local Mock = require(ReplicatedStorage.Tests.Mocks.MockUtils)

    describe("Inventory Service Logic", function()
        -- Mock Context
        local ctx = {
            CreateLogger = function() 
                return { Info=function()end, Warn=function()end, Error=function()end } 
            end,
            Network = Mock.GetBridge(),
            Services = {
                DataManagerService = {
                    Get = function() 
                        return { Inventory = {} } -- Mock Data Kosong
                    end
                }
            }
        }

        it("should initialize safely", function()
            expect(function()
                InventoryService:Init(ctx)
            end).never.to.throw()
        end)

        it("should give starter items on empty inventory", function()
            local player = Mock.GetPlayer()
            
            -- Panggil fungsi GetItems
            local result = InventoryService:GetItems(player)
            
            expect(result.Success).to.equal(true)
            expect(#result.Data).to.equal(2) -- Starter Sword + Potion
            expect(result.Data[1].Name).to.equal("Starter Sword")
        end)
        
        -- Test Private Function via Loophole (atau test public behavior)
        it("should handle item creation from DB", function()
            local item = InventoryService:_createItem(1)
            expect(item).to.be.ok()
            expect(item.Name).to.equal("Starter Sword")
            expect(item.Rarity).to.equal("Common")
            expect(item.UniqueId).to.be.a("string")
        end)
    end)
end
