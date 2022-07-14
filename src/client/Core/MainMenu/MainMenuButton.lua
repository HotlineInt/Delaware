local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("TextButton", {
		Size = UDim2.new(0.95, 0, 0.15, 0),
		Text = Props.Label,
		BorderSizePixel = 0,
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(22, 22, 24),
		TextScaled = true,
		[CUI.OnEvent("MouseEnter")] = function(self)
			self:SetProperty("Font", Enum.Font.SourceSansBold)
		end,
		[CUI.OnEvent("MouseLeave")] = function(self)
			self:SetProperty("Font", Enum.Font.SourceSans)
		end,
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingLeft = UDim.new(0, 5),
			}),
			CUI:CreateElement("UITextSizeConstraint", {
				MaxTextSize = 25,
			}),
		},
	})
end
