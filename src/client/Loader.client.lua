script.Parent:RemoveDefaultLoadingScreen()
--local Playerlist = require(script.Parent:WaitForChild("Playerlist"))
local Console = require(script.Parent:WaitForChild("Console"))
local Settings = require(script.Parent:WaitForChild("Settings").SettingsWidget)

local TEST = true
local HUD = require(script.Parent.HUD)

Console:Load()
--Playerlist:Load()

Settings:Load()

if TEST then
	HUD:Load()
end
