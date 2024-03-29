local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ComponentLoader = require(ReplicatedStorage:WaitForChild("ComponentLoader"))

local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)

local Data = script.Parent:WaitForChild("Data")
local NakoProfile = require(Data.NakoProfile)

local ServicesFolder = script.Parent.Services

local GameVersion = "v0.2a"
workspace:SetAttribute("GameVersion", GameVersion)

warn("Data initialization..")
NakoProfile:MakeStore("PlayerData", NakoProfile.Templates.Player)

local TotalServices = 0
for _, Service: ModuleScript in pairs(ServicesFolder:GetChildren()) do
	local ServiceTable = require(Service)
	ServiceTable.Name = Service.Name
	Knit:CreateService(ServiceTable)

	TotalServices += 1
end

Carbon:RegisterModule(script.Parent.Debug.ToolGiver)
Carbon:Start()

warn("Loaded %d services", TotalServices)

Knit:Start({ ServicePromises = false })
local Cmdr = require(ReplicatedStorage.Cmdr)
Cmdr:RegisterHooksIn(script.Parent.Cmdr.Hooks)
Cmdr:RegisterTypesIn(script.Parent.Cmdr.Types)
Cmdr:RegisterCommandsIn(script.Parent.Cmdr.Commands)
Cmdr:RegisterDefaultCommands()

ComponentLoader(script.Parent.Components)
