local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)
local EconomyService = Knit:GetService("EconomyService")
local JobService = Knit:GetService("JobService")
local CUI = require(Carbon.UI.CUI)

local Notification = require(script.Parent.Parent.Notification)

local EconomyTest = {}

function TextButton(Props: {})
	return CUI:CreateElement("TextButton", {
		Active = true,
		Text = Props.Text,
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextColor3 = Color3.new(),
		Size = UDim2.new(0, 200, 0, 100),
		[CUI.OnEvent("Activated")] = Props.Callback,
	})
end

function EconomyTest:Load()
	local Panel = CUI:CreateElement("ScreenGui", {
		DisplayOrder = 99999999,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				[CUI.Children] = {
					-- list layout
					CUI:CreateElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
					}),

					TextButton({
						Text = "Donate money to Player2",
						Callback = function()
							EconomyService:Donate(game.Players.Player2, 100)
						end,
					}),

					TextButton({
						Text = "Transfer to bank",
						Callback = function()
							EconomyService:TransferToBank(100)
						end,
					}),

					TextButton({
						Text = "Join admin team",
						Callback = function()
							JobService:JoinJob("Admin"):andThen(function(Result: string)
								print(Result)
								Notification:Notify(Result)
							end)
						end,
					}),
				},
			}),
		},
	})

	Panel:Mount(Carbon:GetPlayer().PlayerGui)
end

return EconomyTest
