local Launcher = require(script.Parent.Launcher)
local plugin: Plugin = Launcher:get_plugin()

local Widget = {
	Title = "",
	Enabled = true,
	DockWidget = nil,
	Gui = {},
	WidgetInfo = nil,
}
Widget.ClassName = "dp_widget"
Widget.__index = Widget

function Widget.new(Settings: { Title: string, ID: string, WidgetInfo: DockWidgetPluginGuiInfo })
	local SelfWidget = plugin:CreateDockWidgetPluginGui(Settings.ID, Settings.WidgetInfo)
	SelfWidget.Name = Settings.Title
	SelfWidget.Title = Settings.Title

	return setmetatable({
		Title = Settings.Title,
		ID = Settings.ID,
		DockWidget = SelfWidget,
		WidgetInfo = Settings.WidgetInfo,
	}, Widget)
end

function Widget:init() end

function Widget:get_widget()
	return self.DockWidget
end

function Widget:render() end

function Widget:render_internal()
	local UI = self:render()

	if UI then
		self.Gui = UI
		UI:Mount(self.DockWidget)
	else
		error("Widget::Render did not return anything")
	end
end

function Widget:set_enabled(Enabled: boolean)
	self.Enabled = Enabled
	self.DockWidget.Enabled = Enabled
end

function Widget:set_title(Title: string)
	self.Title = Title
	self.DockWidget.Title = Title
end

return Widget
