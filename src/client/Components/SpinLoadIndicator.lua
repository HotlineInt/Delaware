-- Greys out the parent and displays a spinning loading indicator

local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Blackout = require(script.Parent.Blackout)
local State = require(Carbon.UI.CUI.State)
local Damp = 0.84
local Force = 1

--local SpinInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, -1, false, 0.3)

-- Props: None
-- Returns: Element LoadingIndicator, CUIState LoadingState
return function(Props: {})
	local LoadingState = State.new(false)

	local Indicator = CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = LoadingState:Listen(function(self, Value)
			return Value
		end),
		ZIndex = 9999999,
		[CUI.Children] = {
			Blackout(),
			CUI:CreateElement("ImageLabel", {
				Name = "Spinner",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.3, 0, 0.4, 0),
				ScaleType = Enum.ScaleType.Fit,
				BackgroundTransparency = 1,
				Image = "rbxassetid://1961764186",
				ImageColor3 = Color3.new(1, 1, 1),
				--ImageTransparency = 0.5,
				-- ImageRectOffset = Vector2.new(0, 0),
				-- ImageRectSize = Vector2.new(64, 64),
				ZIndex = 9999999,
			}),
		},
	})
	local Spinner = Indicator:Get("Spinner")

	-- Really dumb way of making an infinite Spring-based spin animation
	task.spawn(function()
		while true do
			if not Spinner.Exists then
				break
			end

			Spinner:CancelSpring()
			Spinner:AnimateSpring(Damp, Force, { Rotation = 360 })

			task.wait(1)

			Spinner:CancelSpring()
			Spinner:SetProperty("Rotation", 0)
			Spinner:AnimateSpring(Damp, Force, { Rotation = 360 })
			task.wait(1)
		end
	end)

	return Indicator, LoadingState
end
