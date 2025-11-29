local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local e = React.createElement

return function(props)
    return e(Atoms.Surface, { Layout=Enum.FillDirection.Horizontal }, {
        Left = e("Frame", { Size=UDim2.fromScale(0.5, 1), BackgroundColor3=Atoms.Style.Colors.Background.Surface }, {
            Layout = e("UIListLayout", { VerticalAlignment=Enum.VerticalAlignment.Center, HorizontalAlignment=Enum.HorizontalAlignment.Center }),
            T1 = e(Atoms.Text, { Content="PLAYER A", Variant="H2" })
        }),
        Div = e(Atoms.Divider, { Direction="Vertical" }),
        Right = e("Frame", { Size=UDim2.fromScale(0.5, 1), BackgroundTransparency=1 }, {
            Layout = e("UIListLayout", { VerticalAlignment=Enum.VerticalAlignment.Center, HorizontalAlignment=Enum.HorizontalAlignment.Center, Padding=UDim.new(0,10) }),
            T2 = e(Atoms.Text, { Content="PLAYER B", Variant="H2" }),
            Back = e(Atoms.Button, { Text="Back", OnClick=function() props.State.Actions.Navigate("Home") end })
        })
    })
end
