local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local CombatSystem = require(ReplicatedFirst:WaitForChild("Core"):WaitForChild("CombatSystem"))

local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)
local Knit = require(Carbon.Framework.Knit)
local WeaponsService = Knit:GetService("WeaponsService")
local Mouse = Carbon:GetPlayer():GetMouse()

local ViewModelFolder = ReplicatedStorage:WaitForChild("ViewModels")
local SoundUtil = require(script.Parent.Util.Sound)

local WeaponSpring = require(Carbon.Util.WeaponSpring)

local CHandsModel = ViewModelFolder:WaitForChild("CHands")
export type Weapon = {
	Name: string,
	FireMode: string,
	Offset: Vector3,
	Ammo: number,
	MaxAmmo: number,
	ViewModel: Model,
	Tool: Tool,
}

local CBaseWeapon = Class("CBaseWeapon")

local ValidSounds = {
	"Fire",
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

	local FireRate = Tool:GetAttribute("FireRate") or 700

	local WeaponModelName = Tool:GetAttribute("WeaponModel")
	local UseHands = Tool:GetAttribute("UseHands")

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
	local ViewModel
	if not UseHands then
		ViewModel = ViewModelFolder:WaitForChild(ViewModelName, 4)
		assert(ViewModel, string.format("Invalid ViewModel provided for %s", Tool.Name))

		ViewModel = ViewModel:Clone()
		self.ViewModel = ViewModel
	else
		local WeaponModel = ViewModelFolder.Weapons:FindFirstChild(WeaponModelName)
		assert(WeaponModel, "Invalid WeaponModel provided for " .. Tool.Name .. '"' .. WeaponModelName .. '"')
		ViewModel = CHandsModel:Clone()
		WeaponModel = WeaponModel:Clone()

		WeaponModel.Parent = ViewModel
		local ModelConnector = Instance.new("Motor6D")
		ModelConnector.Name = "ModelConnector"
		ModelConnector.Parent = ViewModel
		ModelConnector.Part0 = ViewModel.RightHand
		ModelConnector.Part1 = WeaponModel.PrimaryPart

		self.ViewModel = ViewModel
	end

	local Animator
	local Humanoid = ViewModel:FindFirstChild("Humanoid")
	if Humanoid then
		Animator = Humanoid:FindFirstChildOfClass("Animator")
	else
		Animator = ViewModel:FindFirstChildOfClass("AnimationController")
	end

	ViewModel.Parent = ReplicatedStorage
	if Animator then
		for _, Animation: Animation in pairs(Animations:GetChildren()) do
			local Track: AnimationTrack = Animator:LoadAnimation(Animation)

			self.Animations[Animation.Name] = {
				Running = false,
				Track = Track,
			}
		end
	else
		warn("Animator is missing for ViewModel", ViewModel, "Your animations will not work!")
	end

	self.Connections = {}
	self.Springs = {
		Sway = WeaponSpring.Create(),
		Recoil = WeaponSpring.Create(),
	}

	self.UsesAmmo = true
	self.Tool = Tool
	self.CanRecoil = true
	self.RecoilConfig = Vector3.new(0.03)
	self.Reloading = false
	self.Name = Tool.Name
	self.FireMode = FireMode
	self.MaxAmmo = MaxAmmo
	self.Ammo = Ammo
	self.RPM = FireRate
	self.Firing = true

	self.CanADS = true
	self.ADSOffset = Vector3.new()

	WeaponsService:RegisterWeapon(self.Tool)
end

-- stop all animations
function CBaseWeapon:StopAnimations()
	for _, Animation in pairs(self.Animations) do
		Animation.Running = false
		Animation.Track:Stop()
	end
end

-- play/stop method
function CBaseWeapon:PlayAnimation(AnimationName: string, Loop: boolean, ClientOnly: boolean, CheckIfRunning: boolean)
	local Animation: { Playing: boolean, Track: AnimationTrack } = self.Animations[AnimationName]

	if Animation and CombatSystem.CurrentWeapon == self then
		local Track: AnimationTrack = Animation.Track

		if CheckIfRunning == true then
			if Animation.Running then
				return
			end
		else
			print("Playing", Animation)
		end

		Animation.Running = true
		Track:Play()
		if not ClientOnly then
			WeaponsService:PlayAnimation(self.Tool, AnimationName)
		end

		return Animation.Track
	else
		print("nah fam")
	end
end

-- anim randomization
function CBaseWeapon:GetRandomAnim(BaseAnimName: string)
	local RandomFireAnim = math.random(1, 2)
	local FireAnimName = BaseAnimName .. tostring(RandomFireAnim)

	return FireAnimName
end

-- stop anim
function CBaseWeapon:StopAnimation(AnimationName: string, Loop: boolean, ClientOnly: boolean)
	local Animation = self.Animations[AnimationName]

	if Animation then
		if not ClientOnly then
			WeaponsService:StopAnimation(self.Tool, AnimationName)
		end
		Animation.Running = false
		Animation.Track:Stop()
	end
end

-- play sound method
function CBaseWeapon:PlaySound(SoundName: string)
	local Sound = self.Sounds[SoundName]

	if Sound then
		print("Playing back weapon sound: " .. SoundName)
		WeaponsService:PlaySound(self.Tool, SoundName)

		--local Clone = Sound:Clone()
		--Clone.Parent = Sound.Parent

		--Clone:Play()
		--local Stopped
		--Stopped = Clone.Stopped:Connect(function()
		--	Clone:Destroy()
		--	Stopped:Disconnect()
		--end)
	else
		print("Missing sound jack: " .. SoundName)
	end
end

function CBaseWeapon:Equip()
	local EquipAnim: AnimationTrack = self:PlayAnimation("Equip")
	self:PlaySound("Equip")
	WeaponsService:WeaponEquipped(self.Tool)
	EquipAnim.Stopped:Wait()
	self:PlayAnimation("Idle")

	EquipAnim = nil
end

function CBaseWeapon:Dequip()
	WeaponsService:WeaponUnequipped(self.Tool)
	self:StopAnimations()
	self:PlaySound("Dequip")
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
		self:PlayAnimation(self:GetRandomAnim("Fire"))
		self:PlaySound("Shoot")
		task.spawn(function()
			WeaponsService:FireWeapon(self.Tool, Mouse.Hit.Position)
			self.Ammo = self:GetStat("Ammo")
		end)
	else
		print("nah bro")
	end
end

function CBaseWeapon:Reload()
	local Ammo = self.Tool:GetAttribute("Ammo")

	if Ammo < self.MaxAmmo then
		self.Reloading = true
		self:PlayAnimation("Reload")
		self:PlaySound("Reload")
		WeaponsService:Reload(self.Tool):await()
		self.Reloading = false
	end
end

function CBaseWeapon:Destroy()
	self.ViewModel:Destroy()
	self.ADSOffset = nil
	self.Springs = {}

	for _, Connection: RBXScriptConnection in pairs(self.Connections) do
		Connection:Disconnect()
	end

	self.Name = nil
	self.RecoilConfig = nil
end

return CBaseWeapon
