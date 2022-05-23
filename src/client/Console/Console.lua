local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function()
	return CUI:CreateElement("ScrollingFrame", {
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0.87, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		[CUI.Children] = {
			CUI:CreateElement("UIListLayout", {}),
		},
	})
end
