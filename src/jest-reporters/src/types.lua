-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/types.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

type void = nil

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>
type Error = LuauPolyfill.Error
type Promise<T> = LuauPolyfill.Promise<T>
type Set<T> = LuauPolyfill.Set<T>

local exports = {}

local testResultModule = require(Packages.JestTestResult)
type AggregatedResult = testResultModule.AggregatedResult
type Test = testResultModule.Test
type TestCaseResult = testResultModule.TestCaseResult
type TestContext = testResultModule.TestContext
type TestResult = testResultModule.TestResult

local jestTypesModule = require(Packages.JestTypes)
type Config_Path = jestTypesModule.Config_Path
type Config_ProjectConfig = jestTypesModule.Config_ProjectConfig
type Config_GlobalConfig = jestTypesModule.Config_GlobalConfig

-- ROBLOX deviation START: any types that aren't ported and we don't need
-- local jest_haste_mapModule = require(Packages["jest-haste-map"])
type HasteFS = any
type ModuleMap = any

-- local jest_resolveModule = require(Packages["jest-resolve"])
type Resolver = any

-- local CoverageWorkerModule = require(CurrentModule.CoverageWorker)
-- type worker = CoverageWorkerModule.worker
type worker = any
-- ROBLOX deviation END

-- ROBLOX deviation START: type for mock process param used added to Reporters
local RobloxShared = require(Packages.RobloxShared)
type Writeable = RobloxShared.Writeable
export type NodeProcessMock = {
	env: {
		[string]: unknown,
	},
	stdout: Writeable,
	stderr: Writeable,
}
-- ROBLOX deviation END

export type ReporterOnStartOptions = { estimatedTime: number, showStatus: boolean }

export type CoverageWorker = { worker: worker }

export type Reporter = {
	onTestResult: ((
		self: Reporter,
		test: Test,
		testResult: TestResult,
		aggregatedResult: AggregatedResult
	) -> Promise<void> | void)?,
	onTestFileResult: ((
		self: Reporter,
		test: Test,
		testResult: TestResult,
		aggregatedResult: AggregatedResult
	) -> Promise<void> | void)?,
	onTestCaseResult: ((self: Reporter, test: Test, testCaseResult: TestCaseResult) -> Promise<void> | void)?,
	onRunStart: (self: Reporter, results: AggregatedResult, options: ReporterOnStartOptions) -> Promise<void> | void,
	onTestStart: ((self: Reporter, test: Test) -> Promise<void> | void)?,
	onTestFileStart: ((self: Reporter, test: Test) -> Promise<void> | void)?,
	onRunComplete: (self: Reporter, testContexts: Set<TestContext>, results: AggregatedResult) -> Promise<void> | void,
	getLastError: (self: Reporter) -> Error | void,
}

export type ReporterContext = {
	firstRun: boolean,
	previousSuccess: boolean,
	changedFiles: Set<Config_Path>?,
	sourcesRelatedToTestsInChangedFiles: Set<Config_Path>?,
	startRun: ((globalConfig: Config_GlobalConfig) -> unknown)?,
}

export type SummaryOptions = {
	currentTestCases: Array<{ test: Test, testCaseResult: TestCaseResult }>?,
	estimatedTime: number?,
	roundTime: boolean?,
	width: number?,
}

return exports
