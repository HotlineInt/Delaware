local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local Signal = require(Packages.Signal)

local Setting = { Name = "DEFAULT_VALUE", IS_SETTING = true, Value = nil, ChangeSignal = nil }
Setting.__index = Setting

-- lua class
function Setting.new(Name: string, DefaultValue: any)
	return setmetatable({ Name = Name, Value = DefaultValue, ChangeSignal = Signal.new() }, Setting)
end

function Setting:GetValue()
	return Setting.Value
end

function Setting:SetValue(NewValue: any)
	local OldValue = self.Value
	self.Value = NewValue
	self.ChangeSignal:Fire(OldValue, NewValue)
end

return Setting
