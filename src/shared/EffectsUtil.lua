local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EffectsFolder = ReplicatedStorage:WaitForChild("Effects")

local Folders = {
	Materials = EffectsFolder:WaitForChild("Materials"),
	BulletHoles = EffectsFolder:WaitForChild("BulletHoles"),
}
local ParticleDuration = 0.05

local ValidBodyParts = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"LeftFoot",
	"LeftLowerLeg",
	"LeftUpperLeg",
	"RightFoot",
	"RightLowerLeg",
	"RightUpperLeg",
	"LeftHand",
	"LeftLowerArm",
	"LeftUpperArm",
	"RightHand",
	"RightLowerArm",
	"RightUpperArm",
	"HumanoidRootPart",
	"Torso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

local RandomUtil = require(ReplicatedStorage.Carbon.Util.Random)

local Effects = {}

function Effects:GetMaterialFolder(Part: BasePart): Folder
	local MaterialFolder

	local MaterialName = tostring(Part.Material):gsub("Enum.Material.", "")
	local EnumMaterialFolder = Folders.Materials:FindFirstChild(MaterialName)

	if table.find(ValidBodyParts, Part.Name) then
		MaterialFolder = Folders.Materials.Human
	elseif EnumMaterialFolder then
		MaterialFolder = EnumMaterialFolder
	else
		MaterialFolder = Folders.Materials.Default
	end

	return MaterialFolder
end

function Effects:HitEffect(Part: BasePart, Position: Vector3, Normal: Vector3?)
	local Attachment = Instance.new("Attachment")
	print(Position, Normal)
	Attachment.CFrame = CFrame.new(Position, Position + Normal)
	Attachment.Parent = workspace.Terrain

	local HitPartSequence = ColorSequence.new(Part.Color)

	do
		local MaterialFolder = Effects:GetMaterialFolder(Part)
		local HolesFolder = MaterialFolder:FindFirstChild("Holes")
		local ParticlesFolder = MaterialFolder.Particles.Used

		for _, Particle: ParticleEmitter in pairs(ParticlesFolder:GetChildren()) do
			local UsePartColor = Particle:FindFirstChild("HitPartColor") ~= nil
			local Duration = ParticleDuration

			-- if DurationOverride ~= nil then
			-- 	Duration = DurationOverride.Value
			-- end

			local NewParticle = Particle:Clone()

			if UsePartColor then
				NewParticle.Color = HitPartSequence
			end

			task.delay(Duration, function()
				NewParticle.Enabled = false
				Debris:AddItem(NewParticle, NewParticle.Lifetime.Max)
			end)

			NewParticle.Enabled = true
			NewParticle.Parent = Attachment
		end

		if HolesFolder then
			local BulletHole = Instance.new("Part")
			BulletHole.Transparency = 1
			BulletHole.CanQuery = false
			BulletHole.Anchored = true
			BulletHole.CanCollide = false

			BulletHole.CFrame = CFrame.new(Position, Position - Normal)
				* CFrame.Angles(math.pi / 2, RandomUtil:randf(0, 2) * math.pi, 0)
			BulletHole.Size = Vector3.new(1, 0, 1)

			BulletHole.CanTouch = false
			BulletHole.Name = "BulletHole"
			BulletHole.FormFactor = "Custom"
			BulletHole.TopSurface = 0
			BulletHole.BottomSurface = 0
			BulletHole.Transparency = 1

			local Decal = RandomUtil:rlist(HolesFolder:GetChildren()):Clone()
			Decal.Face = Enum.NormalId.Top
			Decal.Parent = BulletHole

			BulletHole.Parent = Part
			Debris:AddItem(BulletHole, 10)
		end
	end

	return Attachment
end

function Effects:SoundEffect(Position: Vector3, MaterialFolder: Folder)
	local Attachment = Instance.new("Attachment")
	Attachment.WorldPosition = Position
	Attachment.Parent = workspace.Terrain

	local Sound = RandomUtil:rlist(MaterialFolder.Sounds:GetChildren()):Clone()
	Sound.PlaybackSpeed = RandomUtil:randf(0.8, 1.25)
	Sound.Parent = Attachment
	Sound.MaxDistance = 60
	Sound:Play()
	task.delay(Sound.TimeLength / Sound.PlaybackSpeed, function()
		Sound:Destroy()
		Attachment:Destroy()
	end)
end

return Effects
