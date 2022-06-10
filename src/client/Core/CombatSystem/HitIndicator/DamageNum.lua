local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

return function(Props: {})
	local Damage = Props.Damage
	local Min, Max = 0, 1.5

	local DamageNum = CUI:CreateElement("BillboardGui", {
		ResetOnSpawn = false,
		AlwaysOnTop = true,
		Size = UDim2.new(2, 0, 2, 0),
		ExtentsOffset = Vector3.new(math.random(Min, Max), math.random(Min, Max), math.random(Min, Max)),
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "Numb",
				BackgroundTransparency = 1,
				Text = Damage,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
				Font = Enum.Font.SourceSans,
				Size = UDim2.new(1, 0, 1, 0),
			}),
		},
	})

	task.delay(0.9, function()
		local NumberLabel = DamageNum:Get("Numb")
		NumberLabel:AnimateTween(Info, { TextTransparency = 1 })
	end)

	return DamageNum
end
