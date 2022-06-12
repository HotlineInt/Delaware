local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		[CUI.Children] = Props,
	})
end
