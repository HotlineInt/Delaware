local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Carbon = require(ReplicatedStorage:WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Assets = {
	[1] = "http://www.roblox.com/asset/?id=9739974376",
	[2] = "http://www.roblox.com/asset/?id=9739975071",
	[3] = "http://www.roblox.com/asset/?id=9739975642",
	[4] = "http://www.roblox.com/asset/?id=9739976234",
	[5] = "http://www.roblox.com/asset/?id=9739976772",
	[6] = "http://www.roblox.com/asset/?id=9739977254",
	[7] = "http://www.roblox.com/asset/?id=9739977929",
	[8] = "rbxassetid://9739978515",
	[9] = "rbxassetid://9739979092",
	[0] = "rbxassetid://9739979823",
}

local Display: SegmentDisplay = { Size = 35, Spacing = 14 }
Display.__index = Display

function Display.new()
	return setmetatable({}, Display)
end
function Display:Render()
	self.Display = CUI:CreateElement("Frame", {
		Name = "Segmenter",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[CUI.Children] = {
			CUI:CreateElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
			}),
		},
	})

	self.Display.Instance:SetAttribute("Size", self.Size)
	self.Display.Instance:SetAttribute("Spacing", self.Spacing)

	self.Display.Instance:GetAttributeChangedSignal("Size", function()
		print("FUCk")
		self:SetSize(self.Display.Instance:GetAttribute("Size"))
	end)

	self.Display.Instance:GetAttributeChangedSignal("Spacing", function()
		local Layout = self.Display.Instance:FindFirstChild("UIListLayout")
		self.Spacing = self.Display.Instance:GetAttribute("Spacing")
		Layout.Padding = UDim.new(0, self.Spacing)
	end)

	return self.Display
end

function Display:SetSize(number: number)
	--local Layout = self.Display.Instance:FindFirstChild("UIListLayout")
	if number <= 0 then
		number = 0
	end
	--Layout.Padding = UDim.new(0, 14 - -number)
	self.Size = number
end

function Display:SetNum(Number: number)
	local Display = self.Display
	for _, child in pairs(Display.Instance:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end

	for num in tostring(Number):gmatch("%d") do
		local Num = tonumber(num)
		local Image = CUI:CreateElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, self.Size, 0, self.Size),
			Image = Assets[Num],
			ImageColor3 = Color3.new(1, 1, 1),
		})
		Display:Add(Image)
	end
end

export type SegmentDisplay = {
	Display: table,
	SetNum: number,
	SetSize: number,
}

return Display
