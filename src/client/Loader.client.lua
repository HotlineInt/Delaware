script.Parent:RemoveDefaultLoadingScreen()
--local Playerlist = require(script.Parent:WaitForChild("Playerlist"))
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))

local LaunchTestEnv = false

if LaunchTestEnv then
	local TestRunner = require(script.Parent.TestRunner)
	TestRunner:Begin()
	return
end

local TEST = Carbon:IsStudio()

Carbon:RegisterModule(script.Parent.Console)
Carbon:RegisterModule(script.Parent.Settings.SettingsWidget)
Carbon:RegisterModule(script.Parent.Footsteps)

if TEST then
	Carbon:RegisterModule(script.Parent.HUD)

	for _, DebugModule in pairs(script.Parent.Debug:GetChildren()) do
		Carbon:RegisterModule(DebugModule)
	end
end

Carbon:Start()
StarterGui:SetCore("TopbarEnabled", false)
UserInputService.MouseIconEnabled = false
