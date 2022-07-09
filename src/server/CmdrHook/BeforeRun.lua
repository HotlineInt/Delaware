local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local Knit = require(Carbon.Framework.Knit)

local TagService = Knit:GetService("TagService")

local CmdrAccessTags = {
	"tag_mod",
	"tag_developer",
	"tag_private",
}

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		local PlayerTags: { string } = TagService:GetTags()
		local Pass = false

		for _, Tag in pairs(PlayerTags) do
			if table.find(CmdrAccessTags, Tag) then
				Pass = true
			end
		end

		if not Pass then
			return "Cmdr access is locked to people with good tags."
		end
	end)
end
