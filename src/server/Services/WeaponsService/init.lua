local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)
local Signal = require(Carbon.Util.Signal)
local Create = require(Carbon.Util.Create)

local Players = game:GetService("Players")

local Config = require(script.BasicConfig)

local StateEnum = {
	Idle = "Idle",
	Firing = "Firing",
	Reloading = "Reloading",
}

local WeaponService = {
	Client = {
		OnPlayerHit = Knit:CreateSignal("OnPlayerHit"),
		OnEffectRequest = Knit:CreateSignal("OnEffectRequest"),
	},
	StateEnum = StateEnum,
	Types = {},
}

local WorldModelUtil = require(script.WorldModels)
--local RayVisualizer = require(script.Parent.Parent.Visualizers.RayVisualizer)

local ReloadThreads = {}
local Connections = {}
local AnimationTracks = {}

-- Player pass, really messy
-- All to just make hats not be taken into account while casting a ray....

-- and all to just ensure that memory leaks wont occur.... ouch!

function WeaponService:KnitStart()
	for _, Type in pairs(script.Types:GetChildren()) do
		self.Types[Type.Name] = require(Type)
	end

	Players.PlayerAdded:Connect(function(Player: Player)
		WorldModelUtil:InitialiePlayerTable(Player)
		AnimationTracks[Player] = {}
		Connections[Player] = {}

		Connections[Player]["CharacterAdded"] = Player.CharacterAdded:Connect(function(Character: Model)
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			Connections[Player]["HumanoidDied"] = Humanoid.Died:Connect(function()
				for _, ToolTracks in pairs(AnimationTracks[Player]) do
					for _, Track: AnimationTrack in pairs(ToolTracks) do
						Track:Stop()
					end
					AnimationTracks[Player][ToolTracks] = nil
					local ReloadThread = ReloadThreads[ToolTracks]

					if ReloadThread then
						local SIGTERM = ReloadThread[2]
						SIGTERM:Fire("Cancelled")
						SIGTERM = nil
						ReloadThread = nil
					end
				end
			end)

			task.defer(function()
				local Torso = Character:WaitForChild("UpperTorso")

				-- Creating the holster attachment here, because Roblox
				-- does not support keeping Attachments anywhere outside a BasePart
				local Attachment = Create("Attachment", {
					Name = "HolsterAttachment",
					Orientation = Vector3.new(-45, 90, 0),
					Position = Vector3.new(0, 0, 0.6),
					Parent = Torso,
				})
				Attachment.Parent = Torso

				for _, Hat in pairs(Character:GetChildren()) do
					if Hat:IsA("Accessory") then
						for _, Part: BasePart in pairs(Hat:GetDescendants()) do
							if Part:IsA("BasePart") then
								Part.CanQuery = false
								Part.CanCollide = false
								Part.CanTouch = false

								Part = nil
							end
						end

						Hat = nil
					end
				end

				Character = nil
			end)
		end)
	end)

	-- Cleanup their messses
	Players.PlayerRemoving:Connect(function(Player: Player)
		local Connections = Connections[Player]

		for _, Connection: RBXScriptConnection in pairs(Connections) do
			Connection:Disconnect()
			AnimationTracks[Player] = nil
		end

		-- TODO: Implement reload thread cleanup
	end)
end

function WeaponService.Client:RegisterWeapon(Player: Player, Weapon: Tool)
	if Weapon == nil then
		warn("Bruh send me a valid weapon")
		return
	end

	if not AnimationTracks[Player][Weapon] then
		AnimationTracks[Player][Weapon] = {}
	end

	local HostAnimator: Animator = Player.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
	local Animations = Weapon:FindFirstChild("AnimationsWorld")

	if not Animations then
		Animations = Weapon:FindFirstChild("Animations")
	end

	if Animations then
		for _, Animation: Animation in pairs(Animations:GetChildren()) do
			local Track = HostAnimator:LoadAnimation(Animation)
			AnimationTracks[Player][Weapon][Animation.Name] = Track
			warn(string.format("Registered animation %s for %s", Animation.Name, Weapon.Name))
		end
	end

	Weapon:SetAttribute("State", StateEnum.Idle)
