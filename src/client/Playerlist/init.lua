local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local List = require(script.List)
local PlayerComponent = require(script.Player)
local CUI = require(Packages.CUI)

local Playerlist = {
	Holder = nil,
	List = nil,
}

function Playerlist:Load()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	self.Holder = CUI:CreateElement("ScreenGui", {
		--IgnoreGuiInset = true,
		ResetOnSpawn = false,
	})

	self.List = self.Holder:AddElement(List, {})
	self.Holder:Mount(Players.LocalPlayer.PlayerGui)
end

function Playerlist:PlayerAdded(Player: Player)
	self.List:AddElement(PlayerComponent({
		Player = Player,
		Badges = {
			"rbxassetid://9333042583",
		},
	}))
end

return Playerlist
