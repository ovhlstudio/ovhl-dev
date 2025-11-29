local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader); local React = Loader.Get("React"); local Atoms = Loader.Get("Atoms"); local Molecules = Loader.Get("Molecules"); local useObservable = require(RS.OVHL.UI.React.Hooks.useObservable); local e = React.createElement
return function(props)
    local txt = useObservable(props.State.Inputs.Search); local mus = useObservable(props.State.Toggles.Music); local vol = useObservable(props.State.Slider)
    return e(Atoms.ScrollView, {}, {
        Settings = e(Molecules.Section, { Title="SETTINGS" }, {
            Row1 = e("Frame", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1 }, { Layout = e("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal }), Label = e(Atoms.Text, { Content="Music Enabled", Size=UDim2.fromScale(0.7, 1) }), Sw = e(Atoms.Toggle, { IsOn=mus, OnToggle=function(v) props.State.Toggles.Music:Set(v) end }) }),
            Row2 = e("Frame", { Size=UDim2.new(1,0,0,40), BackgroundTransparency=1 }, { Layout = e("UIListLayout", { FillDirection=Enum.FillDirection.Vertical }), Label = e(Atoms.Text, { Content="Volume: " .. math.floor(vol*100) .. "%" }), Slide = e(Atoms.Slider, { Value=vol, OnChanged=props.State.Actions.SetVolume }) }),
            Field = e(Atoms.TextField, { Text=txt, Placeholder="Username...", OnChanged=function(v) props.State.Inputs.Search:Set(v) end }),
            Locked = e(Atoms.Button, { Text="Admin Only", Permission=10, Variant="Danger" })
        }),
        Back = e(Atoms.Button, { Text="Back", OnClick=function() props.State.Actions.Navigate("Home") end })
    })
end
