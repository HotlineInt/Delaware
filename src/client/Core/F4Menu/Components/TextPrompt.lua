local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	local Prompt = Props.Prompt
	local Callback = Props.Callback

	return CUI:CreateElement("Frame", {
		Active = true,
		Name = "TextPrompt" .. Prompt,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.3,
		ZIndex = 10,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 200, 0, 120),
				[CUI.Children] = {
					CUI:CreateElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, 32),
						Text = Prompt,
						TextScaled = true,
						Font = Enum.Font.SourceSansSemibold,
						TextColor3 = Color3.new(1, 1, 1),
						ZIndex = 10,
						BackgroundTransparency = 1,
						[CUI.Children] = {
							CUI:CreateElement("UITextSizeConstraint", {
								MaxTextSize = 18,
								MinTextSize = 5,
							}),
						},
					}),
				},
			}),
		},
	})
end
