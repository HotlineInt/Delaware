local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props: {})
	return CUI:CreateElement("TextButton", {
		Name = "ModalBox",
		Active = false,
		Size = UDim2.new(1, 0, 1, 0),
		TextTransparency = 1,
		BackgroundTransparency = 1,
		Modal = true,
		Visible = true,
	})
end
