local WeaponService = require(script.Parent.Parent)

return function(Player: Player, Weapon: Tool, Origin: Vector3, Direction: Vector3)
	local Result = workspace:Raycast(Origin, Direction * 300)
	if not Result then
		return
	end
	WeaponService:ProcessDamage(Player, Weapon, Result)

	WeaponService.Client.OnEffectRequest:Fire(Player, "Wall", Result.Instance, Result.Position, Result.Normal)
	WeaponService.Client.OnEffectRequest:Fire(Player, "Sound", Result.Instance)
end
