local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	-- make a crosshair
	return CUI:CreateElement("ScreenGui", {
		Name = "Crosshair",
		Enabled = false,
		IgnoreGuiInset = true,
		ResetOnSpawn = true,
		[CUI.Children] = {
			CUI:CreateElement("ImageLabel", {
				Size = UDim2.new(0, 10, 0, 10),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Image = "rbxassetid://3570695787",
			}),
		},
	})
end
