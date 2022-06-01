local Players = game:GetService("Players")
local WeaponService = {
	Client = {},
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

local Effects = require(script.Effects)
local RayVisualizer = require(script.Parent.Parent.Visualizers.RayVisualizer)

-- Hat pass, really messy
-- All to just make hats not be taken into account while casting a ray....
function WeaponService:KnitStart()
	Players.PlayerAdded:Connect(function(Player: Player)
		Player.CharacterAdded:Connect(function(Character: Model)
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
end

function WeaponService:Verify(Host: Player, Weapon: Weapon, AmmoCheck: boolean)
	if Weapon == nil or type(Weapon) ~= "table" then
		warn("Failed check: Invalid weapon table provided", Host)
		return false
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
	end

	local Tool = Weapon.Tool
	local Damage = Tool:GetAttribute("Damage")

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
	--Params:Destroy()
	Damage = nil
	Character = nil
end

function WeaponService:Reload(Player: Player, Weapon: Weapon) end

return WeaponService
