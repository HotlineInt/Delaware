local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Network = require(Carbon.Network.Centwork)

local NetworkTest = {}

return function()
	local GotResult = false
	Network:GetEvent("Test"):WaitForFire(function(...)
		print("Server gave us", ...)
		Network:GetEvent("Test"):Fire("test1")
		GotResult = true
	end)

	return GotResult
end
