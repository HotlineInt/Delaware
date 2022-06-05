local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local CUI = require(Carbon.UI.CUI)

local Player = Carbon:GetPlayer()
local Mouse = Player:GetMouse()

return function(Props: {})
	local Surface: SurfaceGui = Props.Surface
	-- make a cursor
	local Cursor = CUI:CreateElement("ImageLabel", {
		Name = "Cursor",
		Image = "rbxassetid://7089109742",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(0, 0, 0, 0),
		ScaleType = Enum.ScaleType.Fit,
		ResampleMode = Enum.ResamplerMode.Pixelated,
	})

	Mouse.Move:Connect(function()
		local MouseX, MouseY = Mouse.X, Mouse.Y
		local Localized = Vector2.new(MouseX, MouseY) / Surface.AbsolutePosition
		Cursor:SetProperty("Position", UDim2.new(0, Localized.X, 0, Localized.Y))
	end)

	return Cursor
end
