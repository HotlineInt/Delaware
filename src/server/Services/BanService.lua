-- implements checks for bans, ban kicks and etc
local Players = game:GetService("Players")
local NakoProfile = require(script.Parent.Parent.Data.NakoProfile)
local PlayerData = NakoProfile:GetStore("PlayerData")

local BanService = {
	Client = {},
	Strings = {
		USER_BANNED_TEMP = '\n \n Your access has been suspended for the following reason: \n "%s" \n \n Time remaining: %s \n \n Please open a ticket in our community server if you believe this is an error \n \n',
		USER_BANNED_PERM = '\n \n Your access has been suspended permanently for the following reason: \n "%s" \n \n This suspension is not appealable \n \n',
	},
}

function BanService:KnitInit()
	Players.PlayerAdded:Connect(function(Player: Player)
		local Data = PlayerData:GetProfile(Player.UserId)
		if Data then
			Data = Data.Data
		end

		local BanData = Data.BanData

		if BanData.Banned then
			local Reason = BanData.Reason
			local Time = BanData.Time
			local IsPerm = BanData.Perm

			self:KickUser(Player, Reason, Time, IsPerm)
		end
	end)
end

function BanService:_ConvertToHMS(Time: number)
	local function Format(Int)
		return string.format("%02i", Int)
	end

	local Seconds = Time

	local Minutes = (Seconds - Seconds % 60) / 60
	Seconds = Seconds - Minutes * 60
	local Hours = (Minutes - Minutes % 60) / 60
	Minutes = Minutes - Hours * 60
	return Format(Hours) .. ":" .. Format(Minutes) .. ":" .. Format(Seconds)
end

function BanService:KickUser(Player: Player, Reason: string, TimeRemaining: number, IS_PERM: boolean)
	local HMSTime = self:_ConvertToHMS(TimeRemaining)
	local Message

	if IS_PERM then
		Message = string.format(self.Strings.USER_BANNED_PERM, Reason)
	else
		Message = string.format(self.Strings.USER_BANNED_TEMP, Reason, HMSTime)
	end

	Player:Kick(Message)
end

function BanService:GetPlayerByUserId(UserId: number)
	for _, Player in pairs(Players:GetPlayers()) do
		if Player.UserId == UserId then
			return Player
		end
	end
end

function BanService:BanUser(UserId: number, Reason: string, Time: number, IS_PERM: boolean)
	local Data = PlayerData:GetProfile(UserId)
	local UserData = Data.Data

	print(UserData)
	if UserData.Tags["tag_developer"] or UserData.Tags["tag_admin"] or UserData.Tags["tag_mod"] then
		return "This user is unbannable due to their permission level"
	end

	local BanData = Data.BanData
	BanData.Banned = true
	BanData.Reason = Reason
	BanData.Time = Time
	BanData.Perm = IS_PERM

	local Player = self:GetPlayerByUserId(UserId)

	if Player then
		self:KickUser(Player, Reason, Time, IS_PERM)
	end

	return "Banned user successfully"
end

return BanService
