local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local TweenService = game:GetService("TweenService")
local CUI = require(Carbon.UI.CUI)
local Component = require(Carbon.Vendor.Component)

local Camera = workspace.CurrentCamera
local Player = Carbon:GetPlayer()

local Nakonix = require(script.Nakonix)
local Computer = Component.new({ Tag = "Computers" })

local MouseBehaviour = require(script.Parent.Parent.Parent.System.MouseBehaviour)

function Computer:Construct()
	local Model = self.Instance
	local Monitor = Model:WaitForChild("Screen")

	local ProximityPrompt: ProximityPrompt = Monitor:WaitForChild("ProximityPrompt")
	local CameraView: Attachment = Monitor:WaitForChild("CameraView")

	self.Prompt = ProximityPrompt

	local ViewTween = TweenService:Create(
		Camera,
		TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{ CFrame = CameraView.WorldCFrame }
	)
	self.ViewTween = ViewTween

	local Nakonix = Nakonix.new(Monitor, self)
	local Gui = Nakonix.Gui
	local Surface = Nakonix.Surface

	self.Gui = Gui
	self.Nakonix = Nakonix
	self.Surface = Surface

	ProximityPrompt.Triggered:Connect(function(TriggerPlayer: Player)
		if TriggerPlayer ~= Player then
			return
		end

		self:Enter(Player)
	end)
end

function Computer:Enter(Player: Player)
	local Character = Player.Character
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		warn("Huh?")
		return
	end

	self.Gui:SetProperty("AlwaysOnTop", true)

	Humanoid:UnequipTools()

	self.Prompt.Enabled = false
	Camera.CameraType = Enum.CameraType.Scriptable
	self.ViewTween:Play()
	UserInputService.MouseIconEnabled = true
	MouseBehaviour:AddMenu("MENU_PC")
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end

function Computer:Exit()
	self.Gui:SetProperty("AlwaysOnTop", false)
	self.Prompt.Enabled = true
	Camera.CameraType = Enum.CameraType.Custom
	UserInputService.MouseIconEnabled = false
	MouseBehaviour:RemoveMenu("MENU_PC")
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
end

return Computer
