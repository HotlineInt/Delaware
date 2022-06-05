local Stack = require(script.Stack)
local Signal = require(script.Parent.Signal)

local ScreenStack = {
	Stack = nil,
	Container = nil,
	CurrentScreen = nil,
	LastScreen = nil,
	OnPush = nil, -- Signal.new(),
	OnExit = nil, --Signal.new(),
}
ScreenStack.__index = ScreenStack

export type Table = {}

function ScreenStack.new(Container: ScreenGui)
	return setmetatable({
		Container = Container,
		Stack = Stack.new(),
		OnPush = Signal.new(),
		OnSuspend = Signal.new(),
		OnResume = Signal.new(),
		OnExit = Signal.new(),
		FinishedSignal = Signal.new(),
	}, ScreenStack)
end

function ScreenStack:MakeCurrent(Target: Frame)
	if self.CurrentScreen == Target then
		return error("The current screen is already current")
	end

	if self.Stack:Contains(Target) == false then
		return error("Target must be in the stack")
	end

	if typeof(Target) == "ScreenGui" then
		--Target.DisplayOrder = self.CurrentScreen.DisplayOrder + 1
		Target.Parent = self.Container
	elseif type(Target) == "table" then
		--Target:SetProperty("DisplayOrder",self.CurrentScreen:GetProperty("DisplayOrder") + 1)
		Target:Mount(self.Container)
		Target:SetProperty("Visible", true)
		Target:SetProperty("ZIndex", 1)
	end

	self.OnPush:Fire(self.CurrentScreen, Target)
	self.CurrentScreen = Target
end

function ScreenStack:Push(Screen: Frame | Table)
	if self.CurrentScreen == Screen then
		return error("Cannot push the current screen to the stack")
	end

	self.Stack:Push(Screen)

	if self.CurrentScreen then
		print("current exists")
		self:Suspend(Screen)
		return
	end

	print("nope")
	self:MakeCurrent(Screen)
end

function ScreenStack:Suspend(Destination: Frame)
	if self.CurrentScreen == Destination then
		return error("The current screen cannot be the destination")
	end

	if self.CurrentScreen == nil then
		return error("There is no screen to suspend")
	end

	self.CurrentScreen:SetProperty("ZIndex", 0)
	self.OnSuspend:Fire(self.CurrentScreen, Destination)

	self:MakeCurrent(Destination)
end

function ScreenStack:Pop()
	if self.Stack.Size == 0 then
		return error("ScreenStack is empty")
	end

	if not self.CurrentScreen then
		return error("No currentscreen (?)")
	end
	local CalculatedSize = self.Stack.Size - 1

	if CalculatedSize >= 1 then
		self:Suspend(self.Stack.Items[1])
		self.Stack:Pop()
	else
		return error("Cannot pop due to size limitation")
	end
	--self:Push(self.Stack.Items[1])
end

function ScreenStack:Exit(Destination: Frame)
	if self.CurrentScreen == Destination then
		return error("The current screen cannot be the destination")
	end

	if self.CurrentScreen == nil then
		return error("There is no screen to exit from")
	end

	if self.Stack:Contains(Destination) == false then
		return error("Destination must be in the stack")
	end

	self.OnExit:Fire(self.CurrentScreen, Destination, self.FinishedSignal)
	--self.FinishedSignal:Wait()

	self:MakeCurrent(Destination)
end

return ScreenStack
