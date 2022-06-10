local NakoProfile = require(script.Parent.Parent.Data.NakoProfile)
local EconomyService = { Name = "EconomyService", Profiles = {}, Client = {}, Cooldowns = {} }

local AmountCooldowns = {
	[100000] = 60,
	[250000] = 300,
}

function EconomyService:KnitInit()
	self.PlayerStore = NakoProfile:GetStore("PlayerData")
end

function EconomyService:GetUserProfile(Player: Player)
	return self.PlayerStore:GetProfile(Player.UserId)
end

function EconomyService:SetStat(Player: Player, Name: string, Value: any)
	local Profile = self:GetUserProfile(Player)

	if Profile then
		Profile.Data[Name] = Value
	end
end

function EconomyService:PlayerHasEnoughCash(PlayerProfile, Amount: number)
	return PlayerProfile.Data.Cash >= Amount
end

function EconomyService.Client:TransferToBank(Player: Player, Amount: number)
	local Profile = EconomyService:GetUserProfile(Player)
	print(Profile)

	if Profile then
		if not EconomyService:PlayerHasEnoughCash(Profile, Amount) then
			warn("Cannot transfer to bank because you dont have enough")
			return
		end
		Profile.Data.Bank += Amount
		Profile.Data.Cash -= Amount
		print("Trasnferred to bank successfully:", Profile.Data.Bank)
	else
		warn("No profile", Player)
		Player:Kick("404")
	end
end

function EconomyService:IsInCooldown(Player: Player)
	return self.Cooldowns[Player] ~= nil
end

function EconomyService.Client:Donate(Player: Player, DonatedPlayer: Player, Amount: number)
	if Player == DonatedPlayer then
		Player:Kick("17")
		return "Halt execution"
	end

	if not EconomyService:IsInCooldown(Player) or not EconomyService:IsInCooldown(DonatedPlayer) then
		local AmountCooldowns = AmountCooldowns[Amount]

		local Profile1 = self.Server:GetUserProfile(Player)
		local Profile2 = self.Server:GetUserProfile(DonatedPlayer)

		if Profile1 and Profile2 then
			print(Profile1, Profile2)
			local HasEnough = EconomyService:PlayerHasEnoughCash(Profile1, Amount)

			if not HasEnough then
				warn("Not enough cash to donate!")
				return
			end

			Profile1.Data.Cash -= Amount
			Profile2.Data.Cash += Amount
			print("Donated successfully:", Profile1.Data.Cash, Profile2.Data.Cash)

			if AmountCooldowns then
				self.Cooldowns[Player] = AmountCooldowns
			end
		else
			warn("One of the players is invalid.\n Player1:", Profile1, "\n Player2:", Profile2)
		end
	end
end

return EconomyService
