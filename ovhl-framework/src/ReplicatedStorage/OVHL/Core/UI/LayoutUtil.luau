--!strict
-- @Core: LayoutUtil v2.0
-- @Role: Advanced Positioning, Safe Areas, and Aspect Ratio Management

local LayoutUtil = {}

-- [[ 1. ANCHOR PRESETS ]]
local ANCHORS = {
    TopLeft      = Vector2.new(0, 0),   TopCenter    = Vector2.new(0.5, 0),   TopRight    = Vector2.new(1, 0),
    MiddleLeft   = Vector2.new(0, 0.5), Center       = Vector2.new(0.5, 0.5), MiddleRight = Vector2.new(1, 0.5),
    BottomLeft   = Vector2.new(0, 1),   BottomCenter = Vector2.new(0.5, 1),   BottomRight = Vector2.new(1, 1),
}

local POSITIONS = {
    TopLeft      = UDim2.fromScale(0, 0),   TopCenter    = UDim2.fromScale(0.5, 0),   TopRight    = UDim2.fromScale(1, 0),
    MiddleLeft   = UDim2.fromScale(0, 0.5), Center       = UDim2.fromScale(0.5, 0.5), MiddleRight = UDim2.fromScale(1, 0.5),
    BottomLeft   = UDim2.fromScale(0, 1),   BottomCenter = UDim2.fromScale(0.5, 1),   BottomRight = UDim2.fromScale(1, 1),
}

export type LayoutConfig = {
    Position: string?,
    Margin: number?,
    OffsetX: number?,
    OffsetY: number?,
}

-- [[ 2. MAIN LOGIC ]]
function LayoutUtil.Get(config: LayoutConfig)
    local key = config.Position or "Center"
    local margin = config.Margin or 0
    local fineX = config.OffsetX or 0
    local fineY = config.OffsetY or 0
    
    local anchor = ANCHORS[key] or ANCHORS.Center
    local basePos = POSITIONS[key] or POSITIONS.Center
    
    local moveX, moveY = 0, 0
    
    if string.find(key, "Left") then moveX = margin
    elseif string.find(key, "Right") then moveX = -margin end
    
    if string.find(key, "Top") then moveY = margin
    elseif string.find(key, "Bottom") then moveY = -margin end
    
    return {
        AnchorPoint = anchor,
        Position = basePos + UDim2.fromOffset(moveX + fineX, moveY + fineY)
    }
end

-- [[ 3. HELPER: SAFE AREA ]]
function LayoutUtil.GetSafeArea()
    local guiService = game:GetService("GuiService")
    -- Mockup call for static check contexts
    local s, topInset = pcall(function() return guiService:GetGuiInset() end)
    if not s then topInset = Vector2.new(0, 36) end -- Studio fallback

    return {
        PaddingTop = UDim.new(0, topInset.Y),
        PaddingBottom = UDim.new(0, 0),
        PaddingLeft = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 0)
    }
end

-- [[ 4. HELPER: GRID CALCULATOR ]]
function LayoutUtil.CalculateGrid(containerWidth: number, targetCellSize: number, gap: number)
    local available = containerWidth
    local itemsPerRow = math.floor((available + gap) / (targetCellSize + gap))
    itemsPerRow = math.max(1, itemsPerRow)
    
    local usedWidth = (itemsPerRow * targetCellSize) + ((itemsPerRow - 1) * gap)
    local remaining = available - usedWidth
    
    return {
        ItemsPerRow = itemsPerRow,
        MarginSide = remaining / 2
    }
end

return table.freeze(LayoutUtil)
