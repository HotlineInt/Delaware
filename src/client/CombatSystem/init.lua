-- init.lua - contact@shiroko.me - 2022/05/31
-- ! Description: Combat Sys. VERY MESSY !!!!!!!!!!!!!!!!!!!

-- get camera
local Camera = workspace.CurrentCamera

-- get carbon
local ContextActionService = game:GetService("ContextActionService")
local PhysicsService = game:GetService("PhysicsService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Log = require(Carbon.Tier0.Logger)

-- get player from Carbon
local Player = Carbon:GetPlayer()

-- get knit bridge
local Knit = require(Carbon.Framework.Knit)
-- -- get WeaponsService
local WeaponsService = Knit:GetService("WeaponsService")
-- get viewmodels folder from ReplicatedStorage
local ViewModels = game:GetService("ReplicatedStorage"):WaitForChild("ViewModels")
-- get weapons folder from ReplicatedStorage
local WeaponModules = game:GetService("ReplicatedStorage"):WaitForChild("WeaponModules")

local CombatSys = {
	CurrentWeapon = nil,
	LoadedWeapons = {},
	LoadedTools = {},
	States = {
		ShouldUpdate = false,
		ShouldFire = false,
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
	Log:Debug("Processing viewmodels")
	local TOTAL_PROCESSED_VIEWMODELS = 0

	for _, ViewModel in pairs(ViewModels:GetChildren()) do
		TOTAL_PROCESSED_VIEWMODELS += 1
		for _, Part in pairs(ViewModel:GetDescendants()) do
			if not Part:IsA("BasePart") then
				continue
			end
			Part.CanQuery = false
			Part.CanCollide = false
			Part.CanTouch = false
			PhysicsService:SetPartCollisionGroup(Part, "ViewModels")
		end
	end

	Log:Debug(string.format("Processed %d ViewModels", TOTAL_PROCESSED_VIEWMODELS))

	ContextActionService:BindAction("Mouse", function(...)
		self:HandleAction(...)
	end, false, Enum.UserInputType.MouseButton1)

	task.spawn(function()
		while true do
			local CurrentWeapon = self.CurrentWeapon

			if self.States.ShouldFire and CurrentWeapon then
				Log:Debug("pew pew time")
				self:FireWeapon()
				task.wait(60 / CurrentWeapon.RPM)
			end

			task.wait()
		end
	end)
end

function CombatSys:OnCharacterAdded()
	-- clear up varaibles
	self.States.ShouldFire = false
	self.States.ShouldUpdate = false

	self.CurrentWeapon = nil
	self.LoadedTools = {}
	self.LoadedWeapons = {}

	-- get backpack
	local Backpack = Player:WaitForChild("Backpack")

	-- childadded on backpack
	-- just connect ChildAdded

	for _, Tool in pairs(Backpack:GetChildren()) do
		self:_CreateTool(Tool)
	end

	Backpack.ChildAdded:Connect(function(Tool: Tool)
		self:_CreateTool(Tool)
	end)
end

function CombatSys:_CreateTool(Tool: Tool)
	-- verify the weapon is valid
	if not Tool:IsA("Tool") then
		return
	end

	if self.LoadedTools[Tool] then
		return
	end

	-- call AddWeapon()
	local Class = self:AddWeapon(Tool)

	Tool.Equipped:Connect(function()
		Log:Debug("quite the goof")
		self:EquipWeapon(Class)
	end)

	Tool.Unequipped:Connect(function()
		self:DequipWeapon()
	end)
end

function CombatSys:HandleAction(ActionName: string, InputState, InputObject: InputObject)
	if not self.CurrentWeapon then
		return
	end

	if ActionName == "Mouse" and InputState == Enum.UserInputState.Begin then
		self.States.ShouldFire = true
	elseif
		ActionName == "Mouse" and InputState == Enum.UserInputState.End or InputState == Enum.UserInputState.Cancel
	then
		self.States.ShouldFire = false
	end
end

function CombatSys:AddWeapon(Tool: Tool): Weapon
	Log:Debug("Creating " .. Tool.Name)
	if not Tool:FindFirstChild("Animations") or not Tool:FindFirstChild("Sounds") then
		Log:Exception("Tool is missing critical stuff. Will not load.")
	end

	-- check if the tool has already been loaded
	if self.LoadedWeapons[Tool.Name] then
		Log:Debug("Weapon " .. Tool.Name .. " has already been loaded.")
		return
	end
	if self.LoadedTools[Tool] then
		Log:Debug("Tool " .. Tool.Name .. " has already been loaded.")
		return
	end

	local RequestedModule = Tool:GetAttribute("Module") or ""

	-- Get WeaponModule based on tool name
	local WeaponModule = WeaponModules:FindFirstChild(RequestedModule)
	if not WeaponModule then
		Log:Exception("WeaponModule not found for " .. Tool.Name)
	else
		WeaponModule = require(WeaponModule)
	end

	-- create weapon
	local Weapon = WeaponModule.new(Tool)

	-- add weapon class to self.LoadedWeapons
	self.LoadedTools[Tool] = true
	self.LoadedWeapons[Tool.Name] = Weapon

	return Weapon
end

function CombatSys:GetStat(StatName: string): any
	if not self.CurrentWeapon then
		Log:Exception("Can't do this with no CurrentWeapon")
		return
	end

	return self.CurrentWeapon:GetStat(StatName)
end

function CombatSys:SetStat(StatName: string, Value: any): nil
	if not self.CurrentWeapon then
		Log:Exception("Can't do this with no CurrentWeapon")
		return
	end

	return self.CurrentWeapon:SetStat(StatName, Value)
end

function CombatSys:FireWeapon()
	-- get current weapon
	local CurrentWeapon = self.CurrentWeapon

	if CurrentWeapon == nil then
		Log:Debug("Cant fire without a gun. Stupid!")
	end

	-- get current weapon's firemode
	local CurrentAmmo = self:GetStat("Ammo")

	if CurrentAmmo <= 0 then
		self.States.ShouldFire = false
		Log:Debug("Can't fire.")
		return
	end

	CurrentWeapon:Fire()
	self:SetStat("Ammo", CurrentAmmo - 1)
end

function CombatSys:EquipWeapon(Weapon: Weapon)
	self.States.ShouldFire = false
	self.States.ShouldUpdate = false
	-- Define variables based on the type

	-- Check if given weapon is not self.CurrentWeapon
	if self.CurrentWeapon == Weapon then
		Log:Exception("Cannot equip the current weapon")
		return
	end

	if self.CurrentWeapon then
		-- Dequip the current weapon
		Log:Debug("Dequipping existing weapon")
		self:DequipWeapon()
	end

	Log:Debug("setting currentweapon")
	-- Set current weapon to the given weapon
	self.CurrentWeapon = Weapon

	Log:Debug("setting viewmodel")
	local ViewModel = Weapon.ViewModel:Clone()
	ViewModel.Parent = Camera
	self.CurrentWeapon.ViewModel = ViewModel

	self.CurrentWeapon:Equip()

	-- Set ShouldUpdate to true
	self.States.ShouldUpdate = true
	Log:Debug("Equipped " .. Weapon.Name)
end

function CombatSys:DequipWeapon()
	self.States.ShouldFire = false
	self.States.ShouldUpdate = false
	-- Check if there's an current weapon available
	if not self.CurrentWeapon then
		error("Cannot dequip with no weapon equipped")
		return
	end

	-- Dequip the weapon
	self.CurrentWeapon.ViewModel.Parent = nil
	-- Cleanup
	self.CurrentWeapon:Dequip()

	-- Set ShouldUpdate to false
	self.States.ShouldUpdate = false
	self.CurrentWeapon = nil
end

function CombatSys:Update()
	local CurrentWeapon: Weapon = self.CurrentWeapon
	if not CurrentWeapon then
		return
	end

	if self.States.ShouldUpdate then
		local ViewModel: Model = CurrentWeapon.ViewModel
		ViewModel:SetPrimaryPartCFrame(Camera.CFrame)
	end
end

return CombatSys
