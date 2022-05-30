local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local SettingsManager = require(script.Parent.Parent.Parent.SettingsManager)

local BooleanValues = {
	[true] = "X",
	[false] = "",
}

return function(Setting)
	local Switch = CUI:CreateElement("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0.95, 0, 0.5, 0),
		Size = UDim2.new(0, 25, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),

		[CUI.Children] = {
			CUI:CreateElement("TextButton", {
				-- transparent
				Active = true,
				Name = Setting.Name .. "Switch",
				BackgroundTransparency = 1,
				Text = BooleanValues[Setting.Value],
				Font = Enum.Font.SourceSansBold,
				-- white text
				TextColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(1, 0, 1, 0),
				TextScaled = true,
				[CUI.OnEvent("Activated")] = function(self)
					local CurrentValue = SettingsManager:GetSetting(Setting.Name).Value
					print(Setting.Name)
					SettingsManager:SetSetting(Setting.Name, not CurrentValue)
				end,
			}),
		},
	})

	SettingsManager:OnSettingChange(Setting.Name, function(OldValue, NewValue)
		print("hi??")
		local self = Switch:Get(Setting.Name .. "Switch")
		self:SetProperty("Text", BooleanValues[NewValue])
	end)

	return Switch
end
