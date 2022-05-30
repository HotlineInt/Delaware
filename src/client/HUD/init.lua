local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local CUI = require(Packages.CUI)
local SegmentDisplay = require(script.SegmentDisplay)

local HUD: HUD = {}

function HUD:Load()
	self.Connections = {}
	local SegmentDisplay = SegmentDisplay.new()
	local PaddingValues = UDim.new(0, 5)

	local HUDMount = CUI:CreateElement("ScreenGui", {
		ResetOnSpawn = true,
		--IgnoreGuiInset = true,
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingBottom = PaddingValues,
				PaddingLeft = PaddingValues,
			}),
			SegmentDisplay:Render(),
			CUI:CreateElement("Frame", {
				Name = "Health",
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(0, 100, 0, 100),
			}),
		},
	})

	Player.CharacterAdded:Connect(function(Character)
		if self.Connections["HealthChanged"] then
			self.Connections.HealthChanged:Disconnect()
		end

		local Humanoid = Character:WaitForChild("Humanoid")

		self.Connections["HealthChanged"] = Humanoid.HealthChanged:Connect(function(...)
			self:UpdateHealth(...)
		end)
	end)

	self.HUDDisplay = HUDMount
	self.SegmentDisplay = SegmentDisplay
	HUDMount:Mount(game.Players.LocalPlayer.PlayerGui)
end

function HUD:UpdateHealth(OldHealth: number, NewHealth: number)
	print("Update", OldHealth, NewHealth)
end

export type HUD = {
	HUDDisplay: table,
	Load: nil,
	SegmentDisplay: SegmentDisplay,
}

return HUD
