local SettingsManager = require(script.Parent.Parent.Parent.Settings.SettingsManager)

return {
	Name = "listen_test_value",
	Description = "Shows the current place version",
	Execute = function(Runner: Player, Arguments: table)
		SettingsManager:OnSettingChange("CLI_TEST", function(OldValue, NewValue)
			print("CLI_TEST changed from", OldValue, "to", NewValue)
		end)
		print("Now listening to test value")
	end,
}
