local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)

local TagService = Knit:GetService("TagService")
local RunService = game:GetService("RunService")

local CmdrAccessTags = {
	"tag_mod",
	"tag_developer",
	"tag_private",
}

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		if RunService:IsClient() then
			local Resolved, PlayerTags = TagService:GetTags():await()

			if not Resolved then
				return "Fatal exception: TagService unavailable"
			end

			local Pass = false

			for _, Tag in ipairs(PlayerTags) do
				-- print(Tag, _)
				if table.find(CmdrAccessTags, Tag) then
					Pass = true
				end
			end

			if not Pass then
				return "Cmdr access is locked to people with good tags."
			end
		end
	end)
end
