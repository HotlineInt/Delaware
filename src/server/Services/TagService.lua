local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Players = game:GetService("Players")
local ValidTags = {
	Developer = "tag_developer",
	Supporter = "tag_supporter",
	Debugger = "tag_debugger",
	Moderator = "tag_mod",
}
local NakoProfile = require(script.Parent.Parent.Data.NakoProfile)
local PlayerData = NakoProfile:GetStore("PlayerData")

local TagService = {
	Name = "TagService",
	Tags = ValidTags,
	PlayerTags = {},
	Client = {
		Tags = ValidTags,
	},
}

local InStudio = Carbon:IsStudio()

function TagService:KnitInit()
	Players.PlayerAdded:Connect(function(Player)
		self.PlayerTags[Player] = {}
		if InStudio == false then
			local UserProfile = PlayerData:GetProfile(Player.UserId)

			for _, Tag in pairs(UserProfile.Data.Tags) do
				self:ApplyTag(Player, Tag)
			end
		else
			for _, Tag in pairs(ValidTags) do
				self:ApplyTag(Player, Tag)
			end
		end
	end)
end

function TagService:PlayerHasTag(Player: Player, Tag: string)
	local UserTags = self.PlayerTags[Player]
	return table.find(UserTags, Tag) ~= nil
end

function TagService:GetTags(Player: Player)
	return self.PlayerTags[Player]
end

function TagService.Client:GetTags(Player: Player)
	return TagService:GetTags(Player)
end

function TagService.Client:HasTag(Player: Player, Tag: string)
	return TagService:PlayerHasTag(Player, Tag)
end

function TagService:SyncData(Player: Player)
	if InStudio then
		return
	end -- Don't sync data in studio.

	local UserTags = self.PlayerTags[Player]
	local Profile = PlayerData:GetProfile(Player.UserId)

	Profile.Data.Tags = UserTags
end

function TagService:ApplyTag(Player: Player, Tag: string)
	local UserTags = self.PlayerTags[Player]
	table.insert(UserTags, Tag)
	self:SyncData(Player)
end

function TagService:RemoveTag(Player: Player, Tag: string)
	local UserTags = self.PlayerTags[Player]
	local Index = table.find(UserTags, Tag)

	if Index then
		table.remove(UserTags, Index)
		self:SyncData(Player)
	end
end

return TagService
