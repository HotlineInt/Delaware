local Carbon = require(game:GetService("ReplicatedStorage"):WaitForChild("Carbon"))
local ProfileService = require(Carbon.Data.ProfileService)

local Store = { Name = nil, Template = {}, Profiles = {} }
Store.__index = Store

function Store.new(Name: string, Template: {})
	local ProfileStore = ProfileService.GetProfileStore(Name, Template)
	return setmetatable({ Name = Name, Template = Template, Store = ProfileStore }, Store)
end

function Store:LoadProfile(Key: string)
	Key = tostring(Key)
	local Profile = self.Store:LoadProfileAsync(Key)

	if Profile ~= nil then
		-- Fill in missing template variables
		-- "SyncWithTemplate" or "Sync" would be a better name for this..
		Profile:Reconcile()

		self.Profiles[Key] = Profile
	end

	return Profile
end

function Store:GetProfile(Key: string)
	Key = tostring(Key)
	local Profile = self.Profiles[Key]

	if not Profile then
		Profile = self:LoadProfile(Key)
	end

	return Profile
end

function Store:ReleaseProfile(Key: string)
	Key = tostring(Key)
	local Profile = self.Profiles[Key]

	if Profile then
		Profile:Release()
		self.Profiles[Key] = nil
	end
end

return Store
