-- taken from: https://devforum.roblox.com/t/how-do-you-visualize-a-raycast-as-a-part/657972/5
-- modified by Haruka

return function(Origin: Vector3, Position: Vector3): BasePart
	local Distance = (Origin - Position).Magnitude
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.CanCollide = false
	Part.Size = Vector3.new(0.1, 0.1, Distance)
	Part.Parent = workspace
	Part.CanQuery = false
	Part.CanTouch = false
	Part.CFrame = CFrame.lookAt(Origin, Position) * CFrame.new(0, 0, -Distance / 2)
end
