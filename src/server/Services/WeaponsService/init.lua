local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)
local Signal = require(Carbon.Util.Signal)

local Players = game:GetService("Players")
local WeaponService = {
	Client = {
		ReloadComplete = Knit:CreateSignal("ReloadComplete"),
	},
}
export type Weapon = {
	Name: string,
	FireMode: string,
	Offset: Vector3,
	Ammo: number,
	MaxAmmo: number,
	ViewModel: Model,
	Tool: Tool,
}
local StateEnum = {
	Idle = "Idle",
	Firing = "Firing",
	Reloading = "Reloading",
}

local Effects = require(script.Effects)
--local RayVisualizer = require(script.Parent.Parent.Visualizers.RayVisualizer)

local ReloadThreads = {}
local Connections = {}
local AnimationTracks = {}

-- Player pass, really messy
-- All to just make hats not be taken into account while casting a ray....

-- and all to just ensure that memory leaks wont occur.... ouch!

function WeaponService:KnitStart()
	Players.PlayerAdded:Connect(function(Player: Player)
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

function WeaponService.Client:RegisterWeapon(Player: Player, Weapon: Weapon)
	if Weapon == nil or type(Weapon) ~= "table" then
		warn("Invalid weapon table provided")
		return false
	end
	local Tool = Weapon.Tool

	if not AnimationTracks[Player][Tool] then
		AnimationTracks[Player][Tool] = {}
	end

	local HostAnimator: Animator = Player.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
	local Animations = Tool:FindFirstChild("Animations")

	for _, Animation: Animation in pairs(Animations:GetChildren()) do
		local Track = HostAnimator:LoadAnimation(Animation)
		AnimationTracks[Player][Tool][Animation.Name] = Track
		warn(string.format("Registered animation %s for %s", Animation.Name, Tool.Name))
	end

	Tool:SetAttribute("State", StateEnum.Idle)
end

function WeaponService.Client:WeaponUnequipped(Player: Player, Weapon: Weapon)
	if Weapon == nil or type(Weapon) ~= "table" then
		warn("Invalid weapon table provided")
		return false
	end
	local Tool = Weapon.Tool
	local ReloadThread = ReloadThreads[Tool]

	if ReloadThread then
		local Thread, Signal = ReloadThread[1], ReloadThread[2]

		-- Fire SIGTERM signal
		Signal:Fire("Cancelled")

		-- Cancel thread
		task.cancel(Thread)
	end
end

function WeaponService:GetState(Weapon: Weapon): string
	local Tool = Weapon.Tool
	return Tool:GetAttribute("State")
end

-- set state
function WeaponService:SetState(Weapon: Weapon, State: any)
	local Tool = Weapon.Tool
	local OldState = Tool:GetAttribute("State")

	if OldState == State then
		return
	end

	Tool:SetAttribute("State", State)
end

function WeaponService:GetAnimation(Player: Player, Weapon: Weapon, Animation: string)
	local Track = AnimationTracks[Player][Weapon.Tool]
	return Track[Animation]
end

function WeaponService.Client:PlayAnimation(Player: Player, Weapon: Weapon, Animation: string)
	local Track = WeaponService:GetAnimation(Player, Weapon, Animation)

	if Track then
		Track:Play()
	else
		warn("Server could not find the following animation :V " .. Animation)
	end
end

function WeaponService:Verify(Host: Player, Weapon: Weapon, AmmoCheck: boolean)
	if Weapon == nil or type(Weapon) ~= "table" then
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
		local Ammo = Weapon.Tool:GetAttribute("Ammo")

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

function WeaponService:GetHumanoid(Instance: BasePart): Humanoid | nil
	local Humanoid = Instance:FindFirstChildOfClass("Humanoid")
		or Instance.Parent:FindFirstChildOfClass("Humanoid")
		or Instance.Parent.Parent:FindFirstChildOfClass("Humanoid")
	return Humanoid
end

function WeaponService.Client:FireWeapon(Player: Player, Weapon: Weapon, FiresTo: Vector3): nil
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

	local Tool = Weapon.Tool
	local Damage = Tool:GetAttribute("Damage")

	local Character = Player.Character

	local Params: RaycastParams = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Blacklist
	Params.FilterDescendantsInstances = { Character }

	local Origin = Character.Head.Position
	local Direction = (FiresTo - Origin).Unit

	local Result = workspace:Raycast(Origin, Direction * 300, Params)
	task.delay(0.02, function()
		WeaponService:SetState(Weapon, StateEnum.Idle)
	end)

	if Result then
		--RayVisualizer(Origin, Result.Position)
		local Humanoid = WeaponService:GetHumanoid(Result.Instance)

		if Humanoid then
			Humanoid:TakeDamage(Damage)
		end

		local SoundAttachment = Effects:HitEffect(Result.Instance, Result.Position, Result.Normal)
		Effects:SoundEffect(SoundAttachment, Effects:GetMaterialFolder(Result.Instance))

		Tool:SetAttribute("Ammo", Tool:GetAttribute("Ammo") - 1)

		SoundAttachment = nil
		Humanoid = nil
	else
		warn("Raycasting failed!", Player)
	end

	-- Cleanup fun
	Tool = nil
	Result = nil
	Origin = nil
	Direction = nil
	Params = nil
	Damage = nil
	Character = nil
end

function WeaponService.Client:Reload(Player: Player, Weapon: Weapon)
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

	if ReloadThreads[Weapon.Tool] then
		warn("RELOAD: There is a existing reload thread for this tool. Aborting.")
		return
	end

	local Tool = Weapon.Tool
	local Ammo = Tool:GetAttribute("Ammo")
	local MaxAmmo = Tool:GetAttribute("MaxAmmo")
	local ReloadTime = Tool:GetAttribute("ReloadTime") or 5

	if Ammo == MaxAmmo then
		warn("You have full ammo.")
		return
	end

	local TermSignal = Signal.new()
	local ReturnType = true

	print("Reloading...")
	WeaponService:SetState(Weapon, StateEnum.Reloading)
	ReloadThreads[Tool] = {
		task.spawn(function()
			ReloadAnim:Play()
			task.wait(ReloadTime)
			Tool:SetAttribute("Ammo", MaxAmmo)
			task.wait(0.09) -- Slight delay to make it feel better
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
		ReloadThreads[Tool] = nil
	end
	task.wait(0.09)
	WeaponService:SetState(Weapon, StateEnum.Idle)
	--self.ReloadComplete:Fire(Player, Weapon, Result)
end

return WeaponService
