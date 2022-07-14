local RunService = game:GetService("RunService")
local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Toolbar = require(script.Parent.Parent.MainToolbar)
local NakoJanitor = require(Carbon.Util.NakoJanitor)

local Widget = require(script.Parent.Parent.Widget)

local WidgetConstants = require(script.Parent.WidgetConstants)
local Selection = game:GetService("Selection")

local TitleFormats = {
	NothingSelected = "ViewModel Previewer - currently previewing nothing",
	Previewing = "ViewModel Previewer - previewing %s",
	InvalidStory = "ViewModel Previewer - invalid viewmodel",
}

local ViewPreviewer = Widget.new({
	Title = TitleFormats.NothingSelected,
	ID = "viewmodel-preview",
	WidgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, true, false, 800, 600, 32, 32),
})

function ViewPreviewer:init()
	self.LastModel = nil
	self.ActivateButton = Toolbar:add_button("Open", "open_viewmodel_preview", "Open ViewModel Previewer", "")

	self.Camera = Instance.new("Camera")
	self.Camera.Name = "ViewportPreviewCamera"

	self.ActivateButton.Click:Connect(function()
		self.Gui.Instance.Parent.Enabled = not self.Gui.Instance.Parent.Enabled
	end)

	self.Janitor = NakoJanitor.new()

	Selection.SelectionChanged:Connect(function()
		self:on_selection_change(Selection:Get()[1])
	end)
end

function ViewPreviewer:render()
	return CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = WidgetConstants.Colors.STUDIO_BACKGROUND_DARK,
		[CUI.Children] = {
			self.Camera,
			CUI:CreateElement("ViewportFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				CurrentCamera = self.Camera,
				Name = "Container",
				BackgroundColor3 = WidgetConstants.Colors.STUDIO_BACKGROUND_DARK_DARKER,
			}),
		},
	})
end

function ViewPreviewer:on_selection_change(Selection: Model)
	if not self.Enabled then
		return
	end

	if not Selection then
		self:set_title(TitleFormats.NothingSelected)
		return
	end

	local IsViewModel, ReasonNot = self:is_viewmodel(Selection)

	if not IsViewModel then
		warn("Not a ViewModel:", ReasonNot)
		self.Janitor:Cleanup()
		return
	end

	self.Janitor:Cleanup()

	local ModelClone = Selection:Clone()
	self.LastModel = ModelClone

	self:set_title(string.format(TitleFormats.Previewing, Selection.Name))

	self.Janitor:Add(RunService.Heartbeat:Connect(function()
		ModelClone:Destroy()
		ModelClone = Selection:Clone()

		self.LastModel = ModelClone

		self:preview_view(ModelClone)
	end))

	self:preview_view(ModelClone)
end

function ViewPreviewer:preview_view(ViewModel: Model)
	local Viewport = self.Gui:Get("Container")
	ViewModel.Parent = Viewport.Instance

	self.Camera.CFrame = ViewModel:GetPrimaryPartCFrame()
end

function ViewPreviewer:is_viewmodel(ViewModel: Model)
	if not ViewModel:IsA("Model") then
		return false, "Not a model"
	end

	if not ViewModel.PrimaryPart then
		return false, "No PrimaryPart selected"
	end

	if not ViewModel.PrimaryPart.Name == "Head" then
		return false, "PrimaryPart is not a head"
	end

	return true, "Passed all checks"
end

return ViewPreviewer
