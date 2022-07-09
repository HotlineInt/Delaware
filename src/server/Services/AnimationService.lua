local AnimationService = {
	Name = "AnimationService",
	Tracks = {},
	Client = {},
}

function AnimationService:KnitInit()
	task.spawn(function()
		while task.wait(5) do
			self:Tick()
		end
	end)
end

-- Loads an animation for a Character, if there's already a loaded track then it will return the
-- loaded track.
function AnimationService:LoadAnimation(Character: Model, Animation: Animation): AnimationTrack
	local Humanoid = Character:WaitForChild("Humanoid")
	local Animator: Animator = Humanoid:WaitForChild("Animator")
	self:_create_if_doesnt_exist(Character)

	local Track: AnimationTrack? = self.Tracks[Character][Animation.Name]

	if Track then
		return Track
	end

	task.defer(function()
		local Track: AnimationTrack = Animator:LoadAnimation(Animation)
		self.Tracks[Character][Animation.Name] = Track

		return Track
	end)
end

function AnimationService:_create_if_doesnt_exist(Character: Model)
	if not self.Tracks[Character] then
		self.Tracks[Character] = {}
	end
end

-- Returns a loaded AnimationTrack. Returns nil if there's none.
function AnimationService:GetAnimation(Character: Model, Animation: string): AnimationTrack?
	self:_create_if_doesnt_exist(Character)
	local Track = self.Tracks[Character][Animation]

	return Track
end

-- Internal update loop
function AnimationService:Tick()
	-- Check if said character is still present, if not remove em!
	for Character: Model, Tracks: { AnimationTrack } in pairs(self.Tracks) do
		if Character.Parent == nil then
			self.Tracks[Character] = nil
			Tracks = nil
		end
	end
end

return AnimationService
