local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Enum = require(Carbon.Util.Enum)

local Players = game:GetService("Players")
local ValidTags = {
	Supporter = "tag_supporter",
	Debugger = "tag_debugger",
	Moderator = "tag_mod",
}
local TagService = {
	Name = "TagService",
	Tags = ValidTags,
	PlayerTags = {},
	Client = {
		Tags = ValidTags,
	},
}

function TagService:KnitStart()
	Players.PlayerAdded:Connect(function(Player)
		self.PlayerTags[Player] = {}
		self:ApplyTag(Player, self.Tags.Debugger)
		self:ApplyTag(Player, self.Tags.Supporter)
		self:ApplyTag(Player, self.Tags.Moderator)
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

function TagService:ApplyTag(Player: Player, Tag: string)
	local UserTags = self.PlayerTags[Player]
	table.insert(UserTags, Tag)
end

function TagService:RemoveTag(Player: Player, Tag: string)
	local UserTags = self.PlayerTags[Player]
	local Index = table.find(UserTags, Tag)

	if Index then
		table.remove(UserTags, Index)
	end
end

return TagService
