local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local State = require(Carbon.UI.CUI.Observable)

local Enum = require(script.StateEnum)

local UserState = State.new(Enum.NORMAL)
return UserState
