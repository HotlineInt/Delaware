script.Parent:RemoveDefaultLoadingScreen()
--local Playerlist = require(script.Parent:WaitForChild("Playerlist"))
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))

local LaunchTestEnv = false

if LaunchTestEnv then
	local TestRunner = require(script.Parent.TestRunner)
	TestRunner:Begin()
	return
end

local TEST = Carbon:IsStudio()

Carbon:RegisterModule(script.Parent.Notification)
Carbon:RegisterModule(script.Parent.Console)
Carbon:RegisterModule(script.Parent.Settings.SettingsWidget)
Carbon:RegisterModule(script.Parent.Footsteps)

if TEST then
	Carbon:RegisterModule(script.Parent.HUD)
	--require(script.Parent.Screens.BuySupporter)():Mount(Carbon:GetPlayer().PlayerGui)

	for _, DebugModule in pairs(script.Parent.Debug:GetChildren()) do
		Carbon:RegisterModule(DebugModule)
	end

	Carbon:RegisterModule(script.Parent.CombatSystem)
end

Carbon:Start()
--Carbon.Modules["CombatSystem"]:EquipWeapon(Carbon.Modules.CombatSystem.LoadedWeapons["Pistol"])
-- local Info = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
-- local StartFOV = Camera.FieldOfView
-- local ZoomAnimations = {
-- 	ZoomIn = TweenService:Create(Camera, Info, { FieldOfView = 15 }),
-- 	ZoomOut = TweenService:Create(Camera, Info, { FieldOfView = StartFOV }),
-- }

-- UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
-- 	if gameProcessedEvent then
-- 		return
-- 	end

-- 	if input.UserInputType == Enum.UserInputType.MouseButton2 then
-- 		ZoomAnimations.ZoomIn:Play()
-- 	end
-- end)

-- UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
-- 	if gameProcessedEvent then
-- 		return
-- 	end

-- 	if input.UserInputType == Enum.UserInputType.MouseButton2 then
-- 		ZoomAnimations.ZoomOut:Play()
-- 	end
-- end)

Camera.FieldOfView = 90
--StarterGui:SetCore("TopbarEnabled", false)

-- debug purposes only !!
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
UserInputService.MouseIconEnabled = false
