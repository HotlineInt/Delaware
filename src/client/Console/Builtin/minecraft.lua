local Frequency = 64
local ChunkSize = 64

return {
	Name = "minecraft",
	Description = "fuck u vscode for not saving my garbage",
	Execute = function(Runner: Player, Arguments: table)
		for x = 1, ChunkSize, 1 do
			for y = 1, ChunkSize, 1 do
				for z = 1, ChunkSize, 1 do
					local X, Y, Z =
						math.noise(x / Frequency, y / Frequency, z / Frequency),
						math.noise(x / Frequency, y / Frequency, z / Frequency),
						math.noise(x / Frequency, y / Frequency, z / Frequency)

					X = (X + 1) / 2
					Y = (Z + 1) / 2
					Z = (Z + 1) / 2
					print(X, Y, Z)

					task.wait()
				end
			end
		end
	end,
}
