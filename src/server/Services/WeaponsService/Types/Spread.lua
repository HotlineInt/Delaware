local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local FastCast = require(Carbon.Vendor.FastCast)
local WeaponService = require(script.Parent.Parent)

local Caster = FastCast.new()

local MIN_SPREAD = 1
local MAX_SPREAD = 5

local function Fire(Origin, Direction: Vector3, CastBehaviour)
	local DirectionCFrame = CFrame.new(Vector3.new(), Direction)
	local SpreadDirection = CFrame.fromOrientation(0, 0, math.random(0, math.pi * 2))
	local SpreadAngle = CFrame.fromOrientation(math.rad(math.random(MIN_SPREAD, MAX_SPREAD)), 0, 0)
	local FinalDirection = (DirectionCFrame * SpreadDirection * SpreadAngle).LookVector

	Caster:Fire(Origin, FinalDirection, 1000, CastBehaviour)
end

return function(Player: Player, Weapon: Tool, Origin: Vector3, Direction: Vector3)
	local CastBehaviour = FastCast.newBehavior()
	CastBehaviour.RaycastParams = RaycastParams.new()
	CastBehaviour.RaycastParams.FilterDescendantsInstances = { Player.Character, Weapon }
	CastBehaviour.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	CastBehaviour.Acceleration = Vector3.new(0, -workspace.Gravity, 0)

	Caster.RayHit:Connect(function(_, Result: RaycastResult)
		WeaponService:ProcessDamage(Player, Weapon, Result, false, true)

		WeaponService.Client.OnEffectRequest:Fire(Player, "Wall", Result.Instance, Result.Position, Result.Normal)
		WeaponService.Client.OnEffectRequest:Fire(Player, "Sound", Result.Instance)
	end)

	for _ = 1, MAX_SPREAD, 1 do
		Fire(Origin, Direction, CastBehaviour)
	end
end
