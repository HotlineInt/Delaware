local RunService = game:GetService("RunService")
return {
	Name = "version",
	Description = "Shows the current place version",
	Execute = function(Runner: Player, Arguments: table)
		local IsDev = RunService:IsStudio() and "-dev" or "-release"

		return print(string.format("Game version %d%s", game.PlaceVersion, IsDev))
	end,
}
