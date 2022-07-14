local Widgets = script.Parent:WaitForChild("Widgets")
local WidgetManager = { Widgets = {} }

function WidgetManager:get_widgets()
	return self.Widgets
end

function WidgetManager:load_widget(ModuleScript: ModuleScript)
	local WidgetClass = require(ModuleScript)

	if WidgetClass.ClassName == "dp_widget" then
		WidgetClass:init()
		WidgetClass:render_internal()
	end
end

function WidgetManager:main()
	for _, Widget in pairs(Widgets:GetChildren()) do
		if Widget:IsA("ModuleScript") then
			print("Loading", Widget)
			self:load_widget(Widget)
		end
	end
end

return WidgetManager
