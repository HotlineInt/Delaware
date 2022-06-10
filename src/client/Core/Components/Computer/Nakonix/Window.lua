local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	local Size = Props.Size
	local Title = Props.Title
	local ContentElement = Props.Content

	local Window
	Window = CUI:CreateElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = Size,

		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Name = "Topbar",
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Color3.new(1, 1, 1),
				ZIndex = 5,
				[CUI.Children] = {
					CUI:CreateElement("TextLabel", {
						Name = "Title",
						Text = Title,
						Font = Enum.Font.Code,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						TextSize = 20,
						ZIndex = 5,
					}),
					CUI:CreateElement("TextButton", {
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.new(0, 32, 0, 32),
						Text = "X",
						TextScaled = true,
						[CUI.OnEvent("Activated")] = function()
							Window:Destroy()
						end,
						ZIndex = 5,
					}),
				},
			}),
			CUI:CreateElement("Frame", {
				--	BackgroundTransparency = 1,
				Name = "Content",
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0, 0, 0, 32),
				Size = UDim2.new(1, 0, 1, 0),
				[CUI.Children] = {
					ContentElement,
				},
			}),
		},
		ZIndex = 10,
	})

	return Window
end
