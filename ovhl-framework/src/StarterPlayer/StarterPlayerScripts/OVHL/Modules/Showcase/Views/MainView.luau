--!strict
-- @View: MainView (Persistent Architecture)
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React")

local Molecules = Loader.Get("Molecules")
local Atoms = Loader.Get("Atoms")
local Views = require(script.Parent.Package) 
local useObservable = require(RS.OVHL.UI.React.Hooks.useObservable)

local e = React.createElement

return function(props)
    -- [CRITICAL] Kita subscribe ke Visible, tapi TIDAK untuk return nil.
    -- Kita pass value ini ke Window agar dia bisa animasi Exit.
    local visible = useObservable(props.State.Visible)
    
    local currentTab = useObservable(props.State.CurrentTab)
    local winSize = useObservable(props.State.WindowSize)
    local winPos = useObservable(props.State.WindowPos)
    local winAnchor = useObservable(props.State.WindowAnchor)
    
    local modalData = useObservable(props.State.ActiveModal)
    local toastData = useObservable(props.State.ActiveToast)

    -- [REMOVED] if not visible then return nil end <-- BIANG KEROK HILANGNYA ANIMASI

    local ActiveView = Views[currentTab] or Views.Home
    local baseTitle = props.Config.UI.Title or "OVHL"
    local fullTitle = string.format("%s // %s", baseTitle, string.upper(currentTab))

    return React.createElement(React.Fragment, nil, {
        Window = e(Molecules.Window, {
            Title = fullTitle,
            Size = winSize,
            _OverridePos = winPos, 
            _OverrideAnchor = winAnchor,
            
            -- [NEW] Pass Visibility State to Window Component
            Visible = visible,
            
            OnClose = function() props.State.Visible:Set(false) end
        }, {
            Content = e(ActiveView, props)
        }),
        
        ModalLayer = modalData and e(Molecules.Modal, {
            Title = modalData.Title,
            OnClose = modalData.OnCancel,
            OnAction = modalData.OnConfirm,
            ActionLabel = modalData.ActionLabel,
            Size = UDim2.fromOffset(400, 200)
        }, {
            Msg = e(Atoms.Text, { Content = modalData.Body, Variant = "Body", Align = Enum.TextXAlignment.Center, Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y })
        }),
        
        ToastLayer = toastData and e(Molecules.Toast, {
            Message = toastData.Message,
            Variant = toastData.Variant,
            Duration = 3,
            OnDismiss = props.State.Actions.DismissToast,
            key = tostring(toastData.ID) 
        })
    })
end
