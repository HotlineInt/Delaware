local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local DamageIndicator = {}
local Colors = {
	Normal = Color3.new(1, 1, 1),
	Damage = Color3.fromRGB(214, 139, 139),
	FullyDead = Color3.fromRGB(151, 67, 67),
}

function DamageIndicator:Load()
	local ColorCorrection = Instance.new("ColorCorrectionEffect")
	ColorCorrection.Parent = Lighting
	ColorCorrection.Name = "Damage"

	local Blur = Instance.new("BlurEffect")
	Blur.Name = "DamageBlur"
	Blur.Size = 0
	Blur.Parent = Lighting

	self.Blur = Blur
	self.Corrector = ColorCorrection

	local Tweens = {
		Normalize = TweenService:Create(ColorCorrection, TweenInfo.new(0.5), { TintColor = Colors.Normal }),
		Damage = TweenService:Create(
			ColorCorrection,
			TweenInfo.new(0.5),
			{ TintColor = Colors.FullyDead, Brightness = -0.3 }
		),
		DeadBlur = TweenService:Create(Blur, TweenInfo.new(0.2), { Size = 16 }),
	}

	self.Tweens = Tweens
end

function DamageIndicator:OnDamage()
	self.Tweens.Normalize:Cancel()
	self.Corrector.TintColor = Colors.Damage
	self.Tweens.Normalize:Play()
end

function DamageIndicator:UserDead()
	self.Tweens.Normalize:Cancel()
	self.Tweens.DeadBlur:Cancel()
	self.Tweens.DeadBlur:Play()
	self.Tweens.Damage:Play()
end

function DamageIndicator:Reset()
	self.Tweens.Normalize:Cancel()
	self.Tweens.DeadBlur:Cancel()
	self.Tweens.Damage:Cancel()

	self.Corrector.TintColor = Colors.Normal
	self.Corrector.Brightness = 0
	self.Blur.Size = 0
end

return DamageIndicator
