local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props)
	local Text = Props.Text

	return CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "Label",
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(1, 0, 0, 0),
				TextTransparency = 1,
				TextStrokeTransparency = 1,
				BackgroundTransparency = 1,
				Text = Text,
				Font = Enum.Font.SourceSansBold,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[CUI.Children] = {
					CUI:CreateElement("UITextSizeConstraint", {
						MaxTextSize = 20,
						MinTextSize = 10,
					}),
				},
			}),
		},
	})
end
