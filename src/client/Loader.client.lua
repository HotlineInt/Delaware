script.Parent:RemoveDefaultLoadingScreen()
--local Playerlist = require(script.Parent:WaitForChild("Playerlist"))
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ComponentLoader = require(ReplicatedStorage:WaitForChild("ComponentLoader"))
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local ChatUtil = require(Carbon.Util.Chat)

local Knit = require(Carbon.Framework.Knit)

local Vendor = game:GetService("ReplicatedStorage"):WaitForChild("Vendor")
local TopbarPlus = require(Vendor.TopbarPlus)

local TestCrap = TopbarPlus.mimic("Backpack")

local LaunchTestEnv = false

if LaunchTestEnv then
	local TestRunner = require(script.Parent.TestRunner)
	TestRunner:Begin()
	return
end

local LocalizedTags = {
	["tag_supporter"] = "Supporter",
	["tag_debugger"] = "Debugger",
	["tag_mod"] = "Moderator",
}

local YOU_HAVE_MESSAGE = "DEBUG MESSAGE: You have the following tags: %s"

local TEST = true -- True for now. -- Carbon:IsStudio()

Carbon:RegisterModule(script.Parent.Notification)
Carbon:RegisterModule(script.Parent.Console)
Carbon:RegisterModule(script.Parent.Settings.SettingsWidget)
Carbon:RegisterModule(script.Parent.Footsteps)
Knit:Start():andThen(function()
	if TEST then
		Carbon:RegisterModule(script.Parent.HUD)
		--require(script.Parent.Screens.BuySupporter)():Mount(Carbon:GetPlayer().PlayerGui)

		for _, DebugModule in pairs(script.Parent.Debug:GetChildren()) do
			Carbon:RegisterModule(DebugModule)
		end

		Carbon:RegisterModule(script.Parent.CombatSystem)
	end

	Carbon:Start()
	ComponentLoader(script.Parent.Components)

	-- Tag checking
	local TagService = Knit:GetService("TagService")
	TagService:GetTags():andThen(function(SelfTags: {})
		local JoinedTags = ""
		local Count = #SelfTags

		for Index, Tag in ipairs(SelfTags) do
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
end)

Camera.FieldOfView = 90
--StarterGui:SetCore("TopbarEnabled", false)

-- debug purposes only !!
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
UserInputService.MouseIconEnabled = false
