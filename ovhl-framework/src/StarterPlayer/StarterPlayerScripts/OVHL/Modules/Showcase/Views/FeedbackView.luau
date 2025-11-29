local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")
local Atoms = Loader.Get("Atoms")
-- [NEW] Import Custom Hook
local useActionGuard = require(RS.OVHL.UI.React.Hooks.useActionGuard)

local e = React.createElement

return function(props)
    -- [HOOK USAGE]
    -- Wrap the Controller Action with the Guard
    local spamAction, isLocked = useActionGuard(
        props.State.Actions.PingServer, -- The Real Action
        props.Config.Security.ButtonSpamLimit, -- The Limit Rule
        props.State.Actions.TriggerToast -- The Feedback Channel
    )

    return e("Frame", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1 }, {
        Layout = e("UIListLayout", { Padding=UDim.new(0,10), HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center }),
        
        T1 = e(Atoms.Text, { Content="END-TO-END NETWORK TEST", Variant="H2" }),
        T2 = e(Atoms.Text, { Content="Spamming below sends Ping to Server", Variant="Caption", Color="Muted" }),
        
        -- Button Logic is now Data Driven from Hook
        B1 = e(Atoms.Button, { 
            Text = isLocked and "COOLDOWN..." or "PING SERVER", 
            Variant = isLocked and "Danger" or "Primary",
            Disabled = isLocked, -- Auto Disable Visual
            OnClick = spamAction -- Auto Guard Logic
        }),
        
        Div = e(Atoms.Divider, { Direction="Horizontal" }),
        
        B2 = e(Atoms.Button, { Text="LOCAL TOAST", Variant="Ghost", OnClick=function() props.State.Actions.TriggerToast("Hello", "Success") end }),
        B3 = e(Atoms.Button, { Text="LOCAL MODAL", Variant="Ghost", OnClick=props.State.Actions.TriggerModal }),
        Back = e(Atoms.Button, { Text="Back", Variant="Danger", OnClick=function() props.State.Actions.Navigate("Home") end })
    })
end
