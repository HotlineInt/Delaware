local StarterGui = game:GetService("StarterGui")
-- Sets the property of CoreGuis based on a table
return function(CoreGuiTable: {})
	for Name, Value in pairs(CoreGuiTable) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[Name], Value)
	end
end
