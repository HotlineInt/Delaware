return function(registry)
	print("hi")
	registry:RegisterType(
		"weapontype",
		registry.Cmdr.Util.MakeEnumType("weapon_type", { "Melee", "Missile", "Spread", "Bullet" })
	)
end
