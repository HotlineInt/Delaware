local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Knit = require(Carbon.Framework.Knit)
local JobService = Knit:GetService("JobService")
local EconomyService = Knit:GetService("EconomyService")

local Page = require(script.Parent.Parent.Components.Page)
local CategoryText = require(script.Parent.Parent.Components.CategoryText)

local MenuButton = require(script.Parent.Parent.Components.MenuButton)

local Sections = {
	Tools = require(script.ToolSection),
}

return function(Props: {})
	return Page({
		CUI:CreateElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 10),
		}),
		CategoryText({ Text = "EconomyService" }),
		CUI:CreateElement("Frame", {
			Size = UDim2.new(1, 0, 0, 30),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[CUI.Children] = {
				MenuButton({
					Text = "Join admin team",
					Callback = function()
						JobService:JoinJob("Admin"):andThen(function(Result: string)
							print(Result)
						end)
					end,
				}),
				MenuButton({
					Text = "Transfer to bank",
					Callback = function()
						EconomyService:TransferToBank(100)
					end,
				}),
				MenuButton({
					Text = "Donate money to Player2",
					Callback = function()
						EconomyService:Donate(game.Players.Player2, 100)
					end,
				}),
				CUI:CreateElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10),
				}),
			},
		}),
		CategoryText({ Text = "Tools" }),
		Sections.Tools(),

		CategoryText({ Text = "Shiroko" }),
	})
end
