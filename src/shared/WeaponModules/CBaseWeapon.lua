local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
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

	self.Tool = Tool
	self.Name = Tool.Name
	self.FireMode = FireMode
	self.MaxAmmo = MaxAmmo
	self.Ammo = Ammo
	self.ViewModel = ViewModel
end

function CBaseWeapon:Equip()
	print("yahoo")
end

function CBaseWeapon:Dequip()
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
	if self.Ammo >= 0 then
		print("Pew")
		self.Ammo = self.Ammo - 1
	else
		print("nah bro")
	end
end

return CBaseWeapon
