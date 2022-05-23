local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

return function(IconID: string)
	return CUI:CreateElement("ImageLabel", {
		BackgroundTransparency = 1,
		--ScaleType = Enum.ScaleType.Fit,
		--	ImageTransparency = 0.5,
		Size = UDim2.new(0, 16, 0, 16),
		Image = IconID,
	})
end
