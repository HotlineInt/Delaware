local ContextActionService = game:GetService("ContextActionService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Janitor = require(Carbon.Util.NakoJanitor)

local SprintService = require(Carbon.Framework.Knit):GetService("SprintService")

local Sprinting = {
	IsSprinting = false,
	Disabled = false,
	Janitor = Janitor.new(),
}

function Sprinting:Load()
	ContextActionService:BindAction("Sprinting", function(_, State: Enum.UserInputState, _)
		if State == Enum.UserInputState.Begin then
			self:ToggleSprint(true)
		elseif State == Enum.UserInputState.End then
			self:ToggleSprint(false)
		end
	end, false, Enum.KeyCode.LeftShift)
end

function Sprinting:CharacterAdded(Character: Model)
	self.IsSprinting = false
	self.Disabled = false
	self.Janitor:Cleanup()

	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

	self.Janitor:Add(Humanoid.Died:Connect(function()
		self:ToggleSprint(false)
		self.Disabled = true
	end))
end

function Sprinting:ToggleSprint(Toggle: boolean)
	if self.Disabled == true then
		return
	end

	self.IsSprinting = Toggle
	SprintService:ToggleSprint(Toggle)
end

return Sprinting
