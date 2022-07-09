local WeaponService = require(script.Parent.Parent)

return function(Player: Player, Weapon: Tool, Origin: Vector3, Direction: Vector3)
	local Character = Player.Character
	local Params: RaycastParams = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Blacklist
	Params.FilterDescendantsInstances = { Character }

	local Result = workspace:Raycast(Origin, Direction * 300, Params)

	if not Result then
		return
	end
	WeaponService:ProcessDamage(Player, Weapon, Result)

	WeaponService.Client.OnEffectRequest:Fire(Player, "Wall", Result.Instance, Result.Position, Result.Normal)
	WeaponService.Client.OnEffectRequest:Fire(Player, "Sound", Result.Instance)
end
