local GuiService = game:GetService("GuiService")
-- give_tool implementation
local Tools = game:GetService("ServerStorage"):WaitForChild("Tools")

return function(context, tool: string)
	local Tool = Tools:FindFirstChild(tool)
	local Executor = context.Executor

	if Tool then
		local weapon_clone = Tool:Clone()

		-- give it a frame to properly initialize
		weapon_clone.Parent = Executor
		task.defer(function()
			weapon_clone.Parent = Executor.Backpack
		end)

		return "SUCCESS: weapon given"
	else
		return "ERROR: invalid weapon id"
	end
end
