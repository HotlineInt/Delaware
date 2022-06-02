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
	print("Processing viewmodels")
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

	print(string.format("Processed %d ViewModels", TOTAL_PROCESSED_VIEWMODELS))

	ContextActionService:BindAction("Mouse", function(...)
		self:HandleAction(...)
	end, false, Enum.UserInputType.MouseButton1)

	ContextActionService:BindAction("Reload", function(...)
		self:HandleAction(...)
	end, false, Enum.KeyCode.R)

	task.spawn(function()
		while true do
			local CurrentWeapon = self.CurrentWeapon

			if self.States.ShouldFire and CurrentWeapon then
				print("pew pew time")
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
		print("quite the goof")
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

	if ActionName == "Reload" and InputState == Enum.UserInputState.Begin then
		self:ReloadWeapon()
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
	print("Creating", Tool)
	if not Tool:FindFirstChild("Animations") or not Tool:FindFirstChild("Sounds") then
		error("Tool is missing critical stuff. Will not load.")
	end

	-- check if the tool has already been loaded
	if self.LoadedWeapons[Tool.Name] then
		warn("Weapon " .. Tool.Name .. " has already been loaded.")
		return
	end
	if self.LoadedTools[Tool] then
		warn("Tool " .. Tool.Name .. " has already been loaded.")
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
	self.LoadedTools[Tool] = true
	self.LoadedWeapons[Tool.Name] = Weapon

	return Weapon
end

function CombatSys:GetStat(StatName: string): any
	if not self.CurrentWeapon then
		error("Can't do this with no CurrentWeapon")
		return
	end

	return self.CurrentWeapon:GetStat(StatName)
end

function CombatSys:GetState()
	if not self.CurrentWeapon then
		error("Cannot pull state with no CurrentWeapon")
		return
	end

	return self.CurrentWeapon.Tool:GetAttribute("State")
end

function CombatSys:SetStat(StatName: string, Value: any): nil
	if not self.CurrentWeapon then
		error("Can't do this with no CurrentWeapon")
		return
	end

	return self.CurrentWeapon:SetStat(StatName, Value)
end

function CombatSys:FireWeapon()
	-- get current weapon
	local CurrentWeapon = self.CurrentWeapon

	if CurrentWeapon == nil then
		return
	end

	-- get current weapon's firemode
	local CurrentAmmo = self:GetStat("Ammo")

	-- get state
	local State = self:GetState()

	-- if not idle then cancel
	if State ~= "Idle" then
		warn("Cannot fire weapon while not in idle state")
		return
	end

	if CurrentAmmo <= 0 then
		self.States.ShouldFire = false
		print("Can't fire.")
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
		error("Cannot equip the current weapon")
		return
	end

	if self.CurrentWeapon then
		-- Dequip the current weapon
		warn("Dequipping existing weapon")
		self:DequipWeapon()
	end

	print("setting currentweapon")
	-- Set current weapon to the given weapon
	self.CurrentWeapon = Weapon

	print("setting viewmodel")
	local ViewModel = Weapon.ViewModel:Clone()
	ViewModel.Parent = Camera
	self.CurrentWeapon.ViewModel = ViewModel

	self.CurrentWeapon:Equip()

	print("updating")
	-- Set ShouldUpdate to true
	self.States.ShouldUpdate = true
	print("Equipped " .. Weapon.Name)
end

function CombatSys:ReloadWeapon()
	local CurrentWeapon = self.CurrentWeapon
	if not CurrentWeapon then
		error("Cannot reload with no current weapon equipped!")
		return
	end

	-- get state
	local State = self:GetState()

	-- if not idle then cancel
	if State ~= "Idle" then
		warn("Cannot reload weapon while not in idle state")
		return
	end

	self.States.ShouldFire = false
	CurrentWeapon:Reload()
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
