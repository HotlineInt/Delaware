local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local FastCast = require(Carbon.Vendor.FastCast)

local WeaponService = require(script.Parent.Parent)
local WorldModels = require(script.Parent.Parent.WorldModels)

local MissileCaster = FastCast.new()
local Templates = ReplicatedStorage:WaitForChild("Templates")

local MissilesFolder = Instance.new("Folder")
MissilesFolder.Parent = workspace
MissilesFolder.Name = "Missiles"

local function LengthChanged(Cast, LastPoint, Direction: Vector3, Length: Vector3, Velocity: Vector3, Missile: Instance)
	if Missile then
		local Length = Missile.Size.Z / 2
		local Offset = CFrame.new(0, 0, -(Length - Length))
		Missile.CFrame = CFrame.lookAt(LastPoint, LastPoint + Direction):ToWorldSpace(Offset)
	end
end

MissileCaster.CastTerminating:Connect(function(Caster, Result, Velocity, Bullet)
	if Bullet then
		Bullet:Destroy()
	end
end)

MissileCaster.LengthChanged:Connect(LengthChanged)

return function(Player: Player, Weapon: Tool, Origin: Vector3, Direction: Vector3)
	local WorldModel: Model = WorldModels:GetPlayerWorldModel(Player, Weapon)
	local MissilePoint: Attachment = WorldModel.PrimaryPart:FindFirstChild("MissilePoint")

	assert(MissilePoint, "Missing MissilePoint, cannot fire missile type weapon")

	local CastBehaviour = FastCast.newBehavior()
	CastBehaviour.RaycastParams = RaycastParams.new()
	CastBehaviour.AutoIgnoreContainer = MissilesFolder
	CastBehaviour.CosmeticBulletContainer = MissilesFolder
	CastBehaviour.CosmeticBulletTemplate = Templates.Missile
	CastBehaviour.RaycastParams.FilterDescendantsInstances = { Player.Character, Weapon }
	CastBehaviour.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local RayhitConnection: RBXScriptConnection = nil

	RayhitConnection = MissileCaster.RayHit:Connect(function(Caster, Result: RaycastResult, Velocity: Vector3)
		local Explosion = Instance.new("Explosion")
		Explosion.Parent = workspace

		Explosion.Position = Result.Position
		Explosion.BlastRadius = 25
		Explosion.BlastPressure = 500

		WeaponService.Client:PlaySound(Player, Weapon, "Boom")

		Explosion.Hit:Connect(function(Hit: BasePart)
			local HumanoidRootPart = Hit.Parent:FindFirstChild("HumanoidRootPart")
				or Hit.Parent.Parent:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				local HitPlayer = Players:GetPlayerFromCharacter(HumanoidRootPart.Parent)

				if HitPlayer == Player then
					return
				end

				local DirectionVector = (HumanoidRootPart.CFrame.Position - Explosion.Position).unit
				HumanoidRootPart.Velocity = DirectionVector * 100

				WeaponService.Client.OnPlayerHit:Fire(Player, HumanoidRootPart, HumanoidRootPart.Parent.Humanoid.Health)
			end
		end)

		RayhitConnection:Disconnect()
	end)

	MissileCaster:Fire(MissilePoint.WorldPosition, Direction, 50, CastBehaviour)
end
