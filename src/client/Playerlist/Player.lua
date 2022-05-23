local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local Badge = require(script.Parent.Badge)
local CUI = require(Packages.CUI)

return function(Props)
	local Player = Props.Player or {
		Name = "UNKNOWN+DN",
		UserId = 0,
	}
	local Badges = Props.Badges or {}
	local PlayAnimation = Props.PlayAnimation or true

	local PlayerEntry = CUI:CreateElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "PlayerName",
				Size = UDim2.new(1, 0, 1, 0),
				TextScaled = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.SourceSans,
				TextStrokeTransparency = 0.5,
				BackgroundColor3 = Color3.new(),
				BackgroundTransparency = 0.5,
				Text = Player.Name or "FAILED TO FETCH USERNAME",
				ZIndex = 2,
			}),
			CUI:CreateElement("Frame", {
				ClipsDescendants = true,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Badges",
				[CUI.Children] = {
					CUI:CreateElement("UIListLayout", {
						Padding = UDim.new(0, 5),
						FillDirection = Enum.FillDirection.Horizontal,
					}),
				},
			}),
			-- CUI:CreateElement("ImageLabel", {
			-- 	Name = "PlayerHeadshot",
			-- 	BackgroundTransparency = 1,
			-- 	Size = UDim2.new(0, 16, 0, 16),
			-- 	ImageTransparency = 0,
			-- 	AnchorPoint = Vector2.new(1, 0),
			-- 	Position = UDim2.new(1, 0, 0, 0),
			-- 	Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", Player.UserId),
			-- --	Visible = false,
			-- 	ZIndex = 2,
			-- }),
		},
	})

	local BadgeHolder = PlayerEntry:Get("Badges")

	for _, BadgeInfo in pairs(Badges) do
		local BadgeComponent = Badge(BadgeInfo)
		BadgeHolder:AddElement(BadgeComponent)
	end

	return PlayerEntry
end
