local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
-- get knit bridge
local Knit = require(Carbon.Framework.Knit)
-- -- get WeaponsService
local WeaponsService = Knit:GetService("WeaponsService")
local Mouse = Carbon:GetPlayer():GetMouse()

local ViewModelFolder = ReplicatedStorage:WaitForChild("ViewModels")

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

function CBaseWeapon:__init(Tool: Tool): Weapon
	local FireMode = Tool:GetAttribute("FireMode") or "Manual"
	local MaxAmmo = Tool:GetAttribute("MaxAmmo") or 0
	local Ammo = Tool:GetAttribute("Ammo")
	local ViewModelName = Tool:GetAttribute("ViewModel") or Tool.Name

	local ViewModel = ViewModelFolder:WaitForChild(ViewModelName, 4)

	if not ViewModel then
		error(string.format("Invalid ViewModel provided for %s", Tool.Name))
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
	self.ViewModel = ViewModel:Clone()

	WeaponsService:RegisterWeapon(self)
end

function CBaseWeapon:Equip()
	print("yahoo")
end

function CBaseWeapon:Dequip()
	WeaponsService:WeaponUnequipped(self)
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
		WeaponsService:FireWeapon(self, Mouse.Hit.Position)
		self.Ammo = self:GetStat("Ammo")
	else
		print("nah bro")
	end
end

function CBaseWeapon:Reload()
	if self.Ammo < self.MaxAmmo then
		self.Reloading = true
		WeaponsService:Reload(self):await()
		self.Reloading = false
	end
end

return CBaseWeapon
