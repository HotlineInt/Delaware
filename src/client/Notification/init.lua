local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local NotificationComponent = require(script.Notification)

local Notifications = {
	Panel = nil,
}
local FadeDelay = 0.7
local Tween_Info = TweenInfo.new(FadeDelay, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

function Notifications:Load()
	self.Panel = CUI:CreateElement("ScreenGui", {
		Name = "Notifications",
		IgnoreGuiInset = false,
		DisplayOrder = 9999,
		ResetOnSpawn = false,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Name = "NotificationContainer",
				BackgroundColor3 = Color3.new(0, 0, 0),
				Size = UDim2.new(1, 0, 0.3, 0),
				BackgroundTransparency = 1,
				[CUI.Children] = {
					CUI:CreateElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, 5),
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
					}),
				},
			}),
		},
	})

	self.Panel:Mount(Carbon:GetPlayer().PlayerGui)
end

function Notifications:Notify(Text: string)
	local Notification = NotificationComponent({ Text = Text })
	local LabelText = Notification:Get("Label")
	local Container = self.Panel:Get("NotificationContainer")
	print("Yoinky sploinky")
	Notification:Mount(Container)

	task.defer(function()
		LabelText:AnimateTween(Tween_Info, { TextTransparency = 0, TextStrokeTransparency = 0.5 })
		task.wait(3)
		LabelText:AnimateTween(Tween_Info, { TextTransparency = 1, TextStrokeTransparency = 1 })
		task.wait(0.2)
		Notification:Destroy()
	end)
end

return Notifications
