local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local State = require(Carbon.UI.CUI.State)
local Knit = require(Carbon.Framework.Knit)

local TagService = Knit:GetService("TagService")

local Router = require(Carbon.UI.CUIRouter)
local ModalBox = require(script.Parent.Parent.ModalBox)

local Player = Carbon:GetPlayer()
local F4Menu = {}

local PageSelectorButton = require(script.Components.PageSelectorButton)
local UserComponent = require(script.Components.User)

local Views = script:WaitForChild("Pages")

function F4Menu:Load()
	local Menu = CUI:CreateElement("ScreenGui", {
		Enabled = false,
		ResetOnSpawn = false,
		Name = "Panel",
		[CUI.Children] = {
			ModalBox(),
			CUI:CreateElement("Frame", {
				ClipsDescendants = true,
				Name = "Container",
				BackgroundColor3 = Color3.new(),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				--Size = UDim2.new(0, 400, 0, 250),
				Size = UDim2.new(0.5, 0, 0.5, 0),
				BorderSizePixel = 0,
				[CUI.Children] = {
					--	TitleLabel({ Title = "Home" }),
					CUI:CreateElement("Frame", {
						Name = "Viewer",
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 1),
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 1, 0),
						Size = UDim2.new(0.75, 0, 1, 1),
					}),
					CUI:CreateElement("UIAspectRatioConstraint", {
						AspectRatio = 1.7,
					}),
					CUI:CreateElement("Frame", {
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.new(0, 0, 1, 0),
						Size = UDim2.new(0.25, 0, 1, 0),
						BorderSizePixel = 0,
						Name = "PageSelector",
						BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
						-- uilistlayout
						[CUI.Children] = {
							UserComponent({ Rank = "User", User = Player }),
							CUI:CreateElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),
						},
					}),
				},
			}),
		},
	})

	CUI:MarkAsScalable(Menu)

	task.spawn(function()
		local UserCard = Menu:Get("Container"):Get("PageSelector"):Get("User")
		-- Figure out user rank
		TagService:GetTags():andThen(function(UserTags: {})
			local Rank = "User"
			local _, Tags = TagService:GetValidTags():await()

			if table.find(UserTags, Tags.Debugger) then
				Rank = "Debugger"
			end
			if table.find(UserTags, Tags.Moderator) then
				Rank = "Moderator"
			end
			if table.find(UserTags, Tags.Developer) then
				Rank = "Developer 🐇"
			end

			print("[F4Menu] Got user rank: " .. Rank)

			UserCard:Get("UserAndRank"):SetProperty("Text", string.format("<b>%s</b>\n<i>%s</i>", Player.Name, Rank))
		end)
	end)

	local Container = Menu:Get("Container")
	local Viewer = Container:Get("Viewer")
	local PageSelector = Menu:Get("PageSelector")

	self.Router = Router.new(Viewer, {
		["/home"] = {
			Title = "Home",
			View = require(Views.Home),
		},

		["/about"] = {
			Title = "About",
			View = require(Views.About),
		},

		["/debug"] = {
			Title = "Debug",
			View = require(Views.Debug),
		},
	})
	self.Router:GoTo("/home")

	local SelectedState = State.new("/home")

	self.Router.OnRoute:Connect(function(Route)
		print(Route)
		SelectedState:Set(Route)
	end)

	for Route, RouteInfo in pairs(self.Router:GetRoutes()) do
		PageSelector:Add(PageSelectorButton({
			Route = Route,
			Router = self.Router,
			SelectedState = SelectedState,
			Name = RouteInfo.Title,
		}))
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end

		if input.KeyCode == Enum.KeyCode.F4 then
			Menu:SetProperty("Enabled", not Menu:GetProperty("Enabled"))
			UserInputService.MouseIconEnabled = Menu:GetProperty("Enabled")

			-- Assed fix to make it render properly
			PageSelector:Get("User"):Get("UserAndRank"):SetProperty("RichText", true)
		end
	end)

	Menu:Mount(Player.PlayerGui)
end

return F4Menu
