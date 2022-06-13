local ToolGiver = {}

local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)
local TagService = require(script.Parent.Parent.Services.TagService)

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")

local GetToolsEvent = Events["dbg_get_tools"]
local GiveToolEvent = Events["dbg_give_tool"]

local ToolsFolder = game:GetService("ServerStorage"):WaitForChild("Tools")

function ToolGiver:Load()
	function GetToolsEvent.OnServerInvoke(Player: Player)
		if not TagService:PlayerHasTag(Player, TagService.Tags.Developer) then
			return
		end

		local Tools = {}

		for _, Tool in pairs(ToolsFolder:GetChildren()) do
			table.insert(Tools, {
				Name = Tool.Name,
			})
		end

		return Tools
	end

	GiveToolEvent.OnServerEvent:Connect(function(Player: Player, Tool: string)
		if not TagService:PlayerHasTag(Player, TagService.Tags.Developer) then
			return
		end

		local Backpack = Player.Backpack
		local Tool = ToolsFolder:FindFirstChild(Tool)

		if Tool then
			local ToolClone = Tool:Clone()

			-- Let the tool initialize
			ToolClone.Parent = Player
			task.defer(function()
				task.wait(0.2)
				ToolClone.Parent = Backpack
			end)
		end
	end)
end

return ToolGiver
