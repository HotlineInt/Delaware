local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return {
	Title = "Item",
	View = function(Props: {})
		local Item = Props.Item
		local Router = Props.Router

		local View = CUI:CreateElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			[CUI.Children] = {
				CUI:CreateElement("TextLabel", {
					Text = Item.Name,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					TextSize = 50,
					TextWrapped = true,
					TextYAlignment = Enum.TextYAlignment.Top,
				}),
				-- price label
				CUI:CreateElement("TextLabel", {
					Text = Item.Price,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					TextSize = 50,
					TextWrapped = true,
				}),
				CUI:CreateElement("TextButton", {
					Active = true,
					Position = UDim2.new(0.5, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					Size = UDim2.new(0, 200, 0, 100),
					Text = "Go back",
					[CUI.OnEvent("Activated")] = function()
						Router:GoTo("/store", {})
					end,
				}),
			},
		})
		return View
	end,
}
