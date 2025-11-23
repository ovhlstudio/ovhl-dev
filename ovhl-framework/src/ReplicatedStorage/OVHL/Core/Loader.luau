--!strict
-- @Core: Loader v2.2 (Recursive Legacy Support)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Loader = {}

-- Root References
local ROOTS = {
	Core = ReplicatedStorage:WaitForChild("OVHL"):WaitForChild("Core"),
	Config = ReplicatedStorage.OVHL:WaitForChild("Config"),
	UI = ReplicatedStorage.OVHL:WaitForChild("UI"),
	SharedModules = ReplicatedStorage.OVHL:WaitForChild("Modules"),
	Packages = ReplicatedStorage:WaitForChild("Packages")
}

-- Helper: Listing Available Files
local function getAvailable(instance: Instance)
    local list = {}
    for _, c in ipairs(instance:GetChildren()) do table.insert(list, c.Name) end
    return table.concat(list, ", ")
end

-- [[ HELPER: PROXY GENERATOR ]]
local function createProxy(rootInstance: Instance, pathHistory: string)
	local proxy = newproxy(true)
	local meta = getmetatable(proxy)

	-- 1. DOT SYNTAX HANDLER (Modern)
	meta.__index = function(_, key)
		local currentPath = pathHistory .. "." .. key
		local child = rootInstance:FindFirstChild(key)

		-- Smart Package Resolution
		if not child and rootInstance == ROOTS.Packages then
			local lowerKey = key:lower()
			for _, c in ipairs(rootInstance:GetChildren()) do
				if c.Name:lower() == lowerKey or c.Name:find("_" .. lowerKey .. "@") then
					child = c
					break
				end
			end
		end

		if not child then
			error(string.format(
                "[Loader] ❌ Path Error: '%s' not found in %s.\n   Available: %s", 
                key, rootInstance.Name, getAvailable(rootInstance)
            ))
		end

		if child:IsA("ModuleScript") then
			return require(child)
		elseif child:IsA("Folder") then
			return createProxy(child, currentPath)
		else
			return child
		end
	end

	-- 2. CALL SYNTAX HANDLER (Legacy Recursive Fix)
    -- Menangani: Loader.Core("Networking/Bridge")
	meta.__call = function(_, pathString: string)
        local current = rootInstance
        
        -- [FIX] Split string by "/" untuk menelusuri folder
        for _, segment in ipairs(string.split(pathString, "/")) do
            local nextObj = current:FindFirstChild(segment)
            
            -- Fallback check untuk Packages (Wally renaming)
            if not nextObj and current == ROOTS.Packages then
                local lower = segment:lower()
                for _, c in ipairs(current:GetChildren()) do
                    if c.Name:lower() == lower or c.Name:find("_" .. lower .. "@") then
                        nextObj = c; break
                    end
                end
            end
            
            if not nextObj then
                error(string.format("[Loader] Legacy Path Error: Segment '%s' not found in '%s'. Path: %s", segment, current.Name, pathString))
            end
            
            current = nextObj
        end
        
        if current:IsA("ModuleScript") then
		    return require(current)
        else
            return current -- Return instance/folder
        end
	end
    
    meta.__tostring = function() return "LoaderProxy[" .. rootInstance.Name .. "]" end

	return proxy
end

-- [[ EXPORTS ]]
Loader.Core = createProxy(ROOTS.Core, "Core")
Loader.Config = createProxy(ROOTS.Config, "Config")
Loader.Pkg = createProxy(ROOTS.Packages, "Packages")
Loader.UI = createProxy(ROOTS.UI, "UI")

-- Feature Loader
Loader.Module = function(featureName: string, subModule: string?)
	local folder = ROOTS.SharedModules:FindFirstChild(featureName)
	if not folder then error("Feature not found: " .. featureName) end
	
    -- Legacy Support
    if subModule then
        local sub = folder:FindFirstChild(subModule)
        if not sub then error("SubModule '"..subModule.."' not found in " .. featureName) end
        return require(sub)
    end
    
    -- New Support
	return createProxy(folder, "Module." .. featureName)
end

-- Server Loader
if RunService:IsServer() then
	local ServerRoot = ServerScriptService:WaitForChild("OVHL")
	Loader.Server = createProxy(ServerRoot, "Server")
else
    Loader.Server = setmetatable({}, {
        __index = function() error("[Loader] Loader.Server cannot be used on Client!") end
    })
end

return Loader
