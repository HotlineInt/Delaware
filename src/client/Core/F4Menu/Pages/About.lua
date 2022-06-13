local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Page = require(script.Parent.Parent.Components.Page)

return function(Props: {})
	return Page({
		CUI:CreateElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			RichText = true,
			Text = "<b>Codename: Delaware</b>\n<i>pre-release</i>",
			Font = Enum.Font.SourceSansLight,
			TextSize = 18,
			TextWrapped = true,
			TextColor3 = Color3.new(1, 1, 1),
			TextYAlignment = Enum.TextYAlignment.Top,
		}),
	})
end
