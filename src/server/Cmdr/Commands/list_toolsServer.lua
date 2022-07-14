-- list_tools implementation
local Tools = game:GetService("ServerStorage"):WaitForChild("Tools")

return function(context, tool: string)
	local tool = {}

	for _, Tool in pairs(Tools:GetChildren()) do
		table.insert(tool, Tool.Name .. ":" .. tostring(Tool))
	end

	return "Available tools: \n" .. table.concat(tool, "\n")
end
