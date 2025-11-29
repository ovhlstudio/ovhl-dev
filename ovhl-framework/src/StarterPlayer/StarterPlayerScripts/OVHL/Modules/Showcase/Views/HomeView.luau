--!strict
-- @View: HomeView (Data Driven Generation)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local Molecules = Loader.Get("Molecules")
local e = React.createElement

return function(props)
    local nav = props.State.Actions.Navigate
    
    -- [DATA DRIVEN UI]
    -- Membaca Config.Navigation dan men-generate Card secara otomatis
    local menuItems = {}
    local navData = props.Config.Navigation or {}
    
    -- Sort by Order (Just in case config is unsorted)
    table.sort(navData, function(a,b) return a.Order < b.Order end)
    
    menuItems.Layout = e("UIGridLayout", { 
        CellSize = UDim2.fromOffset(130, 140), 
        CellPadding = UDim2.fromOffset(12,12),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    for _, item in ipairs(navData) do
        menuItems[item.Id] = e(Molecules.Card, {
            Title = item.Label,
            Subtitle = item.Desc,
            Icon = item.Icon,
            Size = UDim2.fromOffset(130, 140),
            LayoutOrder = item.Order,
            OnClick = function() nav(item.Id) end
        })
    end
    
    return e(Atoms.ScrollView, { ContentPadding = UDim.new(0, 12) }, {
        Header = e(Molecules.Section, { Title = "SYSTEM MODULES" }, {
            Grid = e("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.fromScale(1, 0),
                BackgroundTransparency = 1
            }, menuItems)
        })
    })
end
