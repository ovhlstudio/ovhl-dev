--!strict
-- @View: FrameworkPanelView (Cleaned - No More Inspector Popup)
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local UI = Loader.UI.Foundation.API
local Children = UI.Children

local PermissionPage = Loader.UI("Views/System/Pages/PermissionPage")
local ConfirmationDialog = Loader.UI("Views/System/Components/ConfirmationDialog")

return function(scope, props)
    local State = props.State
    local Actions = props.Actions
    local Config = props.Config
    local UIConfig = Config.UI
    local MenuList = Config.Menus

    local MainContent = UI.Computed(scope, function(use)
        local tab = use(State.CurrentTab)
        if tab == "Permission" then return PermissionPage(scope, { State = State, Actions = Actions })
        elseif tab == "Dashboard" then return scope:SmartText { Text = "Welcome to " .. UIConfig.Title, Align = Enum.TextXAlignment.Center }
        else return scope:SmartText { Text = "Feature Coming Soon: " .. tab, Align = Enum.TextXAlignment.Center } end
    end)

    -- Confirmation tetap Popup (Layer paling atas) karena dia Global Alert
    local ConfirmationLayer = UI.Computed(scope, function(use)
        local confirmData = use(State.Confirmation)
        if confirmData then
            return ConfirmationDialog(scope, { Data = confirmData, OnClose = Actions.ResolveConfirmation })
        end
        return scope:New "Frame" { Visible = false }
    end)

    return scope:ScreenWrapper {
        Name = "FrameworkPanel",
        Enabled = true,
        Order = 100,
        
        [Children] = {
            scope:SmartWindow {
                Title = UIConfig.Title,
                Size = UDim2.fromOffset(UIConfig.Size.X, UIConfig.Size.Y),
                OnClose = props.OnClose,
                Visible = State.Visible,
                Transition = UIConfig.Transition,
                
                [Children] = {
                    scope:New "Frame" {
                        Name = "MainLayout",
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        [Children] = {
                            scope:New "UIListLayout" { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder },
                            
                            -- Sidebar
                            scope:New "Frame" {
                                Name = "Sidebar", Size = UDim2.new(0, UIConfig.SidebarWidth, 1, 0), BackgroundColor3 = Color3.fromHex("09090b"), BorderSizePixel = 0, LayoutOrder = 1, ZIndex = 2,
                                [Children] = {
                                    scope:New "UIPadding" { PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) },
                                    scope:New "UIListLayout" { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder },
                                    UI.ForValues(scope, MenuList, function(use, innerScope, item)
                                        local isActive = use(State.CurrentTab) == item.Id
                                        return innerScope:AsyncButton { Text = item.Label, Size = UDim2.new(1, 0, 0, 40), Style = isActive and "Filled" or "Ghost", LayoutOrder = item.Order, OnClick = function() State.CurrentTab:set(item.Id) end }
                                    end)
                                }
                            },
                            
                            -- Content
                            scope:New "Frame" {
                                Name = "Content", Size = UDim2.new(1, -UIConfig.SidebarWidth, 1, 0), BackgroundTransparency = 1, LayoutOrder = 2, ClipsDescendants = true,
                                [Children] = {
                                    scope:New "UIPadding" { PaddingTop = UDim.new(0, 24), PaddingBottom = UDim.new(0, 24), PaddingLeft = UDim.new(0, 24), PaddingRight = UDim.new(0, 24) },
                                    MainContent
                                }
                            }
                        }
                    }
                }
            },
            ConfirmationLayer -- Layer 2 (Alert Only)
        }
    }
end
