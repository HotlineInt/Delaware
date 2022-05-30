local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local CUI = require(Packages.CUI)

return function(Props)
	local Title = Props.Title or "Unknown Title"
	return CUI:CreateElement("TextLabel", {
		Font = Enum.Font.SourceSansBold,
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		--AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 0, 32),
		Text = Title,
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingLeft = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			}),
		},
	})
end
