-- Console - contact@shiroko.me - 2022/05/23
-- Description:
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local ConsoleComponent = require(script.Console)
local ConsoleLog = require(script.ConsoleLog)
local CUI = require(Packages.CUI)

local Playerlist = require(script.Parent.Playerlist)

local Console = {
	Holder = nil,
}

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

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.KeyCode == Enum.KeyCode.F2 then
			StarterGui:SetCore("TopbarEnabled", Enabled)
			Enabled = not Enabled
			Console:SetEnabled(Enabled)
		end
	end)

	self.ConsoleInput:On("FocusLost", function(self, EnterPressed: boolean)
		if EnterPressed then
			-- do some console magic
			print(string.format("> %s", self:GetProperty("Text")))
			self:SetProperty("Text", "")
			self.Instance:CaptureFocus()
			print("console bs here")
		end
	end)

	LogService.MessageOut:Connect(function(message, messageType)
		self:OnLog(messageType, message)
	end)

	self.Holder:Mount(Players.LocalPlayer.PlayerGui)
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

	Playerlist:SetEnabled(not Enabled)
	self.Holder:SetProperty("Enabled", Enabled)
end

return Console
