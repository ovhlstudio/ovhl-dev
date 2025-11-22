-- @Core: Loader v0.3.1 (Case Insensitive Package Fix)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = {}

local ROOT_RS = ReplicatedStorage:WaitForChild("OVHL")
local ROOT_PACKAGES = ReplicatedStorage:WaitForChild("Packages")

local function requireByPath(root, pathStr, contextName)
    local current = root
    local segments = string.split(pathStr, "/")
    
    for i, name in ipairs(segments) do
        local found = current:FindFirstChild(name)
        
        -- [FIX] Smart Search for Packages (Handle wally naming & casing)
        if not found and contextName == "Packages" then
            local lowerName = name:lower()
            for _, child in ipairs(current:GetChildren()) do
                -- Matches "profileservice" or "author_profileservice@..."
                local childName = child.Name:lower()
                if childName == lowerName or childName:find("_" .. lowerName .. "@") then
                    found = child
                    break
                end
            end
        end

        if not found then
            local available = {}
            for _, c in ipairs(current:GetChildren()) do table.insert(available, c.Name) end
            error(string.format(
                "[Loader] Path Error in %s: '%s' not found inside '%s'.\nAvailable: %s", 
                contextName, name, current.Name, table.concat(available, ", ")
            ))
        end
        current = found
    end
    
    return require(current)
end

function Loader.Core(path) return requireByPath(ROOT_RS.Core, path, "Core") end
function Loader.Config(path) return requireByPath(ROOT_RS.Config, path, "Config") end
function Loader.Pkg(name) return requireByPath(ROOT_PACKAGES, name, "Packages") end
function Loader.UI(path) return requireByPath(ROOT_RS.UI, path, "UI") end

function Loader.Module(featureName, scriptName)
    local feature = ROOT_RS.Modules:FindFirstChild(featureName)
    if not feature then error("[Loader] Feature folder '" .. featureName .. "' does not exist.") end
    return requireByPath(feature, scriptName, "Module:"..featureName)
end

return table.freeze(Loader)
