local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local PlayerGui = Carbon:GetPlayer():WaitForChild("PlayerGui")
local CUI = require(Carbon.UI.CUI)

local Children = CUI.Children

local MainMenuButton = require(script.MainMenuButton)
local MouseBehavior = require(script.Parent.Parent.System.MouseBehaviour)

local CoreTableSet = require(script.Parent.Parent.TableCoreSet)
local CoreConstants = require(ReplicatedStorage:WaitForChild("CoreConstants"))

local UserState = require(script.Parent.Parent.UserState)
local UserEnum = require(script.Parent.Parent.UserState.StateEnum)

local Movement = require(script.Parent.Parent.UserState.Movement)

local Logo = require(script.Logo)
local MainMenu = { GuiContainer = {} }

function MainMenu:Load()
	-- make a gui container
	UserState:Set(UserEnum.IN_MAIN_MENU)
	MouseBehavior:AddMenu("MENU_MAIN")
	Movement:Disable()
	CoreTableSet(CoreConstants.CoreGui.MainMenu)
	self.GuiContainer = CUI:CreateElement("ScreenGui", {
		Name = "MainMenu",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		[Children] = {
			CUI:CreateElement("Frame", {
				Name = "Container",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(35, 35, 35),
				BackgroundTransparency = 1,
				[Children] = {
					CUI:CreateElement("Frame", {
						Name = "SubContainer",
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						--BackgroundTransparency = 1,
						Size = UDim2.new(0.3, 0, 1, 0),
						AnchorPoint = Vector2.new(0.25, 0.5),
						Position = UDim2.new(0.1, 0, 0.5, 0),
						[Children] = {
							Logo(),
							CUI:CreateElement("Frame", {
								Name = "ButtonContainer",
								AnchorPoint = Vector2.new(0, 1),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 0, 0.8, 0),
								Size = UDim2.new(1, 0, 0.8, 0),
								[Children] = {
									CUI:CreateElement("UIListLayout", {
										Padding = UDim.new(0, 10),
										VerticalAlignment = Enum.VerticalAlignment.Center,
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
									}),
									CUI:CreateElement("UIAspectRatioConstraint", {}),
									MainMenuButton({ Label = "CONTINUE", Disabled = true }),
									MainMenuButton({ Label = "START ANEW", Disabled = false }),
									MainMenuButton({ Label = "SYSTEM SETTINGS", Disabled = false }),
									MainMenuButton({ Label = "ACHIEVEMENTS", Disabled = false }),
									CUI:ComputeCondition(true, function()
										return MainMenuButton({ Label = "EXTRAS", Disabled = false })
									end),
								},
							}),
						},
					}),
				},
			}),
		},
	})

	self.GuiContainer:Mount(PlayerGui)
end

return MainMenu
