local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserState = require(script.Parent.Parent.UserState)
local StateEnum = require(script.Parent.Parent.UserState.StateEnum)

local Lighting = game:GetService("Lighting")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ViewModel = require(Carbon.Tier0.ViewModel)
local Create = require(Carbon.Util.Create)

local BackgroundBlur: DepthOfFieldEffect = Create("DepthOfFieldEffect", {
	Enabled = false,
	Parent = Lighting,
	FocusDistance = 0,
	InFocusRadius = 7.145,
	NearIntensity = 1,
	FarIntensity = 1,
})

local Movement = require(script.Parent.Parent.UserState.Movement)
local Notification = require(script.Parent.Parent.System.Notification)
local MouseBehavior = require(script.Parent.Parent.System.MouseBehaviour)

local ViewModelFolder = ReplicatedStorage:WaitForChild("ViewModels")
local WatchViewModel = ViewModel.new(ViewModelFolder:WaitForChild("Watch"))

local Panel = require(script.Panel)
local Watch = { Panel = nil }

function Watch:Load()
	self.Panel = Panel()

	UserState:ListenSignalA(function(State: string)
		if State == StateEnum.IN_F4_MENU then
			MouseBehavior:AddMenu("MENU_WATCH")
			BackgroundBlur.Enabled = true
			Movement:Disable()
			WatchViewModel:Mount()
		else
			MouseBehavior:RemoveMenu("MENU_WATCH")
			BackgroundBlur.Enabled = false
			Movement:Enable()
			WatchViewModel:Unmount()
		end
	end)

	RunService.RenderStepped:Connect(function(deltaTime)
		WatchViewModel:Update()
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.F2 and not gameProcessedEvent then
			if not Movement:IsStandingStill() then
				Notification:Notify("Cannot open the Watch while moving.")
				return
			end

			if UserState:Get() ~= StateEnum.IN_F4_MENU then
				UserState:Set(StateEnum.IN_F4_MENU)
			else
				UserState:Set(StateEnum.NORMAL)
			end
		end
	end)
end

return Watch
