local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local State = require(Carbon.UI.CUI.State)

local LoaderUi = game:GetService("ReplicatedFirst"):WaitForChild("LoaderUI")

local RandomStages = {
	"Data Loading",
	"Loading Carbon",
	"Loading UI",
	"Server Initialization",
	"Downloading resources...",
}

return function(MountPoint)
	local StageState = State.new("Please wait")
	local LoaderClone = LoaderUi:Clone()
	local Loader = require(LoaderClone)({ StageState = StageState })

	Loader:Mount(MountPoint)
	local LoopThread = task.spawn(function()
		while true do
			local RandomStage = RandomStages[math.random(1, #RandomStages)]

			StageState:Set(RandomStage)
			task.wait(math.random(0.2, 3))
		end
	end)

	return function()
		task.cancel(LoopThread)
		LoaderClone:Destroy()
		Loader:Destroy()
	end
end
