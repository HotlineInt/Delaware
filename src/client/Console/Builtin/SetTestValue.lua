local SettingsManager = require(script.Parent.Parent.Parent.Settings.SettingsManager)

return {
	Name = "set_test_value",
	Description = "Shows the current place version",
	Execute = function(Runner: Player, Arguments: table)
		SettingsManager:SetSetting("CLI_TEST", not SettingsManager:GetSetting("CLI_TEST").Value)
	end,
}
