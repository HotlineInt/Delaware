return {
	Name = "set_tool_attrib",
	Aliases = { "sta" },
	Description = "DEBUG, sets tool attribute values, DEBUG",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "attrib",
			Description = "Attribute to modify",
		},
		{
			Type = "any",
			Name = "value",
			Description = "weapon attrib value",
		},
	},
}
