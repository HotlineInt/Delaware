return function(context, attrib: string, value: string)
	local tool = context.Executor.Character:FindFirstChildOfClass("Tool")

	print(value)
	tool:SetAttribute(attrib, value)
end
