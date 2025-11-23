--!strict
-- @Page: PermissionPage (Grid Layout Typo Fixed)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.UI.Foundation.API
local Children = UI.Children
local Fusion = UI.Fusion

local DUMMY_DATA = {
    { UserId = 1, Name = "Roblox", Rank = 5, Role = "God" },
    { UserId = 2, Name = "JohnDoe", Rank = 2, Role = "Mod" },
}

local RANKS = {
    { Id = 0, Label = "GUEST", Color = "BaseContent" },
    { Id = 1, Label = "VIP",   Color = "Primary" },
    { Id = 2, Label = "MOD",   Color = "Primary" },
    { Id = 3, Label = "ADMIN", Color = "Primary" },
    { Id = 4, Label = "HEAD",  Color = "Error" },
    { Id = 5, Label = "OWNER", Color = "Error" }
}

return function(scope, props)
    local State = props.State
    local Actions = props.Actions
    local SearchText = scope:Value("")
    local C = UI.Theme.Colors

    -- [[ PLAYER ROW ]]
    local function PlayerRow(innerScope, player)
        local badgeColor = Fusion.peek(C.BaseContent.Main)
        local badgeText = "GUEST"
        if player.Rank >= 5 then badgeColor = Fusion.peek(C.Error.Main); badgeText = "OWNER"
        elseif player.Rank >= 3 then badgeColor = Fusion.peek(C.Primary.Main); badgeText = "ADMIN"
        elseif player.Rank >= 1 then badgeColor = Color3.fromHex("3b82f6"); badgeText = string.upper(player.Role)
        else badgeText = string.upper(player.Role) end

        return innerScope:New "TextButton" {
            Name = "Card_" .. player.Name, Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = UI.Theme.Colors.Base.Main, AutoButtonColor = true, Text = "",
            [UI.OnEvent "Activated"] = function() Actions.OpenInspector(player) end,
            [Children] = {
                innerScope:New "UICorner" { CornerRadius = UDim.new(0, 8) },
                innerScope:New "UIStroke" { Color = UI.Theme.Colors.Neutral.Main, Transparency = 0.6, Thickness = 1.5 },
                innerScope:New "UIPadding" { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) },
                innerScope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder },
                
                innerScope:New "ImageLabel" { LayoutOrder = 1, Size = UDim2.fromOffset(48, 48), BackgroundColor3 = UI.Theme.Colors.Base.Alt, Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150", [Children] = { innerScope:New "UICorner" { CornerRadius = UDim.new(1, 0) } } },
                
                innerScope:New "Frame" { LayoutOrder = 2, Size = UDim2.new(0.4, 0, 1, 0), BackgroundTransparency = 1, [Children] = {
                    innerScope:New "UIListLayout" { SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center },
                    innerScope:SmartText { Text = player.Name, Variant = "Body", Size = 16, LayoutOrder = 1, Color = "BaseContent" },
                    innerScope:New "TextLabel" { LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Text = "ID: " .. player.UserId, TextColor3 = UI.Theme.Colors.BaseContent.Main, TextTransparency = 0.4, TextSize = 14, FontFace = UI.Theme.Font.Body, TextXAlignment = Enum.TextXAlignment.Left }
                }},
                
                innerScope:New "Frame" { LayoutOrder = 3, Size = UDim2.new(0.4, 0, 1, 0), BackgroundTransparency = 1, [Children] = {
                    innerScope:New "UIListLayout" { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center },
                    innerScope:New "Frame" { Size = UDim2.fromOffset(100, 28), BackgroundColor3 = badgeColor, BackgroundTransparency = 0.9, [Children] = {
                        innerScope:New "UICorner" { CornerRadius = UDim.new(1, 0) },
                        innerScope:New "UIStroke" { Color = badgeColor, Transparency = 0.2, Thickness = 1.5 },
                        innerScope:New "TextLabel" { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = badgeText, TextColor3 = badgeColor, FontFace = UI.Theme.Font.Body, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center }
                    }}
                }}
            }
        }
    end

    -- [[ MAIN RENDERER ]]
    return UI.Computed(scope, function(use)
        local selectedPlayer = use(State.SelectedPlayer)

        -- === INSPECTOR VIEW ===
        if selectedPlayer then
            return scope:New "Frame" {
                Name = "InspectorView", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                [Children] = {
                    scope:New "UIListLayout" { Padding = UDim.new(0, 16), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical },
                    
                    -- Header
                    scope:New "Frame" { Name = "Header", Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, [Children] = {
                        scope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 12) },
                        scope:AsyncButton { Text = "< BACK", Size = UDim2.fromOffset(80, 36), Style = "Outline", OnClick = function() Actions.CloseInspector() end },
                        scope:SmartText { Text = "INSPECTING: " .. string.upper(selectedPlayer.Name), Variant = "Header", Size = 18 }
                    }},
                    
                    -- Body
                    scope:New "Frame" { Name = "Body", Size = UDim2.new(1, 0, 1, -56), BackgroundTransparency = 1, [Children] = {
                        scope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 16) },
                        -- Identity
                        scope:New "Frame" { Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = UI.Theme.Colors.Base.Main, [Children] = {
                            scope:New "UICorner" { CornerRadius = UDim.new(0, 8) }, scope:New "UIStroke" { Color = UI.Theme.Colors.Neutral.Main, Transparency = 0.7 }, scope:New "UIPadding" { PaddingTop=UDim.new(0,20), PaddingBottom=UDim.new(0,20) }, scope:New "UIListLayout" { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder },
                            scope:New "ImageLabel" { LayoutOrder = 1, Size = UDim2.fromOffset(100, 100), BackgroundColor3 = UI.Theme.Colors.Base.Alt, Image = "rbxthumb://type=AvatarHeadShot&id=" .. selectedPlayer.UserId .. "&w=420&h=420", [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(1, 0) } } },
                            scope:SmartText { LayoutOrder=2, Text = selectedPlayer.Name, Size = 18, Variant = "Header", Align = Enum.TextXAlignment.Center },
                            scope:SmartText { LayoutOrder=3, Text = "Rank: " .. selectedPlayer.Rank, Size = 14, Color = "Neutral", Align = Enum.TextXAlignment.Center }
                        }},
                        -- Controls
                        scope:New "Frame" { Size = UDim2.new(0.65, -16, 1, 0), BackgroundColor3 = UI.Theme.Colors.Base.Main, [Children] = {
                            scope:New "UICorner" { CornerRadius = UDim.new(0, 8) }, scope:New "UIStroke" { Color = UI.Theme.Colors.Neutral.Main, Transparency = 0.7 }, scope:New "UIPadding" { PaddingTop=UDim.new(0,20), PaddingLeft=UDim.new(0,20), PaddingRight=UDim.new(0,20) }, scope:New "UIListLayout" { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder },
                            scope:SmartText { Text = "CHANGE RANK", Variant = "Header", Size = 16 },
                            scope:New "Frame" { Size = UDim2.new(1, 0, 0, 200), BackgroundTransparency = 1, [Children] = {
                                -- [FIX] Typo Fixed: UDim2 for CellPadding
                                scope:New "UIGridLayout" { CellSize = UDim2.new(0.31, 0, 0, 50), CellPadding = UDim2.new(0.03, 0, 0.03, 0), FillDirectionMaxCells = 3 },
                                UI.ForValues(scope, RANKS, function(use, innerScope, rank)
                                    local isCurrent = rank.Id == selectedPlayer.Rank
                                    local style = isCurrent and "Filled" or "Outline"
                                    return innerScope:AsyncButton { Text = rank.Label .. "\n["..rank.Id.."]", Style = style, Color = isCurrent and UI.Theme.Colors.Primary.Main or nil, OnClick = function() if not isCurrent then Actions.RequestRankChange(selectedPlayer, rank.Id, rank.Label) end end }
                                end)
                            }}
                        }}
                    }}
                }
            }
        end

        -- === LIST VIEW ===
        local FilteredList = {}
        local query = use(SearchText):lower()
        local realData = use(State.PlayerList)
        local function match(p) if query == "" then return true end if string.find(p.Name:lower(), query, 1, true) then return true end if string.find(tostring(p.UserId), query, 1, true) then return true end return false end
        for _, p in ipairs(realData) do if match(p) then table.insert(FilteredList, p) end end
        for _, p in ipairs(DUMMY_DATA) do if match(p) then table.insert(FilteredList, p) end end

        return scope:New "Frame" {
            Name = "ListView", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            [Children] = {
                scope:New "UIListLayout" { Padding = UDim.new(0, 16), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical },
                scope:New "Frame" { Name = "HeaderSplit", LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 84), BackgroundTransparency = 1, [Children] = {
                    scope:New "Frame" { Name = "TopRow", Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, [Children] = {
                        scope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal },
                        scope:New "Frame" { LayoutOrder = 1, Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1, [Children] = { scope:New "UIPadding" { PaddingTop = UDim.new(0, 8) }, scope:SmartText { Text = "USER MANAGEMENT", Variant = "Header", Size = 18 } }},
                        scope:New "Frame" { LayoutOrder = 2, Size = UDim2.new(0.3, 0, 1, 0), BackgroundTransparency = 1, [Children] = { scope:New "UIListLayout" { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center }, scope:AsyncButton { Text = "REFRESH", Size = UDim2.fromOffset(90, 32), Style = "Outline", OnClick = function() Actions.RefreshPlayers() end } }}
                    }},
                    scope:New "Frame" { Name = "SearchRow", Size = UDim2.new(1, 0, 0, 40), Position = UDim2.fromOffset(0, 44), BackgroundColor3 = UI.Theme.Colors.Base.Main, [Children] = {
                        scope:New "UICorner" { CornerRadius = UDim.new(0, 8) }, scope:New "UIStroke" { Color = UI.Theme.Colors.Neutral.Main, Transparency = 0.6 }, scope:New "UIPadding" { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, scope:New "UIListLayout" { FillDirection=Enum.FillDirection.Horizontal, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,10) },
                        scope:New "ImageLabel" { Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Image = "rbxassetid://11293977827", ImageColor3 = UI.Theme.Colors.BaseContent.Muted },
                        scope:New "TextBox" { Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1, Text = SearchText, PlaceholderText = "Search by username...", PlaceholderColor3 = Color3.fromRGB(100,100,100), TextColor3 = UI.Theme.Colors.BaseContent.Main, TextSize = 16, FontFace = UI.Theme.Font.Body, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, [UI.OnChange "Text"] = function(newText) SearchText:set(newText) end }
                    }}
                }},
                scope:New "ScrollingFrame" { LayoutOrder = 2, Name = "ListContainer", Size = UDim2.new(1, 0, 1, -100), BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4, [Children] = {
                    scope:New "UIListLayout" { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder },
                    UI.ForValues(scope, FilteredList, function(use, innerScope, player) return PlayerRow(innerScope, player) end)
                }}
            }
        }
    end)
end
