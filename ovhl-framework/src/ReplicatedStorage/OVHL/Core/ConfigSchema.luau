--!strict
-- @Core: ConfigSchema
-- Validasi struktur config agar tidak crash di runtime
local ConfigSchema = {}

local REQUIRED = {
    Meta = { Name="string", Type="string", Version="string" }
}

local function validate(data, schema, path)
    local errors = {}
    for field, expected in pairs(schema) do
        local val = data[field]
        local ctx = path .. "." .. field
        
        if val == nil then
            table.insert(errors, "Missing: " .. ctx)
        elseif type(expected) == "table" then
            if type(val) ~= "table" then
                table.insert(errors, ctx .. " must be table")
            else
                for _, e in ipairs(validate(val, expected, ctx)) do 
                    table.insert(errors, e) 
                end
            end
        elseif type(val) ~= expected then
            table.insert(errors, ctx .. " must be " .. expected)
        end
    end
    return errors
end

function ConfigSchema.Validate(cfg, name)
    local errs = validate(cfg, REQUIRED, name)
    if #errs > 0 then
        warn("[CONFIG ERROR] " .. name .. ":\n" .. table.concat(errs, "\n"))
        return false
    end
    return true
end

return ConfigSchema
