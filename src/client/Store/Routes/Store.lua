local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Items = {
	{
		Name = "Skyward Spear",
		Price = "a lot of primos",
	},
	{
		Name = "Qiqi",
		Price = "All of your belongings",
	},
}

return {
	Title = "Store",
	View = function(Props: {})
		local Router = Props.Router

		local View = CUI:CreateElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			[CUI.Children] = {
				CUI:CreateElement("UIGridLayout", {}),
			},
		})

		for _, Item in pairs(Items) do
			View:AddElement(CUI:CreateElement("TextButton", {
				Active = true,
				Text = Item.Name,
				[CUI.OnEvent("Activated")] = function()
					Router:GoTo("/item", { Item = Item })
				end,
			}))
		end

		return View
	end,
}
