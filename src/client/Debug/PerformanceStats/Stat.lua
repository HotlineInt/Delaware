local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local DebugStat = { Name = "UNKNOWN" }
DebugStat.__index = DebugStat

function DebugStat.new(Name: string)
	return setmetatable({ Name = Name }, DebugStat)
end

function DebugStat:Render(Props: table)
	local Disabled = Props.Disabled or false

	local Panel = CUI:CreateElement("Frame", {
		Name = self.Name,
		Size = UDim2.new(0, 150, 0.8, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.3,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "Value",
				BackgroundTransparency = 1,
				Font = Enum.Font.SourceSansBold,
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
				Text = self.Name,
				[CUI.Children] = {
					CUI:CreateElement("UITextSizeConstraint", {
						MaxTextSize = 20,
						MinTextSize = 10,
					}),
				},
			}),
			CUI:CreateElement("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		},
	})

	if Disabled then
		Panel:AddElement(CUI:CreateElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 9999,
			-- black .5 transparent background
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSansBold,
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "DISABLED",
		}))
	end

	self.Name = self.Name
	self.Panel = Panel

	return Panel
end

function DebugStat:SetText(Text: string)
	local ValueLabel = self.Panel:Get("Value")
	local NoNumber = string.gsub(self.Name, "%d", "")

	ValueLabel:SetProperty("Text", NoNumber .. ": " .. tostring(Text))
end

return DebugStat
