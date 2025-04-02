-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/__tests__/TestScheduler.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent
local Promise = require(Packages.Promise)
local JestGlobals = require(Packages.Dev.JestGlobals)

local afterEach = JestGlobals.afterEach

local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local test = JestGlobals.test

jest.mock(Packages.JestReporters, function()
	return {
		DefaultReporter = { new = jest.fn() },
		SummaryReporter = { new = jest.fn() },
		VerboseReporter = { new = jest.fn() },
		GitHubActionsReporter = { new = jest.fn() },
	}
end)

local jestReportersModule = require(Packages.JestReporters)
local DefaultReporter = jestReportersModule.DefaultReporter.new
local SummaryReporter = jestReportersModule.SummaryReporter.new
local VerboseReporter = jestReportersModule.VerboseReporter.new
local GitHubActionsReporter = jestReportersModule.GitHubActionsReporter.new

local jestTestUtilsModule = require(Packages.Dev.TestUtils)
local makeGlobalConfig = jestTestUtilsModule.makeGlobalConfig
local createTestScheduler = require(script.Parent.Parent.TestScheduler).createTestScheduler

-- ROBLOX deviation START: not used
-- local testSchedulerHelper = require(script.Parent.Parent.testSchedulerHelper)
-- jest.mock("@jest/reporters")
-- local mockSerialRunner = { isSerial = true, runTests = jest.fn() }
-- jest.mock("jest-runner-serial", function()
-- 	return jest.fn(function()
-- 		return mockSerialRunner
-- 	end)
-- end, { virtual = true })
-- local mockParallelRunner = { runTests = jest.fn() }
-- jest.mock("jest-runner-parallel", function()
-- 	return jest.fn(function()
-- 		return mockParallelRunner
-- 	end)
-- end, { virtual = true })
-- local spyShouldRunInBand = jest.spyOn(testSchedulerHelper, "shouldRunInBand")
-- beforeEach(function()
-- 	mockSerialRunner.runTests:mockClear()
-- 	mockParallelRunner.runTests:mockClear()
-- 	spyShouldRunInBand:mockClear()
-- end)
-- ROBLOX deviation END

describe("reporters", function()
	local CustomReporter = script.Parent.mock_CustomReporter
	local mockCustomReporter = {
		new = jest.fn(),
	}
	jest.mock(CustomReporter, function()
		return mockCustomReporter
	end)

	afterEach(function()
		jest.clearAllMocks()
	end)

	test("works with default value", function()
		return Promise.resolve():andThen(function()
			createTestScheduler({ reporters = nil } :: any, {} :: any):expect()
			expect(DefaultReporter).toBeCalledTimes(1)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(1)
		end)
	end)

	test("does not enable any reporters, if empty list is passed", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(makeGlobalConfig({ reporters = {} }), {}):expect()
			expect(DefaultReporter).toBeCalledTimes(0)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(0)
		end)
	end)

	test("sets up default reporters", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(makeGlobalConfig({ reporters = { { reporter = "default", options = {} } } }), {}):expect()
			expect(DefaultReporter).toBeCalledTimes(1)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(1)
		end)
	end)

	test("sets up verbose reporter", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(
				makeGlobalConfig({ reporters = { { reporter = "default", options = {} } }, verbose = true }),
				{}
			):expect()
			expect(DefaultReporter).toBeCalledTimes(0)
			expect(VerboseReporter).toBeCalledTimes(1)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(1)
		end)
	end)

	test("sets up github actions reporter", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(
				makeGlobalConfig({
					reporters = {
						{ reporter = "default", options = {} },
						{ reporter = "github-actions", options = {} },
					},
				}),
				{}
			):expect()
			expect(DefaultReporter).toBeCalledTimes(1)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(1)
			expect(SummaryReporter).toBeCalledTimes(1)
		end)
	end)

	test("allows enabling summary reporter separately", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(makeGlobalConfig({ reporters = { { reporter = "summary", options = {} } } }), {}):expect()
			expect(DefaultReporter).toBeCalledTimes(0)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(1)
		end)
	end)

	test("sets up custom reporter", function()
		return Promise.resolve():andThen(function()
			createTestScheduler(
				makeGlobalConfig({
					reporters = { { reporter = "default", options = {} }, { reporter = CustomReporter, options = {} } },
				}),
				{}
			):expect()
			expect(DefaultReporter).toBeCalledTimes(1)
			expect(VerboseReporter).toBeCalledTimes(0)
			expect(GitHubActionsReporter).toBeCalledTimes(0)
			expect(SummaryReporter).toBeCalledTimes(1)
			expect(mockCustomReporter.new).toBeCalledTimes(1)
		end)
	end)
end)

test(".addReporter() .removeReporter()", function()
	return Promise.resolve():andThen(function()
		local scheduler = createTestScheduler(makeGlobalConfig(), {} :: any):expect()
		local reporter = SummaryReporter.new()
		scheduler:addReporter(reporter)
		expect((scheduler :: any)._dispatcher._reporters).toContain(reporter)
		scheduler:removeReporter(SummaryReporter)
		expect((scheduler :: any)._dispatcher._reporters).never.toContain(reporter)
	end)
end)

-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("schedule tests run in parallel per default", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeFalsy()
-- 	end)
-- end)
test.skip("schedule tests run in parallel per default", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("schedule tests run in serial if the runner flags them", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(mockSerialRunner.runTests).toHaveBeenCalled()
-- 		expect(mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeTruthy()
-- 	end)
-- end)
test.skip("schedule tests run in serial if the runner flags them", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should bail after `n` failures", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					rootDir = "./",
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test }
-- 		local setState = jest.fn()
-- 		scheduler
-- 			:scheduleTests(tests, {
-- 				isInterrupted = jest.fn(),
-- 				isWatchMode = function()
-- 					return true
-- 				end,
-- 				setState = setState,
-- 			})
-- 			:expect()
-- 		mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		]
-- 			[
-- 				4 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			](
-- 				mockSerialRunner.runTests.mock.calls[
-- 					1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 				],
-- 				test,
-- 				{ numFailingTests = 2, snapshot = {}, testResults = { {} } }
-- 			)
-- 			:expect()
-- 		expect(setState).toBeCalledWith({ interrupted = true })
-- 	end)
-- end)
test.skip("should bail after `n` failures", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should not bail if less than `n` failures", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					rootDir = "./",
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test }
-- 		local setState = jest.fn()
-- 		scheduler
-- 			:scheduleTests(tests, {
-- 				isInterrupted = jest.fn(),
-- 				isWatchMode = function()
-- 					return true
-- 				end,
-- 				setState = setState,
-- 			})
-- 			:expect()
-- 		mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		]
-- 			[
-- 				4 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			](
-- 				mockSerialRunner.runTests.mock.calls[
-- 					1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 				],
-- 				test,
-- 				{ numFailingTests = 1, snapshot = {}, testResults = { {} } }
-- 			)
-- 			:expect()
-- 		expect(setState)["not"].toBeCalled()
-- 	end)
-- end)
test.skip("should not bail if less than `n` failures", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should set runInBand to run in serial", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		spyShouldRunInBand:mockReturnValue(true)
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(spyShouldRunInBand).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeTruthy()
-- 	end)
-- end)
test.skip("should set runInBand to run in serial", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should set runInBand to not run in serial", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		spyShouldRunInBand:mockReturnValue(false)
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(spyShouldRunInBand).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeFalsy()
-- 	end)
-- end)
test.skip("should set runInBand to not run in serial", function() end)
-- ROBLOX deviation END
