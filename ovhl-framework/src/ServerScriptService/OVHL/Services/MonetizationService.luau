-- @Service: MonetizationService
local MarketplaceService = game:GetService("MarketplaceService")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local MonetizationService = {}
local Handlers = {}

function MonetizationService:Init(ctx)
    self.Logger = ctx:CreateLogger("SHOP")
end

function MonetizationService:Start()
    MarketplaceService.ProcessReceipt = function(info)
        return self:Process(info)
    end
end

function MonetizationService:Shutdown() 
    -- No critical cleanup needed for receipts, handled by Roblox retry
end

function MonetizationService:RegisterProduct(id, func)
    Handlers[id] = func
end

function MonetizationService:Process(info)
    local handler = Handlers[info.ProductId]
    local player = game.Players:GetPlayerByUserId(info.PlayerId)
    
    if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
    
    if handler then
        local s, r = pcall(handler, player, info)
        if s then
            self.Logger:Info("Purchase OK", {Product=info.ProductId})
            return Enum.ProductPurchaseDecision.PurchaseGranted
        else
            self.Logger:Error("Purchase Error", {Error=r})
        end
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

return MonetizationService
