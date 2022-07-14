local Players = game:GetService("Players")
local BanService = require(script.Parent.Parent.Parent.Services.BanService)
local TagService = require(script.Parent.Parent.Parent.Services.TagService)

return function(Context, Player: Player | string, Reason: string, Duration: number)
	local IsPerm = false
	if Duration == 0x99 then
		IsPerm = true
	end

	local UserId

	if type(Player) == "string" then
		UserId = Players:GetUserIdFromNameAsync(Player)

		if not UserId then
			return "Invalid user"
		end
	else
		UserId = Player.UserId
	end

	return BanService:BanUser(UserId, Reason, Duration, IsPerm)
end
