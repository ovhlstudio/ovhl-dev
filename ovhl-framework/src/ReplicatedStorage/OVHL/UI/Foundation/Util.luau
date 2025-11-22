-- @Foundation: UI Utilities
-- @Responsibility: Data Conversion & Asset Normalization
local Util = {}

-- [[ FONT CONVERTER ]]
-- Mengubah string config menjadi Font Object yang valid
function Util.ToFont(fontSource, weight, style)
    if typeof(fontSource) == "Font" then
        return fontSource
    elseif type(fontSource) == "string" then
        -- Default fallback args
        local w = weight or Enum.FontWeight.Regular
        local s = style or Enum.FontStyle.Normal
        
        -- Cek apakah ini Enum.Font legacy (jarang dipakai di framework modern) atau Asset ID
        if fontSource:match("^rbxasset") then
            return Font.new(fontSource, w, s)
        else
            -- Fallback jika string nama font biasa (Gotham, etc) - though Font.new usually takes ID
            return Font.new("rbxasset://fonts/families/GothamSSm.json", w, s)
        end
    end
    -- Fallback total
    return Font.new("rbxasset://fonts/families/GothamSSm.json")
end

-- [[ ASSET ID CLEANER ]]
-- Memastikan ID selalu format "rbxassetid://..."
function Util.CleanAssetId(id)
    if not id then return "" end
    local str = tostring(id)
    if str:match("^rbxasset") then return str end
    if str:match("^%d+$") then return "rbxassetid://" .. str end
    return str
end

return table.freeze(Util)
