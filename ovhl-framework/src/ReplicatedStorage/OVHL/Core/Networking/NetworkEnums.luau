-- @Core: NetworkEnums
-- Standar Status Code ala HTTP untuk Game Networking
return table.freeze({
    Status = {
        OK = 200,
        BAD_REQUEST = 400,
        UNAUTHORIZED = 401,
        FORBIDDEN = 403,
        NOT_FOUND = 404,
        RATE_LIMITED = 429,
        INTERNAL_ERROR = 500
    },
    Events = {
        SystemHandshake = "SYS_HANDSHAKE",
        SystemPing = "SYS_PING"
    }
})
