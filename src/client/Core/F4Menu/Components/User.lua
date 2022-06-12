local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	local Name = Props.Name
	local Rank = Props.Rank
	local User: Player = Props.User

	local User = CUI:CreateElement("Frame", {
		Name = "User",
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = 1,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "UserAndRank",
				Size = UDim2.new(1, 0, 1, 0),
				Text = string.format("<b>%s</b>\n<i>%s</i>", User.Name, Rank),
				Font = Enum.Font.SourceSansLight,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				TextWrapped = true,
				BorderColor3 = Color3.new(0.3, 0.3, 0.3),
				BackgroundColor3 = Color3.new(),
				TextSize = 18,
				TextColor3 = Color3.new(1, 1, 1),
				LineHeight = 0.8,
			}),

			CUI:CreateElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				ScaleType = Enum.ScaleType.Crop,
				Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", User.UserId),
			}),
		},
	})

	return User
end
