local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Window = require(script.Parent.Window)

return function(Props: {})
	local Text = Props.Text
	return Window({
		Size = UDim2.new(0, 300, 0, 100),
		Title = "Message Box",
		Content = CUI:CreateElement("TextLabel", {
			Name = "TextLabel",
			Text = Text,
			Font = Enum.Font.Code,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 100),
			AutomaticSize = Enum.AutomaticSize.X,
			-- TextSize = 20,
			TextScaled = true,
			[CUI.Children] = {
				CUI:CreateElement("UITextSizeConstraint", {
					MaxTextSize = 35,
				}),
			},
		}),
	})
end
