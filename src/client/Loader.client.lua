local Players = game:GetService("Players")
script.Parent:RemoveDefaultLoadingScreen()
local Playerlist = require(script.Parent:WaitForChild("Playerlist"))

Playerlist:Load()
Playerlist:PlayerAdded(game.Players.LocalPlayer)

Players.PlayerAdded:Connect(function(player)
	Playerlist:PlayerAdded(player)
end)
