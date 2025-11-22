-- @Core: Bridge (Unified Networking)
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)

local Enums = Loader.Core("Networking/NetworkEnums")
local Promise = Loader.Pkg("Promise")

local Bridge = {}
Bridge.__index = Bridge

local IS_SERVER = RunService:IsServer()
local REMOTES_FOLDER_NAME = "OVHL_Remotes"

local function getRemotesFolder()
    if IS_SERVER then
        local f = ReplicatedStorage:FindFirstChild(REMOTES_FOLDER_NAME)
        if not f then
            f = Instance.new("Folder")
            f.Name = REMOTES_FOLDER_NAME
            f.Parent = ReplicatedStorage
        end
        return f
    else
        return ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME)
    end
end

function Bridge.New()
    local self = setmetatable({}, Bridge)
    self._folder = getRemotesFolder()
    return self
end

-- [[ SERVER API ]]
function Bridge:Register(name, middlewareList)
    if not IS_SERVER then error("Register is Server-Only") end
    
    local rf = self._folder:FindFirstChild(name) or Instance.new("RemoteFunction", self._folder)
    rf.Name = name
    
    local re = self._folder:FindFirstChild(name .. "_Event") or Instance.new("RemoteEvent", self._folder)
    re.Name = name .. "_Event"
    
    return {
        OnInvoke = function(callback)
            rf.OnServerInvoke = function(player, ...)
                if middlewareList then
                    for _, mw in ipairs(middlewareList) do
                        local ok, err, code = mw(player, {...})
                        if not ok then
                            return { Success = false, Error = err, Code = code or Enums.Status.UNAUTHORIZED }
                        end
                    end
                end
                
                local success, result = pcall(callback, player, ...)
                if success then
                    return { Success = true, Data = result, Code = Enums.Status.OK }
                else
                    warn("[Bridge Error]", result)
                    return { Success = false, Error = "Internal Server Error", Code = Enums.Status.INTERNAL_ERROR }
                end
            end
        end,
        
        FireClient = function(_, player, data) re:FireClient(player, data) end,
        FireAll = function(_, data) re:FireAllClients(data) end
    }
end

-- [[ CLIENT API ]]
function Bridge:Request(name, ...)
    if IS_SERVER then error("Request is Client-Only") end
    local args = {...}
    return Promise.new(function(resolve, reject)
        local rf = self._folder:WaitForChild(name, 5)
        if not rf then return reject("Timeout: Service " .. name .. " not found") end
        
        local result = rf:InvokeServer(table.unpack(args))
        
        if type(result) == "table" and result.Success ~= nil then
            if result.Success then resolve(result.Data) else reject(result.Error) end
        else
            resolve(result)
        end
    end)
end

function Bridge:Listen(name, callback)
    local re = self._folder:WaitForChild(name .. "_Event", 5)
    if re then re.OnClientEvent:Connect(callback) end
end

return Bridge
