local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Switches = {
	Checkbox = require(script.Parent.SwitchesNAll.Checkbox),
}

return function(Setting)
	local Label = Setting.Name
	local Type = "Boolean"

	return CUI:CreateElement("Frame", {
		Name = Label,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 25),
		--AutomaticSize = Enum.AutomaticSize.Y,

		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = Label,
				Text = Label,
				Font = Enum.Font.SourceSansBold,
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 1, 0),
				TextSize = 24,
			}),

			Switches.Checkbox(Setting),
		},
	})
end
