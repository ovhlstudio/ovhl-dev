--!strict
-- @Component: GridContainer
-- @Role: Layout Wrapper
return function(API)
    local function New(scope, class) return API.New(scope, class) end

    return function(scope, props)
        local cellSize = props.CellSize or {X=100, Y=100}
        local gap = props.Gap or {X=10, Y=10}
        
        return New(scope, "ScrollingFrame") {
            Name = "GridContainer",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            
            [API.Children] = {
                New(scope, "UIPadding") {
                    PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)
                },
                
                New(scope, "UIGridLayout") {
                    CellSize = UDim2.fromOffset(cellSize.X, cellSize.Y),
                    CellPadding = UDim2.fromOffset(gap.X, gap.Y),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                },
                
                props[API.Children]
            }
        }
    end
end
