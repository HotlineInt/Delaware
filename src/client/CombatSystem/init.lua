-- init.lua - contact@shiroko.me - 2022/05/31
-- ! Description: Combat Sys. VERY MESSY !!!!!!!!!!!!!!!!!!!

-- get camera
local Camera = workspace.CurrentCamera

-- get carbon
local ContextActionService = game:GetService("ContextActionService")
local PhysicsService = game:GetService("PhysicsService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
-- get player from Carbon
local Player = Carbon:GetPlayer()

-- get knit bridge
-- local Knit = require(Carbon.Framework.Knit)
-- -- get WeaponsService
-- local WeaponsService = Knit:GetService("WeaponsService")
-- get viewmodels folder from ReplicatedStorage
local ViewModels = game:GetService("ReplicatedStorage"):WaitForChild("ViewModels")
-- get weapons folder from ReplicatedStorage
local WeaponModules = game:GetService("ReplicatedStorage"):WaitForChild("WeaponModules")

local CombatSys = {
	CurrentWeapon = nil,
	LoadedWeapons = {},
	States = {
		ShouldUpdate = false,
	},
}

export type Weapon = {
	Name: string,
	FireMode: string,
	Offset: Vector3,
	Ammo: number,
	MaxAmmo: number,
	ViewModel: Model,
	Tool: Tool,
}

function CombatSys:Load()
	print("Processing viewmodels")
	local TOTAL_PROCESSED_VIEWMODELS = 0

	for _, ViewModel in pairs(ViewModels:GetChildren()) do
		TOTAL_PROCESSED_VIEWMODELS += 1
		for _, Part in pairs(ViewModel:GetDescendants()) do
			if not Part:IsA("BasePart") then
				continue
			end
			PhysicsService:SetPartCollisionGroup(Part, "ViewModels")
		end
	end

	print(string.format("Processed %d ViewModels", TOTAL_PROCESSED_VIEWMODELS))

	ContextActionService:BindAction("Fire", function(...)
		self:HandleAction(...)
	end, false, Enum.UserInputType.MouseButton1)
end

function CombatSys:OnCharacterAdded()
	-- get backpack
	local Backpack = Player:WaitForChild("Backpack")

	-- childadded on backpack
	-- just connect ChildAdded

	for _, Tool in pairs(Backpack:GetChildren()) do
		-- verify the weapon is valid
		if not Tool:IsA("Tool") then
			return
		end

		-- call AddWeapon()
		self:AddWeapon(Tool)
	end

	Backpack.ChildAdded:Connect(function(Tool: Tool)
		-- verify the weapon is valid
		if not Tool:IsA("Tool") then
			return
		end

		-- call AddWeapon()
		self:AddWeapon(Tool)
	end)
end

function CombatSys:HandleAction(ActionName: string, InputState, InputObject: InputObject)
	if not self.CurrentWeapon then
		return
	end

	if ActionName == "Fire" then
		self:FireWeapon()
	end
end

function CombatSys:AddWeapon(Tool: Tool): Weapon
	print("Creating", Tool)
	if not Tool:FindFirstChild("Animations") or not Tool:FindFirstChild("Sounds") then
		error("Tool is missing critical stuff. Will not load.")
	end

	-- check if the tool has already been loaded
	if self.LoadedWeapons[Tool.Name] then
		warn("Weapon " .. Tool.Name .. " has already been loaded.")
		return
	end
	local RequestedModule = Tool:GetAttribute("Module") or ""

	-- Get WeaponModule based on tool name
	local WeaponModule = WeaponModules:FindFirstChild(RequestedModule)
	if not WeaponModule then
		error("WeaponModule not found for " .. Tool.Name)
	else
		WeaponModule = require(WeaponModule)
	end

	-- create weapon
	local Weapon = WeaponModule.new(Tool)

	-- add weapon class to self.LoadedWeapons
	self.LoadedWeapons[Tool.Name] = Weapon

	self:EquipWeapon({
		Tool = Tool,
		Name = Tool.Name,
		ViewModel = ViewModels.Pistol,
	})
end

function CombatSys:FireWeapon()
	-- get current weapon
	local CurrentWeapon = self.CurrentWeapon
	-- get current weapon's firemode
	local FireMode = CurrentWeapon.FireMode

	print("pew pew")
end

function CombatSys:EquipWeapon(Weapon: Weapon)
	-- Define variables based on the type
	local Tool = Weapon.Tool
	local Animations = Tool:FindFirstChild("Animations")
	local Sounds = Tool:FindFirstChild("Sounds")
	local MaxAmmo = Tool:GetAttribute("MaxAmmo")
	local Ammo = Tool:GetAttribute("Ammo")

	-- Check if given weapon is not self.CurrentWeapon
	if self.CurrentWeapon == Weapon then
		error("Cannot equip the current weapon")
		return
	end

	if self.CurrentWeapon then
		-- Dequip the current weapon
		self:DequipWeapon()
	end

	-- Set current weapon to the given weapon
	self.CurrentWeapon = Weapon

	local ViewModel = Weapon.ViewModel:Clone()
	ViewModel.Parent = Camera
	self.CurrentWeapon.ViewModel = ViewModel

	-- Set ShouldUpdate to true
	self.States.ShouldUpdate = true
	print("Equipped " .. Weapon.Name)
end

function CombatSys:DequipWeapon()
	-- Check if there's an current weapon available
	if not self.CurrentWeapon then
		error("Cannot dequip with no weapon equipped")
		return
	end

	-- Dequip the weapon
	self.CurrentWeapon.ViewModel:Destroy()
	self.CurrentWeapon:Dequip()
	-- Cleanup
	self.CurrentWeapon = nil

	-- Set ShouldUpdate to false
	self.States.ShouldUpdate = false
end

function CombatSys:Update()
	local CurrentWeapon: Weapon = self.CurrentWeapon

	if self.States.ShouldUpdate and CurrentWeapon then
		local ViewModel: Model = CurrentWeapon.ViewModel
		ViewModel:SetPrimaryPartCFrame(Camera.CFrame)
	end
end

return CombatSys
