local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("TextButton", {
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 90, 0, 30),
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		Text = Props.Text,
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
			}),
		},
		[CUI.OnEvent("Activated")] = Props.Callback,
	})
end
