--- Wrapper for unit tests run using the Telescope (https://github.com/norman/telescope)
-- unit testing framework.
-- Tests are run from within coroutine which allows for async
-- tests to be written (refer to the http test for an example).
--
-- @usage
--
--	local deftest = require "deftest.deftest"
--	local some_tests = require "test.some_tests"
--	local other_tests = require "test.other_tests"
--
--	function init(self)
--		deftest.add(some_tests, other_tests)
--		deftest.run()
--	end
--

require "deftest.coxpcall"
local telescope = require "deftest.telescope"

local M = {}

local contexts = {}

--- Add one or more sets of tests
-- Each set of tests must be wrapped in a function
function M.add(...)
	local args = {...}
	for _,test in ipairs(args) do
		telescope.load_contexts(test, contexts)
	end
end

--- Run all tests added via @{add}
-- The engine will shut down with an exit code indicating success or
-- failure and the test reports will be written to console. 
function M.run()
	local co = coroutine.create(function()
		local callbacks = {}
		local test_pattern = nil
		local results = telescope.run(contexts, callbacks, test_pattern)
		local summary, data = telescope.summary_report(contexts, results)
		local test_report = telescope.test_report(contexts, results)
		local error_report = telescope.error_report(contexts, results)
		print(summary)
		print(test_report)
		print(error_report)
	
		for _, v in pairs(results) do
			if v.status_code == telescope.status_codes.err or
				v.status_code == telescope.status_codes.fail then
				os.exit(1)
			end
		end
		os.exit(0)
	end)
	
	local ok, message = coroutine.resume(co)
	if not ok then
		print("Something went wrong while running tests", message)
		os.exit(1)
	end
end


return M