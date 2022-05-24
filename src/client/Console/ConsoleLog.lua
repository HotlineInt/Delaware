local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)

local Colors = {
	[Enum.MessageType.MessageError] = Color3.fromRGB(196, 13, 44),
	[Enum.MessageType.MessageInfo] = Color3.fromRGB(255, 255, 255),
	[Enum.MessageType.MessageOutput] = Color3.fromRGB(255, 255, 255),
	[Enum.MessageType.MessageWarning] = Color3.fromRGB(228, 176, 33),
}

return function(Props)
	local InfoType = Props.InfoType or Enum.MessageType.MessageOutput
	local Message = Props.Message
	if not CUI:RequiredProp(Message, "string") then
		return
	end

	return CUI:CreateElement("TextLabel", {
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		Font = Enum.Font.Code,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(1, 0, 0, 16),
		TextSize = 15,
		Text = Message,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextStrokeTransparency = 0.5,
		TextColor3 = Colors[InfoType],
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingLeft = UDim.new(0, 50),
			}),
		},
	})
end
