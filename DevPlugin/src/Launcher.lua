local Launcher = { Plugin = nil :: Plugin }
local WidgetManager = require(script.Parent.WidgetManager)
function Launcher:get_plugin()
	return self.Plugin
end

function Launcher:set_plugin(Plugin: Plugin)
	self.Plugin = Plugin
end

function Launcher:main(Plugin: Plugin)
	local Carbon = game:GetService("ReplicatedStorage"):WaitForChild("Carbon", 1)
	if not Carbon then
		warn("DevPlugin cannot continue - working in a non-Carbon-littered place")
	end

	self:set_plugin(Plugin)
	WidgetManager:main()
end

return Launcher
