local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	local Route = Props.Route
	local Router = Props.Router
	local Name = Props.Name

	return CUI:CreateElement("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		TextSize = 18,
		Font = Enum.Font.SourceSans,
		BorderSizePixel = 0,
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
		Text = Name,
		Name = Name,
		[CUI.OnEvent("Activated")] = function()
			print("[PageSelectorButton] Going to", Route)
			Router:GoTo(Route)
		end,
	})
end
