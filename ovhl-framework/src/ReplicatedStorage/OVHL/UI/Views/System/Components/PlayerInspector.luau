--!strict
-- @Component: Player Inspector Deck (Fixed: Solid Interaction & Dark Theme)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.Get("API")
local Children = UI.Children
local Fusion = UI.Fusion

return function(scope, props)
    local PlayerData = props.Player
    local Actions = props.Actions
    local OnClose = props.OnClose
    
    local RANKS = {
        { Id = 0, Label = "GUEST", Color = "BaseContent" },
        { Id = 1, Label = "VIP",   Color = "Primary" },
        { Id = 2, Label = "MOD",   Color = "Primary" },
        { Id = 3, Label = "ADMIN", Color = "Primary" },
        { Id = 4, Label = "HEAD",  Color = "Error" },
        { Id = 5, Label = "OWNER", Color = "Error" }
    }

    return scope:SmartWindow {
        Title = "INSPECT: " .. PlayerData.Name,
        Size = UDim2.fromOffset(700, 400),
        OnClose = OnClose,
        Transition = "PopUp",
        
        [Children] = {
            -- MAIN LAYOUT
            scope:New "Frame" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                -- [FIX 1] Active = true MENCEGAH KLIK TEMBUS KE BELAKANG
                Active = true, 
                
                [Children] = {
                    scope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 0) },
                    
                    -- [[ KIRI: IDENTITY (35%) ]]
                    scope:New "Frame" {
                        Name = "IdentityCol",
                        Size = UDim2.new(0.35, 0, 1, 0),
                        -- [FIX 2] Force Dark Color (Zinc950) biar gak Putih
                        BackgroundColor3 = Color3.fromHex("09090b"), 
                        BorderSizePixel = 0,
                        
                        [Children] = {
                            scope:New "UIPadding" { PaddingTop=UDim.new(0,24), PaddingBottom=UDim.new(0,24), PaddingLeft=UDim.new(0,16), PaddingRight=UDim.new(0,16) },
                            scope:New "UIListLayout" { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 16), SortOrder=Enum.SortOrder.LayoutOrder },
                            
                            -- Big Avatar
                            scope:New "ImageLabel" {
                                LayoutOrder = 1,
                                Size = UDim2.fromOffset(120, 120),
                                BackgroundTransparency = 1,
                                Image = "rbxthumb://type=AvatarHeadShot&id=" .. PlayerData.UserId .. "&w=420&h=420",
                                [Children] = { 
                                    scope:New "UICorner" { CornerRadius = UDim.new(1, 0) },
                                    scope:New "UIStroke" { Color = UI.Theme.Colors.BaseContent.Main, Thickness = 2, Transparency = 0.8 }
                                }
                            },
                            
                            -- Names
                            scope:New "Frame" {
                                LayoutOrder = 2,
                                Size = UDim2.new(1, 0, 0, 60),
                                BackgroundTransparency = 1,
                                [Children] = {
                                    scope:New "UIListLayout" { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 4) },
                                    scope:SmartText { Text = PlayerData.Name, Size = 20, Variant = "Header", Align = Enum.TextXAlignment.Center },
                                    scope:SmartText { Text = "ID: " .. PlayerData.UserId, Size = 14, Color = "Neutral", Align = Enum.TextXAlignment.Center }
                                }
                            },
                            
                            -- Current Rank Display
                            scope:New "Frame" {
                                LayoutOrder = 3,
                                Size = UDim2.new(1, 0, 0, 80),
                                BackgroundColor3 = UI.Theme.Colors.Base.Main, -- Agak terang dikit dari background col
                                [Children] = {
                                    scope:New "UICorner" { CornerRadius = UDim.new(0, 8) },
                                    scope:New "UIListLayout" { VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Center },
                                    scope:SmartText { Text = "CURRENT RANK", Size = 12, Color = "Neutral" },
                                    scope:SmartText { Text = string.upper(PlayerData.Role) .. " ["..PlayerData.Rank.."]", Size = 24, Variant = "Header", Color = "Primary" }
                                }
                            }
                        }
                    },
                    
                    -- [[ KANAN: CONTROL MATRIX (65%) ]]
                    scope:New "Frame" {
                        Name = "ControlCol",
                        Size = UDim2.new(0.65, 0, 1, 0),
                        BackgroundTransparency = 1,
                        
                        [Children] = {
                            scope:New "UIPadding" { PaddingTop=UDim.new(0,24), PaddingBottom=UDim.new(0,24), PaddingLeft=UDim.new(0,24), PaddingRight=UDim.new(0,24) },
                            scope:New "UIListLayout" { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder },
                            
                            scope:SmartText { Text = "SET RANK AUTHORITY", Variant = "Header", Size = 16, LayoutOrder = 1 },
                            
                            -- GRID BUTTONS
                            scope:New "Frame" {
                                LayoutOrder = 2,
                                Size = UDim2.new(1, 0, 0, 160),
                                BackgroundTransparency = 1,
                                
                                [Children] = {
                                    scope:New "UIGridLayout" {
                                        CellSize = UDim2.new(0.3, 0, 0, 60),
                                        CellPadding = UDim2.new(0.05, 0, 0.05, 0),
                                        FillDirectionMaxCells = 3
                                    },
                                    
                                    UI.ForValues(scope, RANKS, function(use, innerScope, rank)
                                        local isCurrent = rank.Id == PlayerData.Rank
                                        local style = isCurrent and "Filled" or "Outline"
                                        
                                        return innerScope:AsyncButton {
                                            Text = rank.Label .. "\n["..rank.Id.."]",
                                            Style = style,
                                            Color = isCurrent and UI.Theme.Colors.Primary.Main or nil,
                                            
                                            OnClick = function()
                                                if not isCurrent then
                                                    Actions.RequestRankChange(PlayerData, rank.Id, rank.Label)
                                                end
                                            end
                                        }
                                    end)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end
