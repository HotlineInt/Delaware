local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function()
	return CUI:CreateElement("Frame", {
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 1, 0),
		[CUI.Children] = {
			CUI:CreateElement("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				[CUI.Children] = {
					CUI:CreateElement("UIListLayout", {}),
				},
			}),
		},
	})
end
