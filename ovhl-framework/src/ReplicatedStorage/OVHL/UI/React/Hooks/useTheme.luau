--!strict
-- @Hook: useTheme
-- @Role: Access Style System (Future: Dynamic Theme Context)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Style = Loader.Get("Style")

return function()
    -- Saat ini static, nanti bisa diganti useContext untuk Dynamic Theme
    return Style
end
