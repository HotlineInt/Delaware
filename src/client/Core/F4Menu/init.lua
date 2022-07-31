local UserInputService = game:GetService("UserInputService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)
local Observable = require(Carbon.UI.CUI.Observable)
local Knit = require(Carbon.Framework.Knit)

local TagService = Knit:GetService("TagService")

local Router = require(Carbon.UI.CUIRouter)
local Player = Carbon:GetPlayer()
local F4Menu = {}

local PageSelectorButton = require(script.Components.PageSelectorButton)
local UserComponent = require(script.Components.User)

local MouseBehaviour = require(script.Parent.Parent.System.MouseBehaviour)
local Views = script:WaitForChild("Pages")

local UserState = require(script.Parent.Parent.UserState)
local UserStateEnum = require(script.Parent.Parent.UserState.StateEnum)

local POSITIONS = {
	OPEN = UDim2.new(0.5, 0, 0.5, 0),
	CLOSED = UDim2.new(0.5, 0, 1, 0),
}

local TRANSPARENCY = {
	OPEN = 0,
	CLOSED = 1,
}

function F4Menu:Load()
	local Menu = CUI:CreateElement("ScreenGui", {
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Name = "Panel",
		[CUI.Custom("Reset")] = function(self)
			local self = self:Get("Container")
			-- Cancel any springs we may have, just so the values properly
			self:CancelSpring()
			self:SetProperty("Position", POSITIONS.CLOSED)
			self:SetProperty("GroupTransparency", TRANSPARENCY.CLOSED)
		end,

		[CUI.Custom("Open")] = function(self)
			self:Reset()
			local self = self:Get("Container")
			self:AnimateSpring(0.75, 1.8, { GroupTransparency = TRANSPARENCY.OPEN })
			self:AnimateSpring(0.8, 2.75, { Position = POSITIONS.OPEN })
		end,

		[CUI.Custom("Close")] = function(self)
			local self = self:Get("Container")
			self:AnimateSpring(0.8, 4.9, { GroupTransparency = TRANSPARENCY.CLOSED })
			self:AnimateSpring(0.8, 2.75, { Position = POSITIONS.CLOSED })
		end,

		[CUI.Children] = {
			-- ModalBox(),
			CUI:CreateElement("CanvasGroup", {
				-- mark it as scaleable (screenguis wont do)
				[CUI.Scaleable] = true,
				ClipsDescendants = true,
				Name = "Container",
				BackgroundColor3 = Color3.new(),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = POSITIONS.CLOSED,
				-- Position = UDim2.new(0.5, 0, 0.5, 0),
				GroupTransparency = TRANSPARENCY.CLOSED,
				Size = UDim2.new(0, 400, 0, 250),
				--Size = UDim2.new(0.35, 0, 0.35, 0),
				BorderSizePixel = 0,

				[CUI.Children] = {
					CUI:CreateElement("Frame", {
						Name = "Viewer",
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 1),
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 1, 0),
						Size = UDim2.new(0.75, 0, 1, 1),
					}),
					CUI:CreateElement("UIAspectRatioConstraint", {
						AspectRatio = 1.8,
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
	local MenuOpen = false

	self.Menu = Menu

	-- ! do not enable!
	-- ! CUI scaling on ScreenGuis is very buggy!!
	-- CUI:MarkAsScalable(Menu)

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

	local SelectedState = Observable.new("/home")

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
			if MenuOpen then
				MouseBehaviour:RemoveMenu("MENU_F4")
				UserState:Set(UserStateEnum.NORMAL)
				Menu:Close()
			else
				MouseBehaviour:AddMenu("MENU_F4")
				UserState:Set(UserStateEnum.IN_F4_MENU)
				Menu:Open()
			end

			MenuOpen = not MenuOpen

			-- Assed fix to make it render properly
			PageSelector:Get("User"):Get("UserAndRank"):SetProperty("RichText", true)
		end
	end)

	Menu:Mount(Player.PlayerGui)
end

return F4Menu
