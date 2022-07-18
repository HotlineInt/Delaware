local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

-- Props:
-- CUIState StageState
return function(Props: {})
	local State = Props.StageState

	return CUI:CreateElement("CanvasGroup", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.7),
				Position = UDim2.new(0.5, 0, 0.7, 0),
				BackgroundTransparency = 1,
				-- RichText, Listen to StageState state
				Font = Enum.Font.SourceSansBold,
				RichText = true,
				-- white text color
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				Size = UDim2.new(1, 0, 0.1, 0),
				Text = State:Listen(function(_, Stage: string)
					return ("<b>Game Initialization: %s </b>"):format(Stage)
				end),
				[CUI.Children] = {
					CUI:CreateElement("UITextSizeConstraint", {
						MaxTextSize = 30,
					}),
				},
			}),
		},
	})
end
