return {
	Name = "ban",
	Aliases = {},
	Description = "Bans a given player.",
	Group = "Admin",
	Args = {
		{
			Type = "player | string",
			Name = "player_to_ban",
			Description = "The player to ban",
		},
		{
			Type = "string",
			Name = "reason",
			Default = "No reason specified",
			Description = "Ban reason",
		},
		{
			Type = "number",
			Name = "Duration",
			Default = 0x99,
			Description = "Duration",
		},
	},
}
