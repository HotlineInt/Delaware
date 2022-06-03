local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
-- get knit bridge
local Knit = require(Carbon.Framework.Knit)
-- -- get WeaponsService
local WeaponsService = Knit:GetService("WeaponsService")
local Mouse = Carbon:GetPlayer():GetMouse()

local ViewModelFolder = ReplicatedStorage:WaitForChild("ViewModels")
local SoundUtil = require(script.Parent.Util.Sound)
export type Weapon = {
	Name: string,
	FireMode: string,
	Offset: Vector3,
	Ammo: number,
	MaxAmmo: number,
	ViewModel: Model,
	Tool: Tool,
}

local Class = require(Carbon.Util.Class)
local CBaseWeapon = Class("CBaseWeapon")

local ValidSounds = {
	"Shoot",
	"Reload",
	"Equip",
	"Unequip",
}

function CBaseWeapon:__init(Tool: Tool): Weapon
	self.Sounds = {}
	self.Animations = {}

	local FireMode = Tool:GetAttribute("FireMode") or "Manual"
	local MaxAmmo = Tool:GetAttribute("MaxAmmo") or 0
	local Ammo = Tool:GetAttribute("Ammo")
	local ViewModelName = Tool:GetAttribute("ViewModel") or Tool.Name
	local Animations = Tool:WaitForChild("Animations", 2)
	local Sounds = Tool:WaitForChild("Sounds", 2)

	if not Animations then
		Animations = Instance.new("Folder", Tool)
		Animations.Name = "Animations"
	end

	if not Sounds then
		Sounds = Instance.new("Folder", Tool)
		Sounds.Name = "Sounds"
	end

	-- Replace missing sounds with an error one as a placeholder reminder
	for _, SoundName in pairs(ValidSounds) do
		if not Sounds:FindFirstChild(SoundName) then
			SoundUtil:CreatePlaceholderSound(SoundName, Sounds)
		end
	end

	for _, Sound in pairs(Sounds:GetChildren()) do
		if Sound:IsA("Sound") then
			self.Sounds[Sound.Name] = Sound
		end
	end

	local ViewModel = ViewModelFolder:WaitForChild(ViewModelName, 4)

	if not ViewModel then
		error(string.format("Invalid ViewModel provided for %s", Tool.Name))
	end
	self.ViewModel = ViewModel:Clone()
	local Animator = ViewModel.Humanoid:WaitForChild("Animator")

	for _, Animation: Animation in pairs(Animations:GetChildren()) do
		local Track: AnimationTrack = Animator:LoadAnimation(Animation)

		self.Animations[Animation.Name] = Track
	end

	self.Connections = {}
	self.UsesAmmo = true
	self.Tool = Tool
	self.Reloading = false
	self.Name = Tool.Name
	self.FireMode = FireMode
	self.MaxAmmo = MaxAmmo
	self.Ammo = Ammo
	self.RPM = 1200
	self.Firing = true

	WeaponsService:RegisterWeapon(self)
end

-- stop all animations
function CBaseWeapon:StopAnimations()
	for _, Animation in pairs(self.Animations) do
		Animation:Stop()
	end
end

-- play/stop method
function CBaseWeapon:PlayAnimation(AnimationName: string, Loop: boolean)
	local Animation = self.Animations[AnimationName]

	if Animation then
		Animation:Play()
		WeaponsService:PlayAnimation(self, AnimationName)
		return Animation
	end
end

-- stop anim
function CBaseWeapon:StopAnimation(AnimationName: string)
	local Animation = self.Animations[AnimationName]

	if Animation then
		Animation:Stop()
	end
end

-- play sound method
function CBaseWeapon:PlaySound(SoundName: string)
	local Sound = self.Sounds[SoundName]

	if Sound then
		print("Playing back weapon sound: " .. SoundName)
		Sound:Play()
	else
		print("Missing sound jack: " .. SoundName)
	end
end

function CBaseWeapon:Equip()
	local EquipAnim: AnimationTrack = self:PlayAnimation("Equip")
	self:PlaySound("Equip")
	print("yahoo")
	--EquipAnim.Stopped:Wait()
	self:PlayAnimation("Idle")
	task.wait(0.05)

	EquipAnim = nil
end

function CBaseWeapon:Dequip()
	self:StopAnimation("Idle")
	WeaponsService:WeaponUnequipped(self)
	self:PlaySound("Dequip")
	self:PlayAnimation("Deequip")
	print("Based")
end

function CBaseWeapon:SetStat(Name: string, Value: any)
	-- Update our values as well
	if self[Name] then
		self[Name] = Value
	end

	self.Tool:SetAttribute(Name, Value)
	return Value
end

function CBaseWeapon:GetStat(Name: string)
	return self.Tool:GetAttribute(Name)
end

function CBaseWeapon:Fire()
	local IsReloading = self:GetStat("Reloading")

	if IsReloading and self.Reloading then
		return
	end

	if self.Ammo >= 0 then
		self.Firing = false
		self:PlayAnimation("Shoot")
		self:PlaySound("Shoot")
		WeaponsService:FireWeapon(self, Mouse.Hit.Position)
		self.Ammo = self:GetStat("Ammo")
	else
		print("nah bro")
	end
end

function CBaseWeapon:Reload()
	if self.Ammo < self.MaxAmmo then
		self.Reloading = true
		self:PlayAnimation("Reload")
		self:PlaySound("Reload")
		WeaponsService:Reload(self):await()
		self.Reloading = false
	end
end

return CBaseWeapon
