local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Window = require(script.Parent.Window)

return function(Props: {})
	local Content = Props.Content or ""

	return Window({
		Size = UDim2.new(0, 600, 0, 200),
		Title = "Nakopad 0.0.1",
		Content = CUI:CreateElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			-- BackgroundTransparency = 1,
			[CUI.Children] = {
				CUI:CreateElement("TextBox", {
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = Enum.Font.SourceSansBold,
					Text = Content,
					BackgroundTransparency = 1,
					TextSize = 25,
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
				}),
			},
		}),
	})
end