end

function WeaponService:Verify(Host: Player, Weapon: Tool, AmmoCheck: boolean)
	-- what
	if Weapon == nil or typeof(Weapon) ~= "Instance" then
		warn("Failed check: Invalid weapon table provided", Host)
		return false
	end

	local WeaponState = WeaponService:GetState(Weapon)

	if not WeaponState then
		warn("Failed check: There is no valid state for the weapon.")
		return
	end

	-- TODO: Faulty: fix later, maybe?
	-- for Index, _ in pairs(Weapon) do
	-- 	if not RequiredVars[Index] then
	-- 		warn("Failed check: Invalid weapon table provided", Host)
	-- 		return false
	-- 	end
	-- end

	-- one can't fire without a character
	local Character = Host.Character
	if not Character then
		warn("Failed check: Character Does Not Exist", Host)
		return false
	end

	-- one cant fire without even having the gun itself.
	if Character:FindFirstChild(Weapon.Name) == nil then
		warn("Failed check: Weapon Does Not Exist", Host)
		return false
	end

	-- one can't fire without a humanoid
	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		warn("Failed check: Humanoid Does Not Exist", Host)
		return false
	end

	-- check if humanodi is dead, if it is then fail check
	if Humanoid.Health <= 0 then
		warn("Failed check: Humanoid Dead", Host)
		return false
	end

	if AmmoCheck then
		-- check weapon ammo via GetAttribute
		local Ammo = Weapon:GetAttribute("Ammo")

		-- check if weapon has ammo, if it doesn't then fail check
		if Ammo <= 0 then
			warn("Failed check: No Ammo", Host)
			return false
		end
		Ammo = nil
	end

	Humanoid = nil
	Character = nil
	Weapon = nil
	Host = nil

	return true
end

function WeaponService.Client:WeaponEquipped(Player: Player, Weapon: Tool)
	if not WeaponService:Verify(Player, Weapon, false) then
		error("Failed check: Weapon Invalid: Equipped")
		return
	end

	local WorldModel = Weapon:GetAttribute("WorldModel")

	local existing_world_model = WorldModelUtil:GetPlayerWorldModel(Player, Weapon)
	local Character = Player.Character
	local Torso = Character.UpperTorso

	local HolsterMotor = Torso:FindFirstChild(WorldModel .. "HolsterMotor")

	if HolsterMotor then
		HolsterMotor:Destroy()
	end

	if existing_world_model then
		existing_world_model.Parent = Player.Character
		WorldModelUtil:AttachModel(Weapon:GetAttribute("AttachPoint"), Player.Character, existing_world_model)
	else
		WorldModelUtil:AddWorldModel(Player, Weapon, WorldModel)
	end
end

function WeaponService.Client:WeaponUnequipped(Player: Player, Weapon: Tool)
	local ReloadThread = ReloadThreads[Weapon]

	if ReloadThread then
		local Thread, Signal = ReloadThread[1], ReloadThread[2]

		-- Fire SIGTERM signal
		Signal:Fire("Cancelled")

		-- Cancel thread
		task.cancel(Thread)
	end

	local Character = Player.Character
	local HumanoidRoot = Character.HumanoidRootPart

	local WorldModel = WorldModelUtil:GetPlayerWorldModel(Player, Weapon)

	if WorldModel then
		--WorldModel.Parent = nil
		local Attachment = HumanoidRoot:FindFirstChild(WorldModel.Name .. "Attach")
		if Attachment then
			Attachment:Destroy()
		end

		WorldModel.Parent = Character.UpperTorso
		local HolsterAttachment = Character.UpperTorso.HolsterAttachment

		Create("Motor6D", {
			Name = WorldModel.Name .. "HolsterMotor",
			Part0 = Character.UpperTorso,
			Part1 = WorldModel.PrimaryPart,
			C0 = HolsterAttachment.CFrame,
			Parent = Character.UpperTorso,
		})
	end
