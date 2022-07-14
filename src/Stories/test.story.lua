local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local main_menu = game:GetService("ReplicatedFirst"):WaitForChild("Core"):WaitForChild("MainMenu")

local button = require(main_menu.MainMenuButton)
local logo = require(main_menu.Logo)

return function(Container: Frame)
	local root = CUI:CreateElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		[CUI.Children] = {
			-- uilist layout
			CUI:CreateElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			logo(),
			button({ Label = "Test label numbero 15" }),
			button({ Label = "Test label numbero 15" }),
			button({ Label = "Test label numbero 15" }),
		},
	})

	root:Mount(Container)

	return function()
		root:Destroy()
	end
end
