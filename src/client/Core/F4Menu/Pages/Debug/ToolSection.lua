local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
local GetToolsEvent = Events["dbg_get_tools"]
local GiveToolEvent = Events["dbg_give_tool"]

local TextPrompt = require(script.Parent.Parent.Parent.Components.TextPrompt)

local function ToolComponent(Tool: Tool)
	return CUI:CreateElement("TextButton", {
		Size = UDim2.new(0, 60, 0, 60),
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		Text = Tool.Name,
		BorderSizePixel = 0,
		Font = Enum.Font.SourceSans,
		TextSize = 18,
		TextWrapped = true,
		TextColor3 = Color3.new(1, 1, 1),
		[CUI.OnEvent("Activated")] = function(self)
			self.Parent.Parent.Parent.Parent:Add(TextPrompt({
				Prompt = "Are you sure?",
				Callback = function()
					GetToolsEvent:FireServer(Tool.Name)
				end,
			}))
			--GiveToolEvent:FireServer(Tool.Name)
		end,
	})
end

return function()
	-- local Tools = {
	-- 	TestTool1 = {
	-- 		Name = "Test Tool",
	-- 	},
	-- 	uwu = {
	-- 		Name = "daddy~~",
	-- 	},
	-- }

	local ToolsSection = CUI:CreateElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,

		[CUI.Children] = {
			CUI:CreateElement("UIGridLayout", {
				CellSize = UDim2.new(0, 60, 0, 60),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			CUI:CreateElement("TextLabel", {
				Name = "LoadingIndicator",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 0.3,
				BackgroundColor3 = Color3.new(0, 0, 0),
				Text = "Loading..",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 15,
				Font = Enum.Font.SourceSansSemibold,
			}),
		},
	})

	task.spawn(function()
		local Tools = GetToolsEvent:InvokeServer()
		local Indicator = ToolsSection:Get("LoadingIndicator")

		for _, Tool in pairs(Tools) do
			ToolsSection:Add(ToolComponent(Tool))
		end
		Indicator:Destroy()
	end)

	return ToolsSection
end
