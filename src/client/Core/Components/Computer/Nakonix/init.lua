local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)
local CUI = require(Carbon.UI.CUI)

local Nakonix = Class("Nakonix")
local Taskbar = require(script.Taskbar)
local StartMenu = require(script.StartMenu)
local StartButton = require(script.StartMenuOption)

local Messagebox = require(script.MessageBox)
local Notepad = require(script.Notepad)

local Player = Carbon:GetPlayer()

function Nakonix:__init(Monitor: Part, Computer)
	local Surface
	local StartMenu = StartMenu({
		StartButton({
			Label = "About Nakonix",
			Callback = function()
				Messagebox({
					Text = "Nakonix ver 0.0.1",
				}):Mount(Surface)
			end,
		}),
		StartButton({
			Label = "Nakopad",
			Callback = function()
				Notepad({
					Content = "Welcome to nakopad - Nakonix's built-in text editor. \n This text editor is currently very basic in functionality",
				}):Mount(Surface)
			end,
		}),
		StartButton({
			Label = "Exit",
			Callback = function()
				Computer:Exit()
			end,
		}),
	})
	local Gui = CUI:CreateElement("SurfaceGui", {
		--AlwaysOnTop = true,
		Adornee = Monitor,
		Name = "ScreenGui",
		ResetOnSpawn = false,
		ClipsDescendants = true,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 300,
		[CUI.Children] = {},
	})

	-- Main Container
	Gui:AddElement(CUI:CreateElement("Frame", {
		Name = "Container",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[CUI.Children] = {
			CUI:CreateElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Wallpaper",
				Image = "rbxassetid://9250088040",
				BackgroundTransparency = 1,
				ZIndex = 0,
			}),
			-- CUI:CreateElement("TextButton", {
			-- 	Size = UDim2.new(0, 200, 0, 100),
			-- 	Name = "ExitComputer",
			-- 	TextScaled = true,
			-- 	Text = "Exit (TEMPORARY UNTIL START MENU IS DONE)",
			-- 	Active = true,
			-- 	[CUI.OnEvent("Activated")] = function()
			-- 		self:Exit()
			-- 	end,
			-- }),
			-- start menu
			StartMenu,

			-- make a taskbar
			Taskbar({ Nakonix = Nakonix, StartMenu = StartMenu }),
		},
	}))

	Surface = Gui:Get("Container")

	self.Gui = Gui
	self.Surface = Surface

	Gui:Mount(Player.PlayerGui)
end

return Nakonix
