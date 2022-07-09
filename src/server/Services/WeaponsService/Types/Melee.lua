local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local RaycastHitbox = require(Carbon.Vendor.RaycastHitboxV4)

local WorldModels = require(script.Parent.Parent.WorldModels)

local Hitboxes = {}

return function(Player: Player, Weapon: Tool, Origin: Vector3, Direction: Vector3)
	local Hitbox = Hitboxes[Weapon]
	local WorldModel = WorldModels:GetPlayerWorldModel(Player, Weapon)

	local DamageTime = Weapon:GetAttribute("DamageTime")
	local Damage = Weapon:GetAttribute("Damage")

	if not Hitbox then
		print("Creating new hitbox")
		local Params = RaycastParams.new()
		Params.FilterType = Enum.RaycastFilterType.Blacklist
		Params.FilterDescendantsInstances = { WorldModel, Player.Character }

		Hitbox = RaycastHitbox.new(WorldModel)
		Hitbox.RaycastParams = Params
		Hitboxes[Weapon] = Hitbox

		Hitbox.OnHit:Connect(function(Hit, Humanoid: Humanoid)
			Humanoid:TakeDamage(Damage)
		end)
	end

	Hitbox:HitStart(DamageTime)
end
	