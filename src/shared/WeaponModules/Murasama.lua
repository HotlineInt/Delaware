local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)

local CBaseWeapon = require(script.Parent.CBaseWeapon)

local Murasama, Base = Class("Murasama", CBaseWeapon)

function Murasama:__init(Tool: Tool)
	Base.__init(self, Tool)
	self.UsesAmmo = false
end

function Murasama:Fire()
	local RandomFireAnim = math.random(1, 2)
	local FireAnimName = "Fire" .. tostring(RandomFireAnim)

	self:PlayAnimation(FireAnimName)
end

return Murasama
