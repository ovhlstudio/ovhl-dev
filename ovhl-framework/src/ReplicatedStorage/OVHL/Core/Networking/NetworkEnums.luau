--!strict
-- @Core: NetworkEnums v0.2.0
-- @Role: Shared Protocol Definitions
local NetworkEnums = {}

-- [[ HTTP-LIKE STATUS CODES ]]
NetworkEnums.Status = {
	OK = 200,
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	NOT_FOUND = 404,
	TIMEOUT = 408,
	RATE_LIMITED = 429,
	INTERNAL_ERROR = 500,
}

-- [[ PACKET HEADERS ]]
-- Menggunakan singkatan 1 huruf untuk menghemat Bandwidth (Byte Optimization)
NetworkEnums.Packet = {
	REQUEST = "R", -- Client -> Server (Butuh Balasan)
	RESPONSE = "A", -- Server -> Client (Jawaban/Ack)
	EVENT = "E", -- One Way (Fire & Forget)
}

-- [[ RESERVED EVENTS ]]
NetworkEnums.Events = {
	SystemHandshake = "SYS_HANDSHAKE",
	SystemPing = "SYS_PING",
}

return table.freeze(NetworkEnums)
