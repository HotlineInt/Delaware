local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Janitor = require(Carbon.Util.NakoJanitor)

local Players = game:GetService("Players")
local SprintService = {
	Name = "SprintService",
	Client = {},
	Janitors = {},
	DefaultSpeeds = {},
}
local AnimationService = require(script.Parent.AnimationService)
local SprintAnimation = game:GetService("ReplicatedStorage"):WaitForChild("Sprint")
local RUN_SPEED = 25

function SprintService:KnitInit()
	Players.PlayerAdded:Connect(function(Player: Player)
		local PlayerJanitor = Janitor.new()

		PlayerJanitor:Add(Player.CharacterAdded:Connect(function(Character: Model)
			AnimationService:LoadAnimation(Character, SprintAnimation)
		end))
	end)

	Players.PlayerRemoving:Connect(function(Player: Player)
		local PlayerJanitor = self.Janitors[Player]

		if PlayerJanitor then
			PlayerJanitor:Cleanup()
			self.DefaultSpeeds[Player] = nil
			self.Janitors[Player] = nil
		end
	end)
end

function SprintService.Client:ToggleSprint(Player: Player, Toggle: boolean)
	local Character = Player.Character
	local Humanoid = Character:WaitForChild("Humanoid")

	if Humanoid.WalkSpeed ~= RUN_SPEED then
		self.Server.DefaultSpeeds[Player] = Humanoid.WalkSpeed
	end
	local SprintAnimation: AnimationTrack = AnimationService:GetAnimation(Character, SprintAnimation.Name)

	if Toggle then
		Humanoid.WalkSpeed = 25
		SprintAnimation:Play()
	else
		Humanoid.WalkSpeed = self.Server.DefaultSpeeds[Player]
		SprintAnimation:Stop()
	end
end

return SprintService
