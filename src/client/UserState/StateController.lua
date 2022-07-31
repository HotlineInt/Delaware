local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))

local State = require(script.Parent)
local UserEnum = require(script.Parent.StateEnum)
local Janitor = require(Carbon.Util.NakoJanitor)
local StateController = { Janitor = nil }

function StateController:Load()
	self.Janitor = Janitor.new()
end

function StateController:OnCharacterAdded(Character: Model)
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

	print(self, self.Janitor)
	self.Janitor:Add(Humanoid.Died:Connect(function()
		State:Set(UserEnum.IS_DEAD)
	end))

	State:Set(UserEnum.NORMAL)
end

return StateController
