local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- get cui
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local CUIRouter = require(Carbon.UI.CUIRouter)
local Store = {}

local Store = require(script.Routes.Store)
local Item = require(script.Routes.Item)

function Store:Load()
	local Viewer = CUI:CreateElement("ScreenGui", {
		Name = "Viewer",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 999999,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Name = "Container",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 800, 0, 400),
			}),
		},
	})

	Viewer:Mount(Carbon:GetPlayer().PlayerGui)
	Viewer = Viewer:Get("Container")

	local Router = CUIRouter.new(Viewer, {
		["/store"] = Store,
		["/item"] = Item,
	})

	Router:GoTo("/store", {})
end

return Store
