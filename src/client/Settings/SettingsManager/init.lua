export type Setting = {
	Name: string,
	Value: any,
	ChangeSignal: RBXScriptSignal,
}

local SettingClass = require(script.Setting)
local SettingsManager = {
	Settings = {
		SettingClass.new("cl_showfps", true),
	},
}

function SettingsManager:AddSetting(Name: string, DefaultValue: any): Setting
	local NewSetting = SettingClass.new(Name, DefaultValue)
	print(NewSetting)

	table.insert(self.Settings, NewSetting)

	return NewSetting
end

function SettingsManager:GetSetting(Name: string): Setting
	for _, Setting in pairs(self.Settings) do
		if Setting.Name == Name then
			return Setting
		end
	end

	error("No such setting exists: " .. Name)
end

function SettingsManager:SetSetting(Name: string, NewValue: any): nil
	local Setting = self:GetSetting(Name)
	Setting:SetValue(NewValue)
end

function SettingsManager:OnSettingChange(Name: string, Callback: any): RBXScriptConnection
	local Setting = self:GetSetting(Name)
	return Setting.ChangeSignal:Connect(Callback)
end

return SettingsManager
