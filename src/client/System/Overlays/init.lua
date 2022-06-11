local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Player = Carbon:GetPlayer()

local Overlays = {
	Overlays = {},
}

function Overlays:Load()
	-- make a panel
	local Panel = CUI:CreateElement("ScreenGui", {
		Name = "Overlays",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	})

	for _, Overlay in pairs(script:GetChildren()) do
		if Overlay:IsA("ModuleScript") then
			local OverlayComponent = require(Overlay)()
			Panel:Add(OverlayComponent)
			self.Overlays[Overlay.Name] = OverlayComponent
		end
	end

	-- mount panel to playergui
	Panel:Mount(Player.PlayerGui)
end

function Overlays:GetOverlay(Name)
	return Overlays.Overlays[Name]
end

return Overlays
