--!strict
-- @Core: Constants
-- @Role: Single Source of Truth
local Constants = {
    SYSTEM = {
        VERSION = "0.2.0",
        NAME = "OVHL Framework"
    },
    NET = {
        TIMEOUT = 10,
        RETRY_ATTEMPTS = 3
    },
    ROLES = {
        GUEST = "Guest",
        ADMIN = "Admin",
        OWNER = "Owner"
    }
}
return table.freeze(Constants)
