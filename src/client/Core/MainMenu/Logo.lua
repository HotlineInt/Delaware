local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.Code,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0.1, 0),
		Size = UDim2.new(0.9, 0, 0.15, 0),
		Text = "<CAPITAL ZONE LOGO HERE>",
	})
end
