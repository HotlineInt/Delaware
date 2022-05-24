local SettingsManager = require(script.Parent.Parent.Parent.Settings.SettingsManager)

return {
	Name = "create_test_value",
	Description = "Shows the current place version",
	Execute = function(Runner: Player, Arguments: table)
		SettingsManager:AddSetting("CLI_TEST", false)
	end,
}
