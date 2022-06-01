local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)

local ServicesFolder = script.Parent.Services

local GameVersion = "v0.2a"
workspace:SetAttribute("GameVersion", GameVersion)

local TotalServices = 0
for _, Service: ModuleScript in pairs(ServicesFolder:GetChildren()) do
	local ServiceTable = require(Service)
	Knit:CreateService(ServiceTable)

	TotalServices += 1
end

warn("Loaded %d services", TotalServices)

Knit:Start({ ServicePromises = false })
