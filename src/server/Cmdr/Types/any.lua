local Util = require(script.Parent.Parent.Shared.Util)

return function(cmdr)
	local any = {
		Transform = function(text)
			return tonumber(text) or tostring(text)
		end,

		Validate = function()
			return true
		end,
	}

	cmdr:RegisterType("any", any)
end
