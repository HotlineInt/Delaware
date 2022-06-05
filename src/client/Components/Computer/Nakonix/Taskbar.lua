local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: table)
	return CUI:CreateElement("Frame", {
		Name = "Taskbar",
		-- white background
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),

		-- make start menu
		[CUI.Children] = {
			CUI:CreateElement("ImageButton", {
				Active = true,
				Name = "StartButton",
				Image = "rbxassetid://3392016992",
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Size = UDim2.new(0, 32, 0, 32),
				Position = UDim2.new(0, 0, 0, 0),
				--AnchorPoint = Vector2.new(1, 0),
				[CUI.OnEvent("Activated")] = function()
					print("nyanners")
				end,
			}),
		},
	})
end
