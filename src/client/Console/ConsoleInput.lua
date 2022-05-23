local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function()
	return CUI:CreateElement("TextBox", {
		Name = "ConsoleInput",
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.2,
		Font = Enum.Font.Code,
		TextStrokeTransparency = 0.4,
		ClearOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 20,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 0),

		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		TextYAlignment = Enum.TextYAlignment.Bottom,

		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingBottom = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			}),
		},
	})
end
