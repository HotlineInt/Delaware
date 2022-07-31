local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Player = Carbon.Player

local Movement = {
	LastSpeed = game.StarterPlayer.CharacterWalkSpeed,
	LastJumpPower = game.StarterPlayer.CharacterJumpPower,
}

function Movement:GetHumanoid()
	local Character = Player.Character or Player.CharacterAdded:Wait()
	return Character:WaitForChild("Humanoid")
end

function Movement:IsStandingStill()
	local Humanoid = self:GetHumanoid()

	if Humanoid.MoveDirection == Vector3.new() then
		return true
	end
	if Humanoid.WalkSpeed == 0 then
		return true
	end

	return false
end

function Movement:Enable()
	local Humanoid = self:GetHumanoid()
	local RootPart = Humanoid.Parent:WaitForChild("HumanoidRootPart")

	RootPart.Anchored = false
	Humanoid.JumpPower = self.LastJumpPower
	Humanoid.WalkSpeed = self.LastSpeed
end

function Movement:Disable()
	local Humanoid = self:GetHumanoid()
	local RootPart = Humanoid.Parent:WaitForChild("HumanoidRootPart")

	RootPart.Anchored = true

	self.LastSpeed = Humanoid.WalkSpeed
	self.LastJumpPower = Humanoid.JumpPower

	Humanoid.JumpPower = 0
	Humanoid.WalkSpeed = 0
end

return Movement
