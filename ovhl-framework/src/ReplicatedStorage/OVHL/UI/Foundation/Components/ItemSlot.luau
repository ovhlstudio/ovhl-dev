--!strict
-- @Component: ItemSlot v3.1 (Visual States)
return function(API)
	local Theme = API.Theme
    local Assets = API.Assets
    local function New(scope, class) return API.New(scope, class) end
	
	return function(scope, props)
		local Item = props.Item
		local Config = props.Config or {}
		
        -- [STATE] Cek status Equipped
        local isEquipped = Item.Equipped == true
        
        -- [STYLE] Rarity Color (Override jadi GOLD jika equipped)
		local rarityColors = Config.UI and Config.UI.RarityColors or {}
		local baseColor = rarityColors[Item.Rarity] or Theme.Colors.Neutral.Main
        
        local borderColor = isEquipped and Color3.fromHex("FFD700") or baseColor -- Gold if equipped
        local borderThickness = isEquipped and 3 or 2
        
        local imageId = Item.Icon 
        if not imageId or imageId == "" then
            imageId = Assets.Placeholders.Generic
            if string.find(Item.Name, "Sword") then imageId = Assets.Placeholders.Sword end
            if string.find(Item.Name, "Potion") then imageId = Assets.Placeholders.Potion end
        end

		return New(scope, "Frame") {
			Name = "Slot_" .. (Item.Id or "0"),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.Colors.Base.Main,
            
			[API.Children] = {
				New(scope, "UICorner") { CornerRadius = UDim.new(0, Theme.CornerRadius.Base) },
				
                -- Border (Dynamic Color)
                New(scope, "UIStroke") {
					Color = borderColor,
					Thickness = borderThickness,
					Transparency = isEquipped and 0 or 0.3,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				},
                
                -- Equipped Tag (Corner)
                isEquipped and New(scope, "Frame") {
                    Size = UDim2.fromOffset(24, 24),
                    Position = UDim2.new(1, -4, 0, 4),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromHex("FFD700"),
                    ZIndex = 5,
                    [API.Children] = {
                        New(scope, "UICorner") { CornerRadius = UDim.new(0, 4) },
                        New(scope, "TextLabel") {
                            Text = "E",
                            Size = UDim2.fromScale(1,1),
                            BackgroundTransparency = 1,
                            TextColor3 = Color3.new(0,0,0),
                            FontFace = Theme.Font.Heading,
                            TextSize = 14
                        }
                    }
                } or nil,
				
				New(scope, "Frame") {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					
					[API.Children] = {
						New(scope, "UIPadding") {
							PaddingTop = UDim.new(0, Theme.Spacing.Medium), 
                            PaddingBottom = UDim.new(0, Theme.Spacing.Medium),
							PaddingLeft = UDim.new(0, Theme.Spacing.Medium), 
                            PaddingRight = UDim.new(0, Theme.Spacing.Medium),
						},
                        
                        New(scope, "UIListLayout") {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Padding = UDim.new(0, Theme.Spacing.Small),
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Top
                        },
                        
                        -- 1. IMAGE
                        New(scope, "ImageLabel") {
                            LayoutOrder = 1,
                            Size = UDim2.fromOffset(80, 80),
                            BackgroundTransparency = 1,
                            Image = imageId,
                            ScaleType = Enum.ScaleType.Fit
                        },

						-- 2. NAME
                        scope:SmartText {
                            LayoutOrder = 2,
                            Text = Item.Name,
                            Variant = "Body", 
                            Align = Enum.TextXAlignment.Center,
                            Size = 14
                        },
                        
                        -- 3. RARITY
                        scope:SmartText {
                            LayoutOrder = 3,
                            Text = string.upper(Item.Rarity),
                            Variant = "Caption",
                            Align = Enum.TextXAlignment.Center,
                            Color = baseColor 
                        },

                        -- 5. ACTION BUTTONS
                        New(scope, "Frame") {
                            LayoutOrder = 5,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            
                            [API.Children] = {
                                New(scope, "UIListLayout") {
                                    FillDirection = Enum.FillDirection.Vertical,
                                    Padding = UDim.new(0, Theme.Spacing.Small),
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center
                                },
                                
                                API.ForValues(scope, Config.UI.Actions or {}, function(use, innerScope, action)
                                    -- [LOGIC] Swap Text "EQUIP" -> "UNEQUIP"
                                    local label = action.Label
                                    local style = action.Style
                                    
                                    if action.Id == "Equip" and isEquipped then
                                        label = "UNEQUIP"
                                        style = "Outlined" -- Ganti style biar beda
                                    end
                                
                                    return innerScope:AsyncButton {
                                        Text = label,
                                        Style = style,
                                        Size = UDim2.new(1, 0, 0, 28),
                                        
                                        OnClick = function()
                                            if props.OnAction then
                                                props.OnAction(Item, action.Id, function() end)
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
	end
end
