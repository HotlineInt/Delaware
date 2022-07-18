local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local BoxInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local ModalBox = require(script.Parent.Parent.ModalBox)

return function(Props: {})
	return CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 9999999,
		[CUI.Children] = {
			-- for blocking input
			ModalBox(),

			-- for grey out effect
			CUI:CreateElement("Frame", {
				Name = "GreyOut",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				BackgroundTransparency = 0.4,
				ZIndex = 9999999,
			}),
			CUI:CreateElement("TextButton", {
				ZIndex = 9999999,
				Size = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				Name = Props.Prompt,
				BackgroundColor3 = Color3.new(1, 1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, -1, 0),
				Text = Props.Prompt,
				[CUI.OnEvent("Activated")] = function(self)
					-- if I don't this frenzy it doesn't work. What the hell?
					local Parent = self.Parent
					local GreyOut = Parent:Get("GreyOut")
					local ModalBox = Parent:Get("ModalBox")

					-- Smoothes out the transition from a greyed-out background
					GreyOut:AnimateTween(BoxInfo, {
						BackgroundTransparency = 1,
					})
					ModalBox:Destroy()
					self:Unmount()
					Parent:Destroy()
				end,
				[CUI.OnMount] = function(self)
					print("18 gig")
					self:AnimateTweenPromise(BoxInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) }):await()
				end,
				[CUI.OnUnmount] = function(self)
					self:AnimateTweenPromise(BoxInfo, { Position = UDim2.new(0.5, 0, -1, 0) }):await()
				end,
			}),
		},
	})
end
