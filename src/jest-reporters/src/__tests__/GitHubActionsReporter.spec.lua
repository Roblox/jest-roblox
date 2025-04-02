-- ROBLOX upstream: https://github.com/jestjs/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/GitHubActionsReporter.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local test = JestGlobals.it
local jest = JestGlobals.jest
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set

local Writeable = require(Packages.RobloxShared).Writeable

local process = {
	env = {},
	stderr = Writeable.new(),
}
local globalConfig = { rootDir = "root", watch = false }

local GitHubActionsReporter
local write = process.stderr.write
local results = {}

local function requireReporter()
	jest.isolateModules(function()
		GitHubActionsReporter = require(CurrentModule.GitHubActionsReporter).default
	end)
end

beforeEach(function()
	process.stderr.write = function(_self: any, result)
		return table.insert(results, result)
	end
end)

afterEach(function()
	results = {}
	process.stderr.write = write
end)

local aggregatedResults = {
	numPassedTests = 0,
	numPendingTestSuites = 0,
	numFailedTests = 1,
	numFailedTestSuites = 1,
	numPassedTestSuites = 0,
	snapshot = {
		total = 0,
		filesAdded = 0,
		filesRemovedList = {},
		updated = 0,
		added = 0,
		failure = false,
		unchecked = 0,
		filesUpdated = 0,
		unmatched = 0,
		filesUnmatched = 0,
		filesRemoved = 0,
		uncheckedKeysByFile = {},
		didUpdate = false,
		matched = 0,
	},
	testResults = {
		{
			leaks = false,
			perfStats = {},
			skipped = false,
			numFailingTests = 1,
			openHandles = {},
			testResults = {
				{
					failureMessages = {
						[[Error: [2mexpect([22m[31mreceived[39m[2m).[22mtoEqual[2m([22m[32mexpected[39m[2m) -- deep equality[22m
		
		Expected: [32m"b"[39m
		Received: [31m"a"[39m
		LoadedCode.JestRoblox._Workspace.JestReporters.JestReporters.__tests__.some.spec:9
		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369
		LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
		LoadedCode.JestRoblox._Index.Promise.Promise:299]],
					},
					failureDetails = {},
					numPassingAsserts = 0,
					duration = 0,
					ancestorTitles = {},
					invocations = 1,
					status = "failed",
					fullName = "asserts that a === b",
					retryReasons = {},
					title = "asserts that a === b",
				},
			},
			snapshot = {
				updated = 0,
				unmatched = 0,
				fileDeleted = false,
				uncheckedKeys = {},
				unchecked = 0,
				added = 0,
				matched = 0,
			},
			testFilePath = "/Users/rng/jest-roblox/src/jest-reporters/src/__tests__/some.spec.lua",
			numTodoTests = 0,
			numPendingTests = 0,
			numPassingTests = 0,
			failureMessage = "",
		},
	},
	startTime = 0,
	openHandles = {},
	numTotalTests = 1,
	success = false,
	numTotalTestSuites = 1,
	numRuntimeErrorTestSuites = 0,
	numPendingTests = 0,
	numTodoTests = 0,
	wasInterrupted = false,
}

test("reporter extracts the correct filename and line", function()
	requireReporter()
	local testReporter = GitHubActionsReporter.new(globalConfig, process)

	testReporter:onRunComplete(Set.new(), aggregatedResults)
	expect(Array.join(results, "")).toMatchSnapshot()
end)
