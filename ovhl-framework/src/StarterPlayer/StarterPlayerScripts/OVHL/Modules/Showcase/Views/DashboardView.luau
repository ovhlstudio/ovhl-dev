local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local Molecules = Loader.Get("Molecules")
local e = React.createElement

return function(props)
    return e(Atoms.Surface, { Tag="Surface", Layout=Enum.FillDirection.Horizontal }, {
        Sidebar = e("Frame", { Size=UDim2.new(0, 120, 1, 0), BackgroundTransparency=1 }, {
            List = e("UIListLayout", { Padding=UDim.new(0,5) }),
            Btn1 = e(Atoms.Button, { Text="Users", Variant="Ghost", Size=UDim2.new(1,0,0,30) }),
            Btn2 = e(Atoms.Button, { Text="Logs", Variant="Ghost", Size=UDim2.new(1,0,0,30) }),
            Div = e(Atoms.Divider, { Direction="Horizontal" }),
            Back = e(Atoms.Button, { Text="< Back", Variant="Danger", Size=UDim2.new(1,0,0,30), OnClick=function() props.State.Actions.Navigate("Home") end })
        }),
        Divider = e(Atoms.Divider, { Direction="Vertical" }),
        Content = e("Frame", { Size=UDim2.new(1,-130,1,0), BackgroundTransparency=1 }, {
            Layout = e("UIListLayout", { HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center }),
            Info = e(Atoms.Text, { Content="Dashboard Active", Variant="H2" })
        })
    })
end
