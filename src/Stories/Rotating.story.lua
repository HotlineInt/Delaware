local RunService = game:GetService("RunService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Janitor = require(Carbon.Util.NakoJanitor)
local CUI = require(Carbon.UI.CUI)
local State = require(Carbon.UI.CUI.State)

local function Clock(Math)
	local State = State.new(0)

	return CUI:CreateElement("Frame", {
		Size = UDim2.new(0.02, 0, 0.8, 0),
		BorderSizePixel = 0,
		Rotation = State:Listen(function(self, Time)
			return Time / Math * 360
		end),
		BackgroundColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		-- [CUI.Children] = {
		-- 	CUI:CreateElement("UIAspectRatioConstraint", {
		-- 		AspectRatio = 1.5,
		-- 	}),
		-- },
	}),
		State
end

return function(Container: Frame)
	local HourClock, HourState = Clock(12)
	local SecondClock, SecondState = Clock(60)
	local MinuteClock, MinuteState = Clock(60)

	local Clocks = {
		Hour = HourClock,
		Seconds = SecondClock,
		Minutes = MinuteClock,
		-- Clock(),
		-- Clock(),
		-- Clock(),
	}
	local MyJanitor = Janitor.new()
	local ClockContainer = CUI:CreateElement("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Image = "rbxassetid://10203331972",
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
	})

	ClockContainer:Mount(Container)

	MyJanitor:Add(RunService.Heartbeat:Connect(function()
		local Seconds = tonumber(os.date("%S"))
		local Hours = tonumber(os.date("%H"))
		local Minutes = tonumber(os.date("%M"))

		HourState:Set(Hours)
		MinuteState:Set(Minutes)
		SecondState:Set(Seconds)
	end))

	for _, Clock in pairs(Clocks) do
		Clock:Mount(ClockContainer)
	end

	return function()
		MyJanitor:Cleanup()
		for _, Clock in pairs(Clocks) do
			Clock:Destroy()
		end
	end
end
