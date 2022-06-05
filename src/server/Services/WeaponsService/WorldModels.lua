local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorldModelFolder = ReplicatedStorage:WaitForChild("WorldModels")

local WorldModels = {
	AvailableWorldModels = {},
}

function WorldModels:InitialiePlayerTable(Player: Player)
	self.AvailableWorldModels[Player] = {}
end

function WorldModels:GetWorldModel(ModelName)
	local WorldModel = WorldModelFolder:FindFirstChild(ModelName)
	return WorldModel
end

-- get player world model
function WorldModels:GetPlayerWorldModel(Player: Player, Tool: Tool)
	local WorldModel = self.AvailableWorldModels[Player][Tool]
	return WorldModel
end

function WorldModels:AddWorldModel(Player: Player, Tool: Tool, WorldModel: string)
	local Character = Player.Character
	local HumanoidRootPart = Character.HumanoidRootPart --:FindFirstChild("HumanoidRootPart")

	local AttachPoint = Tool:GetAttribute("AttachPoint") or "HumanoidRootPart"

	local Model = self:GetWorldModel(WorldModel)
	local ExistingModel = self.AvailableWorldModels[Player][Tool]

	if ExistingModel ~= nil then
		--error("There can only be one WorldModel per tool.")
		Model = ExistingModel
	elseif Model then
		Model = Model:Clone()
	else
		error("No WorldModel could be found")
	end

	self.AvailableWorldModels[Player][Tool] = Model

	Model.Parent = Character
	local AttachPart = Character:FindFirstChild(AttachPoint)
	if not AttachPart then
		error("Invalid attachpoint provided: " .. Tool.Name)
	end

	local Motor6D = Instance.new("Motor6D")
	Motor6D.Parent = HumanoidRootPart
	Motor6D.Name = "WorldModelAttach"

	Motor6D.Part0 = AttachPart
	Motor6D.Part1 = Model.PrimaryPart

	for _, Part in pairs(Model:GetChildren()) do
		if not Part:IsA("BasePart") then
			continue
		end
		PhysicsService:SetPartCollisionGroup(Part, "ViewModels")
	end

	return Model
end

function WorldModels:RemoveWorldModel(Player: Player, Tool: Tool)
	local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local Model = self.AvailableWorldModels[Player][Tool]

	if Model then
		local Motor = HumanoidRootPart:FindFirstChild("WorldModelAttach")

		if Motor then
			Motor:Destroy()
		end

		Model.Parent = nil
	end
end

return WorldModels
