local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local TitleLabel = require(script.Parent.Parent.TitleLabel)
local PurchaseButton = require(script.Parent.PurchaseButton)

local Notifications = require(script.Parent.Parent.Notification)

return function()
	local BuyButton = PurchaseButton({
		Price = 200,
		Callback = function()
			print("HUH??")
			Notifications:Notify("Supporter tag is currently unavailable. Please check later.")
		end,
	})
	BuyButton:SetProperty("AnchorPoint", Vector2.new(0.5, 0.8))
	BuyButton:SetProperty("Position", UDim2.new(0.5, 0, 0.9, 0))

	local Container = CUI:CreateElement("ScreenGui", {

		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				BackgroundColor3 = Color3.new(),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 300, 0, 200),

				[CUI.Children] = {
					TitleLabel({ Title = "Buy Supporter" }),
					CUI:CreateElement("TextLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0.7, -36),
						BackgroundTransparency = 1,
						RichText = true,
						-- white
						TextColor3 = Color3.new(1, 1, 1),
						-- sourcesansbold
						Font = Enum.Font.SourceSansBold,
						-- textscaled
						TextScaled = true,
						Text = [[
Purchase supporter early to obtain following perks:
Exclusive <b>Supporter</b> Tag
Supporter Role in Community Server
		
                        ]],
					}),
					BuyButton,
				},
			}),
		},
	})

	return Container
end