end

function WeaponService:GetState(Weapon: Tool): string
	return Weapon:GetAttribute("State")
end

-- set state
function WeaponService:SetState(Weapon: Tool, State: any)
	local OldState = Weapon:GetAttribute("State")

	if OldState == State then
		return
	end

	Weapon:SetAttribute("State", State)
end

function WeaponService:GetAnimation(Player: Player, Weapon: Tool, Animation: string)
	local Track = AnimationTracks[Player][Weapon]
	return Track[Animation]
end

function WeaponService.Client:PlayAnimation(Player: Player, Weapon: Tool, Animation: string)
	if not WeaponService:Verify(Player, Weapon, false) then
		return
	end

	local Track = WeaponService:GetAnimation(Player, Weapon, Animation)

	if Track then
		Track:Play()
	else
		warn("Server could not find the following animation :V " .. Animation)
	end
end

function WeaponService.Client:PlaySound(Player: Player, Weapon: Tool, SoundName: string)
	if not WeaponService:Verify(Player, Weapon, false) then
		return
	end

	local Character = Player.Character

	local SoundsFolder = Weapon:FindFirstChild("Sounds")
	assert(SoundsFolder, "No sounds folder >:(")

	local Sound = SoundsFolder:FindFirstChild(SoundName)

	if Sound then
		local NewSound: Sound = Sound:Clone()
		NewSound.Parent = Character.PrimaryPart
		NewSound:Play()

		task.delay(NewSound.TimeLength, function()
			NewSound:Destroy()
		end)
	else
		warn("Server could not find the following sound :V " .. SoundName)
	end
end

function WeaponService.Client:StopAnimation(Player: Player, Weapon: Tool, Animation: string)
	if not WeaponService:Verify(Player, Weapon, false) then
		return
	end

	local Track = WeaponService:GetAnimation(Player, Weapon, Animation)

	if Track then
		Track:Stop()
	else
		warn("Server could not find the following animation :V " .. Animation)
	end
end

function WeaponService:GetHumanoid(Instance: BasePart): Humanoid | nil
	local Humanoid = Instance:FindFirstChildOfClass("Humanoid")
		or Instance.Parent:FindFirstChildOfClass("Humanoid")
		or Instance.Parent.Parent:FindFirstChildOfClass("Humanoid")
	return Humanoid
end

function WeaponService:ProcessDamage(
	Player: Player,
	Weapon: Tool,
	Result: RaycastResult,
	CanHeadShot: boolean,
	DamageFallOff: boolean
)
	local DamageValue: DoubleConstrainedValue = Weapon:FindFirstChild("Damage")
	local Damage

	if DamageValue then
		-- for more complex tools
		Damage = math.random(DamageValue.MinValue, DamageValue.MaxValue)
	else
		-- for simple tools
		Damage = Weapon:GetAttribute("Damage")
	end

	if CanHeadShot then
		-- You're screwed
		if Result.Instance.Name == "Head" then
			Damage *= 15
		end
	end

	if DamageFallOff then
		local Distance = Player:DistanceFromCharacter(Result.Position)

		Damage -= Damage * (Distance / 35)
	end

	local Humanoid = self:GetHumanoid(Result.Instance)

	if Humanoid then
		self.Client.OnPlayerHit:Fire(Player, Result.Instance, Damage)
		Humanoid:TakeDamage(Damage)
	end
end

