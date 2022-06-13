local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		Font = Enum.Font.SourceSansBold,
		RichText = true,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		BackgroundTransparency = 1,
		Text = Props.Text,
	})
end
