local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Class = require(Carbon.Util.Class)
local ViewModel = require(Carbon.Tier0.ViewModel)

local HandsModel = script.Parent:WaitForChild("CHands")
local CHands, BaseModel = Class("CHands", ViewModel)

local LegalPoints = {
	"RightHand",
	"LeftHand",
}

function CHands:__init()
	BaseModel.__init(self, HandsModel)
end

-- Attaches a Model to the ViewModel
function CHands:AttachWeapon(WeaponModel: Model, AttachPoint: BasePart)
	self.AttachedModel = WeaponModel
	WeaponModel.Parent = self.Model
	local ModelConnector = Instance.new("Motor6D")
	ModelConnector.Name = "ModelConnector"
	ModelConnector.Parent = WeaponModel
	ModelConnector.Part0 = AttachPoint
	ModelConnector.Part1 = WeaponModel.PrimaryPart
end

function CHands:GetAttachPoint(Name: string)
	local PointIsLegal = table.find(LegalPoints, Name) ~= nil

	if PointIsLegal then
		local Point = self.Model:FindFirstChild(Name)
		return Point
	else
		warn("Invalid AttachPoint for hands:", Name)
		return nil
	end
end

function CHands:GetAttachedModel()
	return self.AttachedModel
end

function CHands:SetAttachedModel(WeaponModel: Model)
	self.AttachedModel = WeaponModel
end

-- Detaches the currently attached weapon.
function CHands:DetachWeapon()
	local Model = self:GetAttachedModel()

	if Model then
		Model:Destroy()
		self:SetAttachedModel(nil)
	end
end

return CHands
