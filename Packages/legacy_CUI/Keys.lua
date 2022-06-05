-- Keys.lua - 2022/04/15
-- Purpose: Keys that serve a certain purpose in CUI, like specifying a Children table or a OnEvent

return {
	Children = "CUI_CHILDREN_TABLE",
	OnEvent = function(Name)
		return "OnEvent" .. Name
	end,
	OnChange = function(Name)
		return "OnChange" .. Name
	end,
	State = function(DefaultValue)
		return "State" .. DefaultValue
	end,
	Props = "CUI_COMPONENT_PROPS",
}
