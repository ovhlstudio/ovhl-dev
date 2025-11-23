--!strict
-- @Core: Middleware (Chain of Responsibility)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Enums = Loader.Core("Networking/NetworkEnums")

local Middleware = {}

-- Tipe: function(player, requestData) -> (shouldContinue, errorMsg, statusCode)

function Middleware.RateLimiter(maxRequests, interval)
    return function(player, _)
        -- TODO: Implementasi Real Rate Limit di Phase 4
        return true
    end
end

function Middleware.AdminOnly(rankId)
    return function(player, _)
        -- Mockup: Selalu boleh di Studio
        if game:GetService("RunService"):IsStudio() then return true end
        return false, "Access Denied", Enums.Status.FORBIDDEN
    end
end

function Middleware.Validator(schema)
    return function(_, args)
        if not args then return false, "Missing Arguments", Enums.Status.BAD_REQUEST end
        return true
    end
end

return Middleware
