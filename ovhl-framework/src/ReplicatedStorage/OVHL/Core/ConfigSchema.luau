--!strict
-- @Core: ConfigSchema (Sanitized)
-- @Role: Structure Validation
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local SmartLogger = Loader.Get("Logger")

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
    local Log = SmartLogger.New("SCHEMA")
    local errs = validate(cfg, REQUIRED, name)
    
    if #errs > 0 then
        -- [FIX] Structured Error Log
        Log:Warn("ValidationFail", {
            Target = name,
            Count = #errs,
            Details = table.concat(errs, "; ")
        })
        return false
    end
    return true
end

return ConfigSchema
