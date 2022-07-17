local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function()
	return CUI:CreateElement("Frame", {
		Name = "GreyOut",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(16, 16, 16),
		BackgroundTransparency = 0.4,
		ZIndex = 9999999,
	})
end
