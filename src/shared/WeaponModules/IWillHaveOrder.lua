local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)

local PLayer = Carbon:GetPlayer()
local Camera = workspace.CurrentCamera

local CBaseWeapon = require(script.Parent.CBaseWeapon)

local ZhongliBurst, Base = Class("IWillHaveOrder", CBaseWeapon)
local CameraSettings = {
	Orientation = Vector3.new(26.72, 158.107, -0.544),
	Position = Vector3.new(1.307, -1.271, -2.95),
}

local MeteorSettings = {
	Orientation = Vector3.new(-37.53, -21.615, 0.602),
	Position = Vector3.new(-4.329, 8.361, 5.864),
}

local DestinationSettings = {
	Orientation = Vector3.new(-37.53, -21.615, 0.602),
	Position = Vector3.new(0.427, -2.747, -7.068),
}

function ZhongliBurst:CreateAttachment(Settings: {}, Location: BasePart)
	local Attachment = Instance.new("Attachment")
	Attachment.Name = "Attachment"

	Attachment.Parent = Location
	Attachment.Orientation = Settings.Orientation
	Attachment.Position = Settings.Position

	return Attachment
end

function ZhongliBurst:__init(Tool: Tool)
	Base.__init(self, Tool)

	self.Debounce = false
	self.FireMode = "Manual"
end

function ZhongliBurst:Fire()
	if self.Debounce then
		warn("i dont have order")
		return
	end
	self.Debounce = true
	warn("I will have order")
	local Character = PLayer.Character
	local Humanoid = Character:WaitForChild("Humanoid")
	Humanoid:UnequipTools()

	local HumanoidRoot = Character.HumanoidRootPart
	HumanoidRoot.Anchored = true

	local CameraCFrame = ZhongliBurst:CreateAttachment(CameraSettings, HumanoidRoot)
	local MeteorCFrame = ZhongliBurst:CreateAttachment(MeteorSettings, HumanoidRoot)
	local DestinationCFrame = ZhongliBurst:CreateAttachment(DestinationSettings, HumanoidRoot)

	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.CFrame = CameraCFrame.WorldCFrame

	local Meteor = Instance.new("Part")
	Meteor.Anchored = true
	Meteor.CFrame = MeteorCFrame.WorldCFrame
	Meteor.Name = "Meteor"
	Meteor.CanCollide = false
	Meteor.Parent = HumanoidRoot

	local Boom = TweenService:Create(Meteor, TweenInfo.new(2), { CFrame = DestinationCFrame.WorldCFrame })
	Boom:Play()

	Boom.Completed:Wait()
	HumanoidRoot.Anchored = false
	Camera.CameraType = Enum.CameraType.Custom
end

return ZhongliBurst
