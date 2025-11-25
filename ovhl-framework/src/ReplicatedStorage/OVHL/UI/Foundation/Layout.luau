--!strict
-- @Foundation: Layout v1.0
-- @Role: Positioning Helper (9-Slice Grid System)

local Layout = {}

local ANCHORS = {
	TopLeft = Vector2.new(0, 0),
	TopCenter = Vector2.new(0.5, 0),
	TopRight = Vector2.new(1, 0),
	MiddleLeft = Vector2.new(0, 0.5),
	Center = Vector2.new(0.5, 0.5),
	MiddleRight = Vector2.new(1, 0.5),
	BottomLeft = Vector2.new(0, 1),
	BottomCenter = Vector2.new(0.5, 1),
	BottomRight = Vector2.new(1, 1),
}

local POSITIONS = {
	TopLeft = UDim2.fromScale(0, 0),
	TopCenter = UDim2.fromScale(0.5, 0),
	TopRight = UDim2.fromScale(1, 0),
	MiddleLeft = UDim2.fromScale(0, 0.5),
	Center = UDim2.fromScale(0.5, 0.5),
	MiddleRight = UDim2.fromScale(1, 0.5),
	BottomLeft = UDim2.fromScale(0, 1),
	BottomCenter = UDim2.fromScale(0.5, 1),
	BottomRight = UDim2.fromScale(1, 1),
}

function Layout.Place(align, margin)
	local anchor = ANCHORS[align] or ANCHORS.TopLeft
	local basePos = POSITIONS[align] or POSITIONS.TopLeft
	local off = margin or 0

	local finalPos = basePos

	if align == "TopLeft" then
		finalPos = UDim2.new(0, off, 0, off)
	elseif align == "TopCenter" then
		finalPos = UDim2.new(0.5, 0, 0, off)
	elseif align == "TopRight" then
		finalPos = UDim2.new(1, -off, 0, off)
	elseif align == "MiddleLeft" then
		finalPos = UDim2.new(0, off, 0.5, 0)
	elseif align == "Center" then
		finalPos = UDim2.new(0.5, 0, 0.5, 0)
	elseif align == "MiddleRight" then
		finalPos = UDim2.new(1, -off, 0.5, 0)
	elseif align == "BottomLeft" then
		finalPos = UDim2.new(0, off, 1, -off)
	elseif align == "BottomCenter" then
		finalPos = UDim2.new(0.5, 0, 1, -off)
	elseif align == "BottomRight" then
		finalPos = UDim2.new(1, -off, 1, -off)
	end

	return {
		AnchorPoint = anchor,
		Position = finalPos,
	}
end

return Layout
