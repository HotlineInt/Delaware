local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)

local Config = require(script.Parent.Parent.BasicConfig)

local BaseType = Class("SVBseType")

function BaseType:__init(WeaponService: {})
	self.WeaponService = WeaponService
end

function BaseType:FireWeapon(Player: Player, Weapon: Tool, FiresTo: Vector3)
	local WeaponService = self.WeaponService

	local Damage = Weapon:GetAttribute("Damage")

	local Character = Player.Character

	local Params: RaycastParams = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Blacklist
	Params.FilterDescendantsInstances = { Character }

	local Origin = Character.Head.Position
	local Direction = (FiresTo - Origin).Unit

	local Result = workspace:Raycast(Origin, Direction * 300, Params)

	if Result then
		--RayVisualizer(Origin, Result.Position)
		local Humanoid = WeaponService:GetHumanoid(Result.Instance)

		if Humanoid then
			WeaponService.OnPlayerHit:Fire(Player, Result.Instance, Damage)
			Humanoid:TakeDamage(Damage)
		end

		--	WeaponService.Client.OnEffectRequest:Fire(Player, "Wall", Result.Instance, Result.Position, Result.Normal)
		--	WeaponService.Client.OnEffectRequest:Fire(Player, "Sound", Result.Instance)

		Humanoid = nil
	else
		warn("Raycasting failed!", Player)
	end

	Weapon:SetAttribute("Ammo", Weapon:GetAttribute("Ammo") - 1)
	WeaponService:SetState(Weapon, "Idle")
end

return BaseType
