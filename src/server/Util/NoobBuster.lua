-- NoobBuster.lua - 2022/03/30
-- Purpose: Anti-cheat? I guess?

local NoobBuster = {}
local Codes = {
	[-17] = "Cannot donate to one-self.",
	[0] = "Reserved",
	[404] = "Profile not found. This might be an issue with Roblox.",
}

function NoobBuster:Kick(Player: Player, Code: number, ...)
	local CodeText = Codes[Code]
	if not CodeText then
		CodeText = "???"
	end

	Player:Kick("Noobbuster " .. tostring(Code) .. ": " .. CodeText)
end

return NoobBuster
