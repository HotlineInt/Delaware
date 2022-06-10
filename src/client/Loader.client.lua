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

local LocalizedTags = {
	["tag_supporter"] = "Supporter",
	["tag_debugger"] = "Debugger",
	["tag_mod"] = "Moderator",
}

local YOU_HAVE_MESSAGE = "DEBUG MESSAGE: You have the following tags: %s"
local Core = script.Parent:WaitForChild("Core")
local System = script.Parent:WaitForChild("System")

Knit:Start():andThen(function()
	Carbon:RegisterModule(System.Notification)
	Carbon:RegisterModule(Core.CombatSystem)
	Carbon:RegisterModule(Core.Console)
	Carbon:RegisterModule(Core.Footsteps)
	Carbon:RegisterModule(Core.Settings.SettingsWidget)

	Carbon:RegisterModule(System.Debug.EconomyTest)

	Carbon:Start()
	ComponentLoader(Core.Components)

	ChatUtil:MakeSystemMessage("Welcome to Codename: Delaware")

	-- Tag checking
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

UserInputService.MouseIconEnabled = false

-- debug purposes only !!
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
