local TestFolder = script:WaitForChild("Tests")
local TestRunner = {}

local ResultMesssages = {
	SUCCESS = "Test %s completed successfully",
	FAILED = "Test %s failed, exception trace: %s",
	SKIPPED = "Test %s skipped because it took to long.",
	FINISHED_TESTS = "Completed running %d test(s)",
}

function TestRunner:Begin()
	local TestCount = #TestFolder:GetChildren()

	for _, Test in pairs(TestFolder:GetChildren()) do
		local TestFunction = require(Test)
		--local Envrionment = getfenv(TestFunction)
		local StartTime = os.time()

		local Result, Error = pcall(function()
			local Result = TestFunction()
			local EndTime = os.time()

			if EndTime - StartTime >= 10 then
				warn(string.format(ResultMesssages.SKIPPED, Test.Name))
				return nil
			end

			return Result
		end)

		if Result then
			print(string.format(ResultMesssages.SUCCESS, Test.Name))
		else
			warn(string.format(ResultMesssages.FAILED, Test.Name, Error .. "\n\n" .. debug.traceback()))
		end
	end

	print(string.format(ResultMesssages.FINISHED_TESTS, TestCount))
end

return TestRunner
