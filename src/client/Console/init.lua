-- Console - contact@shiroko.me - 2022/05/23
-- Description:
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ConsoleComponent = require(script.Console)
local ConsoleLog = require(script.ConsoleLog)
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local autoexec = script:FindFirstChild("autoexec")
if autoexec then
	autoexec = autoexec.Value
end

local Console = {
	Holder = nil,
	Commands = {},
}

function Console:ExecuteCommand(Name: string, Arguments: table)
	for _, Command in pairs(Console.Commands) do
		if Command.Name == Name then
			Command:Execute(Players.LocalPlayer, Arguments)
			return true
		end
	end

	warn("Invalid command provided.")
	return false
end

function Console:Load()
	self.Holder = CUI:CreateElement("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Enabled = false,
	})
	self.ConsoleFrame = self.Holder:Add(ConsoleComponent())
	self.LogFrame = self.ConsoleFrame:Get("Logs")
	self.ConsoleInput = self.ConsoleFrame:Get("ConsoleInput")

	local Enabled = false

	for _, Command in pairs(script.Builtin:GetChildren()) do
		table.insert(self.Commands, require(Command))
	end

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.KeyCode == Enum.KeyCode.F2 then
			StarterGui:SetCore("TopbarEnabled", Enabled)
			Enabled = not Enabled
			Console:SetEnabled(Enabled)
		elseif Input.KeyCode == Enum.KeyCode.Tab then
			local CurrentInput = self.ConsoleInput:GetProperty("Text")

			-- ! This could be quite slow !!
			local MatchingCommand = self:MatchingCommand(CurrentInput)

			if MatchingCommand then
				self.ConsoleInput:SetProperty("Text", MatchingCommand.Name)
				self.ConsoleInput:SetProperty("CursorPosition", MatchingCommand.Name:len())
				self.ConsoleInput:SetProperty("Text", self.ConsoleInput:GetProperty("Text"):gsub("\t", ""))
				return
			end
		end
	end)

	self.ConsoleInput:On("FocusLost", function(self, EnterPressed: boolean)
		if EnterPressed then
			-- do some console magic
			-- roblox-garbage-string-implementation sanitization
			local InputCommand = self:GetProperty("Text")
			-- (%s) is for whitespace detection
			if string.match(InputCommand:sub(1, 1), "(%s)") then
				InputCommand = InputCommand:sub(2, string.len(InputCommand))
			end

			self.Instance:CaptureFocus()
			self.Instance.Text = ""

			print(string.format("> %s", InputCommand))
			Console:ExecuteCommand(InputCommand, {})
		end
	end)

	print("Executing autoexec")

	for command in autoexec:gmatch("[^\n].*$") do
		print("> " .. command)
		Console:ExecuteCommand(command, {})
	end

	LogService.MessageOut:Connect(function(message, messageType)
		self:OnLog(messageType, message)
	end)

	self.Holder:Mount(Players.LocalPlayer.PlayerGui)
end

function Console:MatchingCommand(Input: string)
	for _, Command in pairs(self.Commands) do
		if string.find(Command.Name, Input) then
			return Command.Name
		end
	end
end

function Console:OnLog(Type: Enum, Message: string)
	self.LogFrame:Add(ConsoleLog({
		InfoType = Type,
		Message = Message,
	}))
	self.LogFrame:SetProperty("CanvasPosition", self.LogFrame:GetProperty("AbsoluteCanvasSize"))
end

function Console:SetEnabled(Enabled: boolean)
	local ConsoleInput: TextBox = self.ConsoleInput.Instance

	if Enabled then
		ConsoleInput:CaptureFocus()
	else
		ConsoleInput:ReleaseFocus(false)
	end

	--Playerlist:SetEnabled(not Enabled)
	self.Holder:SetProperty("Enabled", Enabled)
end

return Console
