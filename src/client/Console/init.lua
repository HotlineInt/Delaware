-- Console - contact@shiroko.me - 2022/05/23
-- Description:
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local ConsoleComponent = require(script.Console)
local ConsoleLog = require(script.ConsoleLog)
local CUI = require(Packages.CUI)

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

	local Enabled = false

	UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.KeyCode == Enum.KeyCode.F2 then
			Enabled = not Enabled
			Console:SetEnabled(Enabled)
		end
	end)

	LogService.MessageOut:Connect(function(message, messageType)
		self:OnLog(messageType, message)
	end)

	self.Holder:Mount(Players.LocalPlayer.PlayerGui)
end

function Console:OnLog(Type: Enum, Message: string)
	self.ConsoleFrame:Add(ConsoleLog({
		InfoType = Type,
		Message = Message,
	}))
end

function Console:SetEnabled(Enabled: boolean)
	self.Holder:SetProperty("Enabled", Enabled)
end

return Console
