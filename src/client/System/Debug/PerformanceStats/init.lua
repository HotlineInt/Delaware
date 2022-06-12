local SettingsManager = require(script.Parent.Parent.Parent.Core.Settings.SettingsManager)

local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local DebugStat = require(script.Stat)

local PerformanceStats = {
	Stats = {},
	PanelCount = 0,
	Panel = nil,
	FrameUpdateTable = {},
}

local LastIteration, Start = nil, os.clock()
local TimeSinceLastFPSUpdate -- os.clock()

function PerformanceStats:Load()
	local Panel = CUI:CreateElement("ScreenGui", {
		Name = "PerformanceStats",
		IgnoreGuiInset = true,
		DisplayOrder = 99999,
		ResetOnSpawn = false,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Name = "Container",
				Size = UDim2.new(1, -100, 0, 36),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				[CUI.Children] = {
					CUI:CreateElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.Name,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
				},
			}),
		},
	})
	self.Panel = Panel

	self:RegisterStat("FPS", false)
	self:RegisterStat("Ping: ???", false)

	SettingsManager:OnSettingChange("cl_showfps", function(Value)
		self:TogglePanel("FPS", not Value)
	end)

	Panel:Mount(Carbon:GetPlayer().PlayerGui)
end

function PerformanceStats:RegisterStat(Name: string, Disabled: boolean)
	self.PanelCount += 1
	local PanelElement = DebugStat.new(tostring(self.PanelCount) .. Name)
	local Element = PanelElement:Render({ Disabled = Disabled })
	local Container = self.Panel:Get("Container")

	Element:Mount(Container)

	self.Stats[Name] = PanelElement
	return PanelElement
end

function PerformanceStats:TogglePanel(PanelName: string, EnabledValue: boolean)
	local Panel = self.Stats[PanelName]

	if Panel then
		Panel.Panel:SetProperty("Visible", EnabledValue)
	end
end

function PerformanceStats:IsPanelEnabled(PanelName: string)
	local Panel = self.Stats[PanelName]

	return Panel.Panel:GetProperty("Visible")
end

function PerformanceStats:Update()
	for Name, Stat in pairs(self.Stats) do
		if Name == "FPS" and Stat.Panel:GetProperty("Visible") then
			local FrameUpdateTable = self.FrameUpdateTable
			LastIteration = os.clock()
			if TimeSinceLastFPSUpdate == nil then
				TimeSinceLastFPSUpdate = 4
			end

			local TimeElapsed = os.clock() - TimeSinceLastFPSUpdate
			for Index = #FrameUpdateTable, 1, -1 do
				FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index]
					or nil
			end

			FrameUpdateTable[1] = LastIteration

			if TimeElapsed >= 4 then
				Stat:SetText(
					tostring(
						math.floor(
							os.clock() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (os.clock() - Start)
						)
					)
				)
				TimeSinceLastFPSUpdate = os.clock()
			end
		end
	end
end

return PerformanceStats
