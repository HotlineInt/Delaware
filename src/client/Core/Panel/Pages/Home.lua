local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function()
	return CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Text = "go away",
				Size = UDim2.new(1, 0, 1, 0),
			}),
		},
	})
end
