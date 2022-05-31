local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FootstepModule = require(ReplicatedStorage:WaitForChild("Vendor"):WaitForChild("FootstepsModule"))

local Footsteps = {
	StateChangedConnection = nil,
	Delays = {
		Running = 0.2,
		Walking = 0.4,
	},
	Volume = 0.1,
	Delay = 0.4,
}

-- function Footsteps:Load()
-- 	for _, SoundMap in pairs(FootstepModule.SoundIds) do
-- 		ContentProvider:PreloadAsync(SoundMap, function(sound)
-- 			print("Preloaded: " .. sound)
-- 		end)
-- 	end
-- end

function Footsteps:CreateSound(Character: Model)
	local Sound = Instance.new("Sound")
	Sound.Parent = Character.HumanoidRootPart
	Sound.Volume = self.Volume

	return Sound
end

function Footsteps:SetDelay(Delay: number): nil
	self.Delay = Delay
end

function Footsteps:OnCharacterAdded(Character: Model)
	local Empty3 = Vector3.new()
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local WalkSound: Sound = HumanoidRootPart:WaitForChild("Running")
	local JumpingSound = HumanoidRootPart:WaitForChild("Jumping")

	JumpingSound.Volume = 0
	WalkSound.Volume = 0

	local LastSound

	while true do
		-- cleanup old character loop
		if Character.Parent == nil then
			break
		end

		local FloorMaterial = Humanoid.FloorMaterial
		local MaterialTable = FootstepModule:GetTableFromMaterial(FloorMaterial)

		if MaterialTable and Humanoid.MoveDirection ~= Empty3 then
			task.spawn(function()
				local SoundId = FootstepModule:GetRandomSound(MaterialTable)
				if SoundId == LastSound then
					-- regenerate
					repeat
						SoundId = FootstepModule:GetRandomSound(MaterialTable)
					until SoundId ~= LastSound
				end

				local Sound = self:CreateSound(Character)

				Sound.SoundId = SoundId
				LastSound = SoundId
				Sound:Play()
				Sound.Ended:Wait()
				Sound:Destroy()
			end)

			task.wait(self.Delay)
		end

		task.wait(0)
	end
end

return Footsteps
