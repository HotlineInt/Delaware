local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local SettingsManager = require(script.Parent.SettingsManager)
local SettingsWidget = {}

local Setting = require(script.Setting)
local TitleLabel = require(script.Parent.Parent.Parent.TitleLabel)

function SettingsWidget:Load()
	self.Widget = CUI:CreateElement("ScreenGui", {
		Enabled = false,
		Name = "SettingsContainment",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		[CUI.Children] = {
			CUI:CreateElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				TextTransparency = 1,
				BackgroundTransparency = 1,
				Modal = true,
				Visible = true,
			}),
			CUI:CreateElement("Frame", {
				BackgroundColor3 = Color3.new(),
				Name = "Container",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 200, 0, 300),
				[CUI.Children] = {
					TitleLabel({ Title = "Settings" }),
					CUI:CreateElement("ScrollingFrame", {
						BackgroundTransparency = 1,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(),
						ScrollBarThickness = 2,
						Name = "ScrollableSettingsExperience",
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.new(0, 0, 1, 0),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, -45),
						[CUI.Children] = { CUI:CreateElement("UIListLayout", {}) },
					}),
				},
			}),
		},
	})

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.Tab then
			local Enabled = not self.Widget:GetProperty("Enabled")
			UserInputService.MouseIconEnabled = Enabled
			self:SetEnabled(Enabled)
		end
	end)
	self:LoadSettings()

	self.Widget:Mount(Players.LocalPlayer.PlayerGui)
end

function SettingsWidget:LoadSettings()
	local SettingsContainer = self.Widget:Get("ScrollableSettingsExperience")

	for _, Child in pairs(SettingsContainer.Instance:GetChildren()) do
		if not Child:IsA("UIListLayout") then
			Child:Destroy()
		end
	end

	for _, SettingValues in pairs(SettingsManager.Settings) do
		local Setting = Setting(SettingValues)
		SettingsContainer:Add(Setting)
	end
end

function SettingsWidget:SetEnabled(Enabled: boolean)
	if Enabled then
		self:LoadSettings()
	end

	self.Widget:SetProperty("Enabled", Enabled)
end

return SettingsWidget
