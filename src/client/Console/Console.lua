local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ConsoleInput = require(script.Parent.ConsoleInput)
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function()
	return CUI:CreateElement("Frame", {
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 1, 0),
		[CUI.Children] = {
			CUI:CreateElement("ScrollingFrame", {
				Name = "Logs",
				BackgroundColor3 = Color3.new(),
				BackgroundTransparency = 0.5,
				--AnchorPoint = Vector2.new(0, 1),
				--Position = UDim2.new(0, 0, 1, 0),
				BorderSizePixel = 0,
				ScrollBarThickness = 1,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Size = UDim2.new(1, 0, 0.95, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				[CUI.Children] = {
					CUI:CreateElement("UIListLayout", {}),
				},
			}),
			ConsoleInput(),
		},
	})
end
