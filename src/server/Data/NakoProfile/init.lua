local NakoProfile = {
	Templates = {
		Player = {
			Cash = 0,
			Bank = 300,
			Tags = {},
			BanData = {
				Banned = false,
				Time = 0,
				Reason = "",
				Perm = false,
			},
		},
	},
	Stores = {},
}

local Store = require(script.Store)

function NakoProfile:MakeStore(Name: string, Template: {}): {}
	if self.Stores[Name] then
		return self.Stores[Name]
	end

	local Store = Store.new(Name, Template)
	self.Stores[Name] = Store

	return Store
end

function NakoProfile:GetStore(Name: string): {} | nil
	local Store = self.Stores[Name]

	if Store == nil then
		error(string.format("There is no store with such name: %s", Name))
	end

	print(Store)

	return Store
end

return NakoProfile
