--!strict
local RS = game:GetService("ReplicatedStorage"); local Loader = require(RS.OVHL.Core.Loader)
local React = Loader.Get("React"); local Assets = Loader.Get("Assets"); local Style = Loader.Get("Style")
local e = React.createElement
export type Props = { Name: string, Size: UDim2?, Color: Color3?, LayoutOrder: number? }
local function findAssetId(query: string): string for _, cat in pairs(Assets.Icons) do if cat[query] then return cat[query] end end return "" end
return function(props: Props)
    local assetId = React.useMemo(function() return findAssetId(props.Name) end, {props.Name})
    return e("ImageLabel", { Image = assetId, Size = props.Size or Style.Metrics.IconSize.Medium, BackgroundTransparency = 1, ImageColor3 = props.Color or Style.Colors.Text.Main, LayoutOrder = props.LayoutOrder })
end
