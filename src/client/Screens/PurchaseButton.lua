local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

return function(Props)
	local Price = Props.Price
	local Callback = Props.Callback
		or function()
			error("No callback set on Purchase Button! Gamepass missing.. probably!")
		end

	return CUI:CreateElement("Frame", {
		AnchorPoint = Vector2.new(0.5),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0, 200, 0, 32),
		BackgroundColor3 = Color3.fromRGB(24, 206, 79),
		[CUI.Children] = {
			CUI:CreateElement("TextButton", {
				Active = true,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "R$ " .. tostring(Price),
				BackgroundTransparency = 1,
				TextScaled = true,
				-- white text
				TextColor3 = Color3.new(1, 1, 1),
				-- source sans bold
				Font = Enum.Font.SourceSansBold,
				-- text size constraint
				[CUI.Children] = {
					CUI:CreateElement("UITextSizeConstraint", {
						MaxTextSize = 15,
						MinTextSize = 10,
					}),
				},
				[CUI.OnEvent("Activated")] = function(...)
					print("still hooked onto Activated")
					Callback(...)
				end,
			}),
		},
	})
end
