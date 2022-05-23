local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function()
	return CUI:CreateElement("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 10),
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(0, 150, 0, 16),
		[CUI.Children] = {
			CUI:CreateElement("UIListLayout", {}),
		},
		[CUI.OnEvent("ChildAdded")] = function(self)
			local CurrentSize = self:GetProperty("Size")
			CurrentSize += UDim2.new(0, 0, 0, 16)

			self:SetProperty("Size", CurrentSize)
		end,
		[CUI.OnEvent("ChildRemoved")] = function(self)
			local CurrentSize = self:GetProperty("Size")
			CurrentSize += UDim2.new(0, 0, 0, -16)

			self:SetProperty("Size", CurrentSize)
		end,
	})
end
