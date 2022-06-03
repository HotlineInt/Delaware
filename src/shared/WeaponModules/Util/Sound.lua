local SoundUtil = {}

function SoundUtil:CreateErrorSound(Name: string, Parent: Instance)
	local Sound: Sound = Instance.new("Sound")
	Sound.Name = Name
	Sound.Parent = Parent
	Sound.SoundId = "rbxassetid://5048077804"

	return Sound
end

function SoundUtil:CreatePlaceholderSound(Name: string, SoundsFolder: Folder)
	if not SoundsFolder:FindFirstChild(Name) then
		SoundUtil:CreateErrorSound(Name, SoundsFolder)
	end
end

return SoundUtil
