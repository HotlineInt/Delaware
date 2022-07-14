local Launcher = require(script.Parent.Launcher)
local plugin: Plugin = Launcher:get_plugin()

local Toolbar = {
	Toolbar = nil,
	Name = "",
}
Toolbar.ClassName = "dp_toolbar"
Toolbar.__index = Toolbar

function Toolbar.new(Settings: { Name: string })
	local ToolbarInstance = plugin:CreateToolbar(Settings.Name)

	return setmetatable({
		Toolbar = ToolbarInstance,
		Buttons = {},
		Name = Settings.Name,
	}, Toolbar)
end

function Toolbar:get_toolbar()
	return self.Toolbar
end

function Toolbar:get_button(ID: string)
	return self.Buttons[ID]
end

function Toolbar:add_button(Name: string, ID: string, Tooltip: string?, Icon: string)
	local ToolbarInstance = self.Toolbar
	local ButtonExists = self:get_button(ID) ~= nil

	if ButtonExists then
		warn("Button already exists", ID)
		return
	end

	local Button = ToolbarInstance:CreateButton(ID, Tooltip, Icon, Name)

	self.Buttons[ID] = Button

	return Button
end

return Toolbar
