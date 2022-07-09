local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local Defaults = {}

for _, Value in pairs(StarterPlayer:GetChildren()) do
	if Value:IsA("StarterPlayerScripts") or Value:IsA("StarterCharacterScripts") then
		continue
	end

	print(Value.ClassName)
	table.insert(Defaults, Value)
end

Players.PlayerAdded:Connect(function(Player: Player)
	for _, Value in pairs(Defaults) do
		Value:Clone().Parent = Player
	end
end)
