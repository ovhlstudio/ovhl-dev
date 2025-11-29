--!strict
-- @View: GridView (Wired)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local Molecules = Loader.Get("Molecules")
local useObservable = require(RS.OVHL.UI.React.Hooks.useObservable)
local e = React.createElement

return function(props)
    local inventoryData = useObservable(props.State.InventoryList) or {}
    local items = {}
    
    for _, item in ipairs(inventoryData) do
        -- [LOGIC] Tampilkan status Equipped
        local subTitle = item.Rarity
        if item.Equipped then subTitle = "⚔️ EQUIPPED • " .. subTitle end
        
        items[item.Id] = e(Molecules.Card, { 
            Title = item.Name, 
            Subtitle = subTitle,
            Icon = item.Icon,
            Size = UDim2.fromOffset(100, 120),
            
            -- [ACTION] Panggil EquipItem di Controller -> Server
            OnClick = function() 
                props.State.Actions.EquipItem(item.Id, item.Name)
            end
        })
    end
    
    items.Grid = e("UIGridLayout", { CellSize=UDim2.fromOffset(100, 120), CellPadding=UDim2.fromOffset(10,10) })
    
    return e("Frame", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1 }, {
        Layout = e("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder }),
        Header = e("Frame", { Size=UDim2.new(1,0,0,40), BackgroundTransparency=1 }, {
            Layout = e("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,10) }),
            Back = e(Atoms.Button, { Text="Back", Size=UDim2.fromOffset(80,30), OnClick=function() props.State.Actions.Navigate("Home") end }),
            Count = e(Atoms.Badge, { Text=#inventoryData .. " Items (Server)", Variant="Success" })
        }),
        Scroll = e(Atoms.ScrollView, { Size=UDim2.new(1,0,1,-40), ContentPadding=UDim.new(0,10) }, items)
    })
end
