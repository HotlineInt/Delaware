local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local Class = require(Carbon.Util.Class)

local WeaponHud = Class("WeaponHUD")
local AmmoFormat = "%s / %s"

function WeaponHud:__init(Mount: BasePart)
	self.Gui = CUI:CreateElement("SurfaceGui", {
		ResetOnSpawn = false,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 180,
		AlwaysOnTop = true,
		LightInfluence = 0,
		Brightness = 5,
		[CUI.Children] = {
			CUI:CreateElement("TextLabel", {
				Name = "AmmoCounter",
				TextScaled = true,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.Arcade,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(219, 170, 78),
				TextTransparency = 0.3,
				Text = string.format(AmmoFormat, "--", "--"),
			}),
		},
	})

	self.AmmoCounter = self.Gui:Get("AmmoCounter")
	self.Gui:Mount(Mount)
end

function WeaponHud:SetStats(Ammo: number, MaxAmmo: number)
	Ammo = tostring(Ammo)
	MaxAmmo = tostring(MaxAmmo)
	self.AmmoCounter:SetProperty("Text", string.format(AmmoFormat, Ammo, MaxAmmo))
end

return WeaponHud
