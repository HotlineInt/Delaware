local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("ScreenGui", {
		Name = "HitMarker",
		Enabled = false,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 32, 0, 32),
				BackgroundTransparency = 1,
				Text = "X",
				TextScaled = true,
				Font = Enum.Font.SourceSans,
				TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0,
			}),
		},
	})
end
