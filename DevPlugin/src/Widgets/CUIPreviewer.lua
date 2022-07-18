local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Toolbar = require(script.Parent.Parent.MainToolbar)
local NakoJanitor = require(Carbon.Util.NakoJanitor)

local Widget = require(script.Parent.Parent.Widget)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WidgetConstants = require(script.Parent.WidgetConstants)
local Selection = game:GetService("Selection")

local STORY_CONTAINER_NAME = "dev_stories"
local TitleFormats = {
	NothingSelected = "CUI Previewer - currently previewing nothing",
	Previewing = "CUI Previewer - previewing %s",
	InvalidStory = "CUI Previewer - invalid story",
}
local StoryContainer = ReplicatedStorage:WaitForChild(STORY_CONTAINER_NAME, 5)

local CUIPreviewer = Widget.new({
	Title = TitleFormats.NothingSelected,
	ID = "cui-preview-v012",
	WidgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, true, false, 800, 600, 32, 32),
})

function CUIPreviewer:init()
	self.LastStoryFile = nil
	self.ActivateButton = Toolbar:add_button("Open", "open_cui_preview", "Open CUI Previewer", "")

	self.ActivateButton.Click:Connect(function()
		self.Gui.Instance.Parent.Enabled = not self.Gui.Instance.Parent.Enabled
	end)

	self.Janitor = NakoJanitor.new()

	if not StoryContainer then
		-- create one
		StoryContainer = Instance.new("Folder")
		StoryContainer.Name = STORY_CONTAINER_NAME
		StoryContainer.Parent = ReplicatedStorage
	end

	Selection.SelectionChanged:Connect(function()
		self:on_selection_change(Selection:Get()[1])
	end)
end

function CUIPreviewer:render()
	return CUI:CreateElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = WidgetConstants.Colors.STUDIO_BACKGROUND_DARK,
		[CUI.Children] = {
			CUI:CreateElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Container",
				BackgroundColor3 = WidgetConstants.Colors.STUDIO_BACKGROUND_DARK_DARKER,
			}),
		},
	})
end

function CUIPreviewer:on_selection_change(Selection: ModuleScript | Instance)
	if not self.Enabled then
		return
	end

	if not Selection then
		self:set_title(TitleFormats.NothingSelected)
		if self.LastStoryFile then
			self.LastStoryFile:Destroy()
		end
		return
	end

	if self.LastStoryFile then
		self.LastStoryFile:Destroy()
	end

	local IsStory, ReasonWhyNot = self:is_story(Selection)

	if not IsStory then
		self:set_title(TitleFormats.InvalidStory)
		warn("Not a story file:", ReasonWhyNot)
		return
	end
	self.Janitor:Cleanup()

	if self.CleanupFunc then
		local _, error = pcall(self.CleanupFunc)

		if error then
			warn("Error while executing cleanup:", error)
		end
	end

	local Container = self.Gui:Get("Container")
	Container.Instance:ClearAllChildren()

	local StoryFile = Selection:Clone()
	StoryFile.Parent = Selection.Parent

	StoryFile.Name = "story_clone" .. StoryFile:GetFullName()
	self.LastStoryFile = StoryFile

	self:set_title(string.format(TitleFormats.Previewing, Selection.Name))

	self.Janitor:Add(Selection:GetPropertyChangedSignal("Source"):Connect(function()
		self:on_selection_change(Selection)
	end))

	self:preview_file(StoryFile, Container.Instance)
end

function CUIPreviewer:preview_file(StoryFile: ModuleScript, Container: Frame | {})
	local RenderFunction = require(StoryFile)
	local CleanupFunc = RenderFunction(Container)

	self.CleanupFunc = CleanupFunc
end

function CUIPreviewer:is_story(File: ModuleScript): boolean | string
	local Name = File.Name
	local NameEndsWithStory = Name:match("%.story$")

	if not NameEndsWithStory then
		return false, "File is not a story"
	end

	if not File:IsA("ModuleScript") then
		return false, "File is not a module"
	end

	local RenderFunction = require(File)

	if type(RenderFunction) ~= "function" then
		return false, "Story does not return a render function"
	end

	return true, "File passed story check successfully"
end

return CUIPreviewer
