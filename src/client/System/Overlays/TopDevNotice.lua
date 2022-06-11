local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("Frame", {
		BackgroundTransparency = 1,
		-- topbar size
		Size = UDim2.new(1, 0, 0, 36),

		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.SourceSansLight,
				RichText = true,
				TextColor3 = Color3.new(1, 1, 1),
				LineHeight = 0.74,
				TextSize = 18,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Top,
				Text = "<b>TEST PLACE OR IN STUDIO</b>\n<i>content shown does not represent final game, expect bugs & data loss</i>",
				[CUI.Children] = {
					CUI:CreateElement("UIPadding", {
						PaddingRight = UDim.new(0, 50),
					}),
				},
			}),
		},
	})
end
