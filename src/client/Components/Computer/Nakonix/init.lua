local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)
local CUI = require(Carbon.UI.CUI)

local Nakonix = Class("Nakonix")
local Taskbar = require(script.Taskbar)
local Player = Carbon:GetPlayer()

function Nakonix:__init(Monitor: Part)
	local Surface = CUI:CreateElement("SurfaceGui", {
		--AlwaysOnTop = true,
		Adornee = Monitor,
		Name = "ScreenGui",
		ResetOnSpawn = false,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 300,
		[CUI.Children] = {
			CUI:CreateElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Wallpaper",
				Image = "rbxassetid://9250088040",
				BackgroundTransparency = 1,
				ZIndex = 0,
			}),
			CUI:CreateElement("TextButton", {
				Size = UDim2.new(0, 200, 0, 100),
				Name = "ExitComputer",
				TextScaled = true,
				Text = "Exit (TEMPORARY UNTIL START MENU IS DONE)",
				Active = true,
				[CUI.OnEvent("Activated")] = function()
					self:Exit()
				end,
			}),
			-- make a taskbar
			Taskbar({ Nakonix = Nakonix }),
		},
	})
	self.Surface = Surface

	Surface:Mount(Player.PlayerGui)
end

return Nakonix
