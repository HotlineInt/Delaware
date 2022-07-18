script.Parent:RemoveDefaultLoadingScreen()
--local Playerlist = require(script.Parent:WaitForChild("Playerlist"))
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ComponentLoader = require(ReplicatedStorage:WaitForChild("ComponentLoader"))
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local ChatUtil = require(Carbon.Util.Chat)

local State = require(Carbon.UI.CUI.State)
local CUI = require(Carbon.UI.CUI)

local Player = game:GetService("Players").LocalPlayer
local Knit = require(Carbon.Framework.Knit)

local LocalizedTags = {
	["tag_supporter"] = "Supporter",
	["tag_debugger"] = "Debugger",
	["tag_mod"] = "Moderator",
}

local YOU_HAVE_MESSAGE = "DEBUG MESSAGE: You have the following tags: %s"
local Core = script.Parent:WaitForChild("Core")
local System = script.Parent:WaitForChild("System")

local LoaderUI = require(script.Parent.LoaderUI)
local LoaderTree =
	CUI:CreateElement("ScreenGui", { DisplayOrder = 999999, IgnoreGuiInset = true, ResetOnSpawn = false })
LoaderTree:Mount(Player:WaitForChild("PlayerGui"))

function ConvertToHMS(Time: number)
	local function Format(Int)
		return string.format("%02i", Int)
	end

	local Seconds = Time

	local Minutes = (Seconds - Seconds % 60) / 60
	Seconds = Seconds - Minutes * 60
	local Hours = (Minutes - Minutes % 60) / 60
	Minutes = Minutes - Hours * 60
	return Format(Hours) .. ":" .. Format(Minutes) .. ":" .. Format(Seconds)
end

local Stages = {
	{
		Text = "Disabling Core",
		Run = function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		end,
	},
	{
		Text = "Awaiting server initialization",
		Run = function()
			Knit:Start():await()
		end,
	},
	{
		Text = "Registering modules",
		Run = function(Label)
			Carbon:RegisterModule(System.Notification)
			Carbon:RegisterModule(Core.CombatSystem)
			--	Carbon:RegisterModule(Core.Console)
			Carbon:RegisterModule(Core.Footsteps)

			Carbon:RegisterModule(Core.Settings.SettingsWidget)

			Carbon:RegisterModule(System.Overlays)
			--Carbon:RegisterModule(System.Debug.EconomyTest)
			Carbon:RegisterModule(System.Debug.PerformanceStats)

			Carbon:RegisterModule(Core.F4Menu)
			--Carbon:RegisterModule(Core.MainMenu.MainMenu)
			Carbon:RegisterModule(Core.Sprinting)
		end,
	},
	{
		Text = "Starting Carbon",
		Run = function()
			Carbon:Start()
		end,
	},

	-- {
	-- 	Text = "Checking for server maintenance..",
	-- 	Run = function(Label)
	-- 		-- test garbage ignore!!
	-- 		local IS_MAINTENANCE = false
	-- 		local TimeSpent = 0

	-- 		while IS_MAINTENANCE do
	-- 			-- Label:SetProperty(
	-- 			-- 	"Text",
	-- 			-- 	string.format("Maintenance in progress.. (waiting for %s)", ConvertToHMS(TimeSpent))
	-- 			-- )
	-- 			print(string.format("Maintenance in progress.. (waiting for %s)", ConvertToHMS(TimeSpent)))
	-- 			TimeSpent += 1

	-- 			task.wait(1)
	-- 		end
	-- 	end,
	-- },
	{
		Text = "Component initialization",
		Run = function()
			ComponentLoader(Core.Components)
		end,
	},

	{
		Text = "Misc initialization",
		Run = function()
			-- cmdr does garbage on require... why???????
			-- why pain yourself like this???

			-- NOTE TO FUTURE SELF: IF I EVER MAKE MY OWN CMD BAR: DO NOTHING ON REQUIRE!!!!!!!!!!!!
			-- ITS BAD PRACTICE AND WILL ONLY CAUSE HEADACHES AND ANGER
			local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

			-- .. why is there no :SetActivationKey
			-- why can you only set a table of keys...
			-- why is it like this??
			Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
			Cmdr:SetPlaceName("Delaware@" .. workspace:GetAttribute("GameVersion"))
		end,
	},

	{
		Text = "Registering tags",
		Run = function()
			local TagService = Knit:GetService("TagService")
			TagService:GetTags():andThen(function(SelfTags: {})
				local JoinedTags = ""
				local Count = #SelfTags

				if Count == 0 then
					JoinedTags = "None"
				end

				for Index, Tag in ipairs(SelfTags) do
					local Localized = LocalizedTags[Tag]
					if Localized then
						Localized = Tag
					end

					print(Index, Tag)

					-- this took longer to make than the entirety of HCS
					if Index ~= Count then
						print(",")
						JoinedTags = JoinedTags .. Tag .. ", "
					elseif Index == Count then
						print("eol")
						JoinedTags = JoinedTags .. Tag
					end
				end

				ChatUtil:MakeSystemMessage(string.format(YOU_HAVE_MESSAGE, JoinedTags))
			end)
		end,
	},

	{
		Text = "CoreGui configuration",
		Run = function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

			UserInputService.MouseIconEnabled = false
			Camera.FieldOfView = 90

			Player.CameraMode = Enum.CameraMode.LockFirstPerson
		end,
	},
	{
		Text = "Ready to go",
		Run = function()
			task.wait(0.6)
		end,
	},
}

local StageState = State.new("Stage Initialization")
local Loader = LoaderUI({ StageState = StageState })
LoaderTree:Add(Loader)

for _, Stage in ipairs(Stages) do
	print("Running stage ", Stage.Text)
	task.delay(0.1, function()
		StageState:Set(Stage.Text)
	end)

	local Success, Error = pcall(function()
		Stage.Run()
	end)

	if Error then
		warn("Stage", Stage.Text, "failed: ", Error)
	end
end

LoaderTree:Destroy()
