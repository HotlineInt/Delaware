local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Page = require(script.Parent.Parent.Components.Page)
local Label = require(script.Parent.Parent.Components.Label)

local GameVersion = workspace:GetAttribute("GameVersion")

return function(Props: {})
	return Page({
		CUI:CreateElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 20),
		}),
		Label({
			Text = "<b>Codename: Delaware</b>\n<i>pre-release</i>",
			Font = Enum.Font.SourceSans,
		}),
		Label({
			Text = "Version: " .. GameVersion .. " Running Carbon v0.2",
			Font = Enum.Font.SourceSans,
		}),
	})
end
