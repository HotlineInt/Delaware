local NoobBuster = {
	Messages = {
		NO_ACCESS_TO_PlACE = "We have no idea how you managed to join but you are not allowed here. Yet.",
		BANNED = "You have been banned from this place. \n Reason: %s \n Time Remaining: %s \n\n If you think this is a mistake, please open a support ticket.",
	},
}

function NoobBuster:KickWithMessage(Player: Player, Message: string)
	local NoobBusterMessage = string.format("[NOOBBUSTR]\n %s", Message)
	Player:Kick(NoobBusterMessage)
end

return NoobBuster
