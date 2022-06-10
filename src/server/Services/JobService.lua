local EconomyService = require(script.Parent.EconomyService)
local JobService = {
	Name = "JobService",
	Client = {},
	PlayersInJobs = {},
	JobInfo = require(script.Parent.EconomyService.JobInfo),
}

function JobService:KnitInit()
	-- Create a data table
	for Job, _ in pairs(JobService.JobInfo) do
		self.PlayersInJobs[Job] = {}
	end

	-- Award players money
	task.spawn(function()
		while task.wait(10) do
			for Name, Job in pairs(self.PlayersInJobs) do
				local Info = self.JobInfo[Name]

				for _, Player in pairs(Job) do
					local UserProfile = EconomyService:GetUserProfile(Player)

					if UserProfile then
						UserProfile.Data.Bank += Info.Money
						print("Awarded", Player, "$" .. Info.Money, "for working as a", Name)
					end
				end
			end
		end
	end)
end

-- Checks if the job has reached a limit for players.
function JobService:IsLimitReached(Job)
	local JobInfo = self.JobInfo[Job]
	local Limit = JobInfo.PlayerLimit

	local PlayersInJob = #self.PlayersInJobs[Job]

	if not Limit == 0 then
		return PlayersInJob > Limit
	else
		-- 0 means infinite.
		return false
	end
end

function JobService:CanPlayerJoinJobs(Player: Player)
	for _, Job in pairs(self.PlayersInJobs) do
		for _, PlayerJ in pairs(Job) do
			if PlayerJ == Player then
				return false
			end
		end
	end

	return true
end

function JobService.Client:JoinJob(Player: Player, Job: string)
	if not JobService:CanPlayerJoinJobs(Player) then
		return "You're already in a job. Please leave one and then try again."
	end
	local JobInfo = self.Server.JobInfo[Job]

	if JobInfo then
		local UserProfile = EconomyService:GetUserProfile(Player)

		if UserProfile then
			if JobService:IsLimitReached(Job) then
				return "Limit reached. Please try again later."
			end

			--UserProfile.Data.Job = Job

			table.insert(self.Server.PlayersInJobs[Job], Player)

			return "Success: You are now working as a " .. Job
		end
	end
end

function JobService.Client:LeaveJob(Player: Player, Job: string)
	local JobInfo = self.Server.JobInfo[Job]
	local UserProfile = EconomyService:GetUserProfile(Player)

	if JobInfo and UserProfile then
		UserProfile.Data.Job = "Unemployed"
		for _, Job in pairs(self.PlayersInJobs) do
			for Index, PlayerJ in pairs(Job) do
				if PlayerJ == Player then
					Job[Index] = nil
				end
			end
		end

		return "Success: You are now unemployed."
	end
end

return JobService