function WeaponService.Client:FireWeapon(Player: Player, Weapon: Tool, FiresTo: Vector3): nil
	if not WeaponService:Verify(Player, Weapon, true) then
		warn("User failed check. Reason above ^")
		return
	end

	local State = WeaponService:GetState(Weapon)

	if State ~= StateEnum.Idle then
		warn("Please wait before firing again.")
		return
	end

	WeaponService:SetState(Weapon, StateEnum.Firing)

	local Type = Weapon:GetAttribute("FireType") or "Bullet"
	local Character = Player.Character

	local Params: RaycastParams = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Blacklist
	Params.FilterDescendantsInstances = { Character }

	local Origin = Character.Head.Position
	local Direction = (FiresTo - Origin).Unit

	local TypeCallback = self.Server.Types[Type]

	TypeCallback(Player, Weapon, Origin, Direction)

	Weapon:SetAttribute("Ammo", Weapon:GetAttribute("Ammo") - 1)
	WeaponService:SetState(Weapon, "Idle")

	task.delay(Config.FireDelay, function()
		WeaponService:SetState(Weapon, StateEnum.Idle)
	end)

	-- local Tool = Weapon.Tool
	-- local Damage = Tool:GetAttribute("Damage")

	-- local Character = Player.Character

	-- local Params: RaycastParams = RaycastParams.new()
	-- Params.FilterType = Enum.RaycastFilterType.Blacklist
	-- Params.FilterDescendantsInstances = { Character }

	-- local Origin = Character.Head.Position
	-- local Direction = (FiresTo - Origin).Unit

	-- local Result = workspace:Raycast(Origin, Direction * 300, Params)
	-- task.delay(Config.FireDelay, function()
	-- 	WeaponService:SetState(Weapon, StateEnum.Idle)
	-- end)

	-- if Result then
	-- 	--RayVisualizer(Origin, Result.Position)
	-- 	local Humanoid = WeaponService:GetHumanoid(Result.Instance)

	-- 	if Humanoid then
	-- 		self.OnPlayerHit:Fire(Player, Result.Instance, Damage)
	-- 		Humanoid:TakeDamage(Damage)
	-- 	end

	-- 	self.OnEffectRequest:Fire(Player, "Wall", Result.Instance, Result.Position, Result.Normal)
	-- 	self.OnEffectRequest:Fire(Player, "Sound", Result.Instance)

	-- 	Humanoid = nil
	-- else
	-- 	warn("Raycasting failed!", Player)
	-- end

	-- Tool:SetAttribute("Ammo", Tool:GetAttribute("Ammo") - 1)
end

function WeaponService.Client:Reload(Player: Player, Weapon: Tool)
	if not WeaponService:Verify(Player, Weapon, false) then
		warn("User failed check. Reason above ^")
		return
	end

	local State = WeaponService:GetState(Weapon)
	local ReloadAnim = WeaponService:GetAnimation(Player, Weapon, "Reload")
	if State ~= StateEnum.Idle then
		warn("Please wait before reloading")
		return
	end

	if ReloadThreads[Weapon] then
		warn("RELOAD: There is a existing reload thread for this tool. Aborting.")
		return
	end

	local Ammo = Weapon:GetAttribute("Ammo")
	local MaxAmmo = Weapon:GetAttribute("MaxAmmo")
	local ReloadTime = Weapon:GetAttribute("ReloadTime") or 5

	if Ammo == MaxAmmo then
		warn("You have full ammo.")
		return
	end

	local TermSignal = Signal.new()
	local ReturnType = true

	print("Reloading...")
	WeaponService:SetState(Weapon, StateEnum.Reloading)
	ReloadThreads[Weapon] = {
		task.spawn(function()
			ReloadAnim:Play()
			task.wait(ReloadTime)
			Weapon:SetAttribute("Ammo", MaxAmmo)
			task.wait(Config.ReloadDelays) -- Slight delay to make it feel better
			print("Reloaded")
			WeaponService:SetState(Weapon, StateEnum.Idle)
			TermSignal:Fire("Completed")
			return ReturnType
		end),
		TermSignal,
	}
	local Result = TermSignal:Wait()
	if Result == "Cancelled" then
		ReloadAnim:Stop()
	elseif Result == "Completed" then
		ReloadThreads[Weapon] = nil
	end
	task.wait(0.09)
	WeaponService:SetState(Weapon, StateEnum.Idle)
	--self.ReloadComplete:Fire(Player, Weapon, Result)
end

return WeaponService
