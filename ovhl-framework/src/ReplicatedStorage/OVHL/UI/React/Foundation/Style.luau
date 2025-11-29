--!strict
local Style = {}
local P = {
    Slate900 = Color3.fromHex("#0f172a"), Slate800 = Color3.fromHex("#1e293b"), Slate700 = Color3.fromHex("#334155"),
    Slate600 = Color3.fromHex("#475569"), Slate400 = Color3.fromHex("#94a3b8"), Blue500 = Color3.fromHex("#3b82f6"),
    Blue600  = Color3.fromHex("#2563eb"), Red500 = Color3.fromHex("#ef4444"), Red700 = Color3.fromHex("#b91c1c"),
    Green500 = Color3.fromHex("#22c55e"), White = Color3.fromHex("#ffffff")
}
Style.Colors = {
    Background = { Main = P.Slate900, Surface = P.Slate800, Overlay = Color3.new(0,0,0) },
    Text = { Main = P.White, Muted = P.Slate400, Inverted= P.Slate900 },
    Action = {
        Primary = { Default = P.Blue500, Hover = P.Blue600, Press = P.Slate700, Content = P.White },
        Danger = { Default = P.Red500, Hover = P.Red700, Press = P.Slate600, Content = P.White },
        Ghost = { Default = P.Slate800, Hover = P.Slate700, Press = P.Slate600, Content = P.Slate400 }
    },
    Border = P.Slate600, Success = P.Green500
}
Style.Metrics = { Corner = { Small=UDim.new(0,4), Medium=UDim.new(0,8), Large=UDim.new(0,16) }, Padding = { Small=UDim.new(0,8), Medium=UDim.new(0,16) }, IconSize = { Medium=UDim2.fromOffset(24,24) } }
Style.Fonts = { Header = Enum.Font.GothamBold, Body = Enum.Font.GothamMedium, Caption = Enum.Font.Gotham }
Style.TextSize = { H1 = 32, H2 = 24, Body = 14, Small = 12 }
Style.ZIndex = { Base = 1, Card = 10, Modal = 1000, Toast = 2000 }
Style.Opacity = { Dim = 0.5, Ghost = 1 }
return table.freeze(Style)
