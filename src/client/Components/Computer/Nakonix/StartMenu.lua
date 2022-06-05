local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Buttons: {})
	local Menu = CUI:CreateElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, -30),
		Size = UDim2.new(0, 200, 0, 64),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,

		-- white color
		BackgroundColor3 = Color3.new(1, 1, 1),

		-- disable border
		BorderSizePixel = 0,

		[CUI.Children] = {
			CUI:CreateElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				-- sort by layout order

				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),
		},
	})

	for _, Button in pairs(Buttons) do
		local ButtonElement = Button.Element
		local Callback = Button.Callback
		Menu:Add(ButtonElement)

		ButtonElement:On("Activated", function()
			Menu:SetProperty("Visible", false)
			Callback()
		end)
	end

	return Menu
end
