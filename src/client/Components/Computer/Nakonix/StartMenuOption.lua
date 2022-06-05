local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: table)
	local Label = Props.Label
	local Callback = Props.Callback
	local Menu = Props.Menu

	return {
		Element = CUI:CreateElement("TextButton", {
			Name = "StartButton",
			Text = Label,
			-- transparent background
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 25,

			-- 60 Y 1 X
			Size = UDim2.new(1, 0, 0, 32),
			Active = true,
		}),
		Callback = Callback,
	}
end
