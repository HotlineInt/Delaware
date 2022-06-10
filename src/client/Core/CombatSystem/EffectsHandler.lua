local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local WeaponService = require(Carbon.Framework.Knit):GetService("WeaponsService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EffectsUtil = require(ReplicatedStorage:WaitForChild("EffectsUtil"))
local EffectsHandler = {}

local EffectsFolder = ReplicatedStorage:WaitForChild("Effects")

function EffectsHandler:Load()
	WeaponService.OnEffectRequest:Connect(
		function(Type: string, ResultInstance: Instance, Position: Vector3, Normal: Vector3)
			if Type == "Wall" then
				EffectsUtil:HitEffect(ResultInstance, Position, Normal)
			elseif Type == "Sound" then
				local MaterialFolder = EffectsFolder.Materials:FindFirstChild(
					tostring(ResultInstance.Material):gsub("Enum.Material.", "")
				)

				EffectsUtil:SoundEffect(ResultInstance.Position, MaterialFolder)
			end
		end
	)
end

return EffectsHandler
