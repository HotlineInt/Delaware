local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local TweenService = game:GetService("TweenService")
local CUI = require(Carbon.UI.CUI)
local Component = require(Carbon.Vendor.Component)

local Camera = workspace.CurrentCamera
local Player = Carbon:GetPlayer()

local Computer = Component.new({ Tag = "Computers" })

function Computer:Construct()
	local Model = self.Instance
	local Monitor = Model:WaitForChild("Screen")

	local ProximityPrompt: ProximityPrompt = Monitor:WaitForChild("ProximityPrompt")
	local CameraView: Attachment = Monitor:WaitForChild("CameraView")

	local ViewTween = TweenService:Create(
		Camera,
		TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{ CFrame = CameraView.WorldCFrame }
	)

	local Surface = CUI:CreateElement("SurfaceGui", {
		AlwaysOnTop = true,
		Adornee = Monitor,
		Name = "ScreenGui",
		ResetOnSpawn = false,
		SizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
		[CUI.Children] = {
			CUI:CreateElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Wallpaper",
				Image = "rbxassetid://9250088040",
				BackgroundTransparency = 1,
			}),
			-- make a taskbar
			CUI:CreateElement("Frame", {
				Name = "Taskbar",
				-- white background
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				ZIndex = 5,

				-- make start menu
				[CUI.Children] = {
					CUI:CreateElement("ImageButton", {
						Active = true,
						Name = "StartButton",
						Image = "rbxassetid://3392016992",
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						Size = UDim2.new(0, 32, 0, 32),
						Position = UDim2.new(0, 0, 0, 0),
						--AnchorPoint = Vector2.new(1, 0),
						ZIndex = 5,
						[CUI.OnEvent("Activated")] = function()
							print("nyanners")
						end,
					}),
				},
			}),
		},
	})

	ProximityPrompt.Triggered:Connect(function(TriggerPlayer: Player)
		ProximityPrompt.Enabled = false
		if TriggerPlayer ~= Player then
			return
		end

		Camera.CameraType = Enum.CameraType.Scriptable
		ViewTween:Play()
		UserInputService.MouseIconEnabled = true
	end)

	Surface:Mount(Player.PlayerGui)
end

return Computer
