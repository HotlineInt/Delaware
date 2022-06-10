local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Player = Carbon:GetPlayer()
local Knit = require(Carbon.Framework.Knit)

local WeaponsService = Knit:GetService("WeaponsService")
local HitMarker = require(script:WaitForChild("HitMarker"))
local DamageNum = require(script:WaitForChild("DamageNum"))

local Settings = require(script.Parent.Parent.Settings.SettingsManager)
Settings:AddSetting("Hit Indicator", true)
Settings:AddSetting("Damage Numbers", true)

local HitIndicator = {
	HitMarker = nil,
	DamageNum = nil,
	HitDelayThread = nil,
}

function HitIndicator:Load()
	-- TODO: add damage numbers

	self.HitMarker = HitMarker()
	self.HitMarker:Mount(Player.PlayerGui)

	WeaponsService.OnPlayerHit:Connect(function(WhoWeHit: Model, Damage: number)
		-- cancel thread if it exists
		local HitMarkerOn = Settings:GetSetting("Hit Indicator").Value
		local DamageNumberOn = Settings:GetSetting("Damage Numbers").Value

		if HitMarkerOn then
			if self.HitDelayThread then
				task.cancel(self.HitDelayThread)
			end

			self.HitMarker:SetProperty("Enabled", true)

			self.HitDelayThread = task.delay(0.2, function()
				self.HitMarker:SetProperty("Enabled", false)
			end)
		end

		if DamageNumberOn then
			local DamageComponent = DamageNum({ Damage = Damage })

			DamageComponent:Mount(WhoWeHit)
		end
	end)
end

return HitIndicator
