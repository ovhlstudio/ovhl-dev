local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
local e = React.createElement

return function(props)
    local setPos = props.State.Actions.SetLayout
    return e(Atoms.Surface, { Layout=Enum.FillDirection.Vertical, Padding=UDim.new(0,20) }, {
        Title = e(Atoms.Text, { Content="9-SLICE LAYOUT ENGINE", Variant="H2", Align=Enum.TextXAlignment.Center }),
        
        GridWrapper = e("Frame", { Size=UDim2.fromOffset(200, 200), BackgroundTransparency=1, LayoutOrder=2 }, {
            -- PENTING: Container harus ditengah agar layout grid 3x3 terlihat rapi
            Anchor = e("UIAspectRatioConstraint", { AspectRatio=1 }),
            Layout = e("UIGridLayout", { CellSize=UDim2.fromScale(0.3,0.3), CellPadding=UDim2.fromScale(0.05, 0.05) }),
            
            B1 = e(Atoms.Button, { Text="TL", Size=UDim2.fromScale(1,1), OnClick=function() setPos("TopLeft") end }),
            B2 = e(Atoms.Button, { Text="TC", Size=UDim2.fromScale(1,1), OnClick=function() setPos("TopCenter") end }),
            B3 = e(Atoms.Button, { Text="TR", Size=UDim2.fromScale(1,1), OnClick=function() setPos("TopRight") end }),
            B4 = e(Atoms.Button, { Text="CL", Size=UDim2.fromScale(1,1), OnClick=function() setPos("MiddleLeft") end }),
            B5 = e(Atoms.Button, { Text="C",  Size=UDim2.fromScale(1,1), Variant="Primary", OnClick=props.State.Actions.ResetWindow }),
            B6 = e(Atoms.Button, { Text="CR", Size=UDim2.fromScale(1,1), OnClick=function() setPos("MiddleRight") end }),
            B7 = e(Atoms.Button, { Text="BL", Size=UDim2.fromScale(1,1), OnClick=function() setPos("BottomLeft") end }),
            B8 = e(Atoms.Button, { Text="BC", Size=UDim2.fromScale(1,1), OnClick=function() setPos("BottomCenter") end }),
            B9 = e(Atoms.Button, { Text="BR", Size=UDim2.fromScale(1,1), OnClick=function() setPos("BottomRight") end }),
        }),
        
        Back = e(Atoms.Button, { Text="Back", OnClick=function() props.State.Actions.Navigate("Home") end, LayoutOrder=3 })
    })
end
