-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/index.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local exports = {}

local CurrentModule = script
local Packages = CurrentModule.Parent
local testResultModule = require(Packages.JestTestResult)
type Test = testResultModule.Test
type TestCaseResult = testResultModule.TestCaseResult
type TestContext = testResultModule.TestContext

local getResultHeader = require(script.getResultHeader).default
local getSnapshotStatus = require(script.getSnapshotStatus).default
local getSnapshotSummary = require(script.getSnapshotSummary).default

local utilsModule = require(script.utils)
local formatTestPath = utilsModule.formatTestPath
local getSummary = utilsModule.getSummary
local printDisplayName = utilsModule.printDisplayName
local relativePath = utilsModule.relativePath
local trimAndFormatPath = utilsModule.trimAndFormatPath

local BaseReporterModule = require(script.BaseReporter)
exports.BaseReporter = BaseReporterModule.default
export type BaseReporter = BaseReporterModule.BaseReporter

local DefaultReporterModule = require(script.DefaultReporter)
exports.DefaultReporter = DefaultReporterModule.default
export type DefaultReporter = DefaultReporterModule.DefaultReporter

local GitHubActionsReporterModule = require(script.GitHubActionsReporter)
exports.GitHubActionsReporter = GitHubActionsReporterModule.default
export type GitHubActionsReporter = GitHubActionsReporterModule.GitHubActionsReporter

local SummaryReporterModule = require(script.SummaryReporter)
exports.SummaryReporter = SummaryReporterModule.default
export type SummaryReporter = SummaryReporterModule.SummaryReporter

local VerboseReporterModule = require(script.VerboseReporter)
exports.VerboseReporter = VerboseReporterModule.default
export type VerboseReporter = VerboseReporterModule.VerboseReporter

local typesModule = require(script.types)
export type Reporter = typesModule.Reporter
export type ReporterOnStartOptions = typesModule.ReporterOnStartOptions
export type ReporterContext = typesModule.ReporterContext
export type SummaryOptions = typesModule.SummaryOptions

local utils = {
	formatTestPath = formatTestPath,
	getResultHeader = getResultHeader,
	getSnapshotStatus = getSnapshotStatus,
	getSnapshotSummary = getSnapshotSummary,
	getSummary = getSummary,
	printDisplayName = printDisplayName,
	relativePath = relativePath,
	trimAndFormatPath = trimAndFormatPath,
}

exports.utils = utils

return exports
