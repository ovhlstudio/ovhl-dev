--!strict
-- @Core: FinderService (Auto Scanner with CCTV)
-- @Role: Robust UI Element Lookup
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [DEPENDENCIES]
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Logger = Loader.Get("Logger").New("UI")

local Finder = {}

-- Strategy: Direct Attribute > Tag > Recursive Name
function Finder.Get(query, root)
    root = root or PlayerGui
    
    -- 1. Direct Reference by Attribute (O(1))
    if type(query) == "string" then
        local attrRef = root:GetAttribute(query)
        if attrRef and typeof(attrRef) == "Instance" then
            -- Logger:Debug("Finder", {Msg="Found by Attribute", Query=query}) 
            return attrRef
        end
    end
    
    -- 2. CollectionService Tag (O(1) Lookup)
    local tagged = CollectionService:GetTagged(query)
    for _, obj in ipairs(tagged) do
        if obj:IsDescendantOf(root) then 
            -- Logger:Debug("Finder", {Msg="Found by Tag", Query=query})
            return obj 
        end
    end

    -- 3. Standard Name Search (Fast Child & Recursive)
    local child = root:FindFirstChild(query, true) 
    if child then 
        -- Logger:Debug("Finder", {Msg="Found by Name", Query=query})
        return child 
    end
    
    -- [CCTV] Lapor jika Gagal Total
    Logger:Warn("Missing", {
        Msg = "GUI Element Not Found", 
        Query = query, 
        Root = root.Name
    })
    
    return nil
end

-- Digunakan untuk resolve list component dari Config
function Finder.ResolveMap(screenName, componentMap)
    local root = PlayerGui:FindFirstChild(screenName)
    if not root then 
        Logger:Error("MissingScreen", {Screen=screenName})
        return nil, "ScreenGui " .. screenName .. " not found" 
    end
    
    local results = { _Root = root }
    local missing = {}
    
    for key, spec in pairs(componentMap) do
        local searchKey = (type(spec) == "table") and (spec.Tag or spec.Name) or spec
        local found = Finder.Get(searchKey, root)
        
        if found then
            results[key] = found
        else
            table.insert(missing, key .. " (" .. tostring(searchKey) .. ")")
        end
    end
    
    if #missing > 0 then
        Logger:Warn("IncompleteMap", {Screen=screenName, Missing=table.concat(missing, ",")})
        return nil, "Missing Components: " .. table.concat(missing, ", ")
    end
    
    -- Logger:Info("Resolved", {Screen=screenName, Count=0}) -- Optional info
    return results
end

return Finder
