local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local Observable = require(Carbon.UI.CUI.State)

local Janitor = require(Carbon.Util.NakoJanitor)

local SegmentDisplay = require(script.SegmentDisplay)

local HUD: HUD = {}

function HUD:Load()
	self.Janitor = Janitor.new()
	self.HealthState = Observable.new(100)
	local PaddingValues = UDim.new(0, 5)

	local HUDMount = CUI:CreateElement("ScreenGui", {
		Name = "HUD",
		--IgnoreGuiInset = true,
		[CUI.Children] = {
			CUI:CreateElement("UIPadding", {
				PaddingBottom = PaddingValues,
				PaddingLeft = PaddingValues,
			}),

			CUI:CreateElement("Frame", {
				Name = "Health",
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(0, 100, 0, 100),
				[CUI.Children] = {
					CUI:CreateElement("TextLabel", {
						Name = "Text",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.SourceSansBold,
						TextScaled = true,
						Text = self.HealthState:Listen(function(self: CUI.Element, Health: number)
							return tostring(Health)
						end),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						[CUI.Children] = {
							CUI:CreateElement("UITextSizeConstraint", {
								MaxTextSize = 30,
							}),
						},
					}),
				},
			}),
		},
	})

	self.HUDDisplay = HUDMount
	HUDMount:Mount(Carbon:GetPlayer().PlayerGui)
end

function HUD:OnCharacterAdded(Character: Model)
	self.Janitor:Cleanup()
	local Humanoid = Character:WaitForChild("Humanoid")
	self.HealthState:Set(100)

	self.Janitor:Add(Humanoid.HealthChanged:Connect(function(...)
		self:UpdateHealth(...)
	end))
end

function HUD:UpdateHealth(Health: number)
	print("Update", Health)
	self.HealthState:Set(Health)
end

export type HUD = {
	HUDDisplay: table,
	Load: nil,
	SegmentDisplay: {},
}

return HUD
