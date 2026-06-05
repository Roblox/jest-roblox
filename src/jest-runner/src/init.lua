-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-runner/src/index.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local Packages = script.Parent

local Promise = require(Packages.Promise)

local emitteryModule = require(Packages.Emittery)
local Emittery = emitteryModule.default
type Emittery = emitteryModule.Emittery
type Emittery_UnsubscribeFn = emitteryModule.Emittery_UnsubscribeFn

local throat = require(Packages.Throat)
type ThroatLateBound<TResult, TArgs> = throat.ThroatLateBound<TResult, TArgs>
local test_resultModule = require(Packages.JestTestResult)
export type Test = test_resultModule.Test
export type TestEvents = test_resultModule.TestEvents
export type TestFileEvent = test_resultModule.TestFileEvent
type TestResult = test_resultModule.TestResult
local jestTypesModule = require(Packages.JestTypes)
type Promise<T> = jestTypesModule.Promise<T>
type Config_GlobalConfig = jestTypesModule.Config_GlobalConfig
local Error = jestTypesModule.Error
type Error = jestTypesModule.Error
local deepCyclicCopy = require(Packages.JestUtil).deepCyclicCopy
local runTest = require(script.runTest)

local typesModule = require(script.types)
export type OnTestFailure = typesModule.OnTestFailure
export type OnTestStart = typesModule.OnTestStart
export type OnTestSuccess = typesModule.OnTestSuccess
export type TestWatcher = typesModule.TestWatcher
export type TestRunnerContext = typesModule.TestRunnerContext
export type TestRunnerOptions = typesModule.TestRunnerOptions

local CancelRun

export type TestRunner = {
	new: (globalConfig: Config_GlobalConfig, context: TestRunnerContext?) -> TestRunner,

	__PRIVATE_UNSTABLE_API_supportsEventEmitters__: boolean,
	isSerial: boolean,
	runTests: (
		self: TestRunner,
		tests: { Test },
		watcher: TestWatcher,
		onStart: OnTestStart | nil,
		onResult: OnTestSuccess | nil,
		onFailure: OnTestFailure | nil,
		options: TestRunnerOptions
	) -> Promise<nil>,
	on: <Name>(
		self: TestRunner,
		eventName: Name,
		listener: (eventData: any) -> ...any
	) -> Emittery_UnsubscribeFn,

	_globalConfig: Config_GlobalConfig,
	_context: TestRunnerContext,
	_loadedModuleFns: any,
	cleanup: (self: TestRunner) -> (),
	eventEmitter: Emittery,
	_createInBandTestRun: (
		self: TestRunner,
		tests: { Test },
		watcher: TestWatcher,
		onStart: OnTestStart?,
		onResult: OnTestSuccess?,
		onFailure: OnTestFailure?
	) -> Promise<nil>,
	_createParallelTestRun: (
		self: TestRunner,
		tests: { Test },
		watcher: TestWatcher,
		onStart: OnTestStart?,
		onResult: OnTestSuccess?,
		onFailure: OnTestFailure?
	) -> Promise<nil>,
}

local TestRunner = {} :: TestRunner;
(TestRunner :: any).__index = TestRunner

function TestRunner.new(globalConfig: Config_GlobalConfig, context: TestRunnerContext?): TestRunner
	local self = setmetatable({}, TestRunner)
	self.eventEmitter = Emittery.new()
	self.__PRIVATE_UNSTABLE_API_supportsEventEmitters__ = true
	self._globalConfig = globalConfig
	self._context = context or {}
	self._loadedModuleFns = {}
	return (self :: any) :: TestRunner
end

function TestRunner:runTests(
	tests: { Test },
	watcher: TestWatcher,
	onStart: OnTestStart | nil,
	onResult: OnTestSuccess | nil,
	onFailure: OnTestFailure | nil,
	options: TestRunnerOptions
)
	return Promise.resolve():andThen(function()
		return (
			if options.serial
				then self:_createInBandTestRun(tests, watcher, onStart, onResult, onFailure):expect()
				else self:_createParallelTestRun(tests, watcher, onStart, onResult, onFailure):expect()
		)
	end)
end
function TestRunner:_createInBandTestRun(
	tests: { Test },
	watcher: TestWatcher,
	onStart: OnTestStart?,
	onResult: OnTestSuccess?,
	onFailure: OnTestFailure?
)
	return Promise.resolve():andThen(function()
		local mutex = throat(1) :: ThroatLateBound<nil, nil>
		local promise = Promise.resolve()
		for _, test in tests do
			local currentPromise = promise
			promise = mutex(function()
				return (currentPromise :: any)
					:andThen(function()
						return Promise.resolve():andThen(function()
							if watcher:isInterrupted() then
								error(CancelRun.new())
							end
							local sendMessageToJest

							if onStart ~= nil then
								onStart(test):expect()
								return runTest(
									test.script,
									self._globalConfig,
									test.context.config,
									nil,
									self._context,
									nil,
									self._loadedModuleFns
								)
							else
								sendMessageToJest = function(eventName: string, args)
									return self.eventEmitter:emit(
										eventName,
										deepCyclicCopy(args, { keepPrototype = false })
									)
								end
								self.eventEmitter:emit("test-file-start", { test }):expect()
								return runTest(
									test.script,
									self._globalConfig,
									test.context.config,
									nil,
									self._context,
									sendMessageToJest,
									self._loadedModuleFns
								)
							end
						end)
					end)
					:andThen(function(result: TestResult)
						if onResult ~= nil then
							return onResult(test, result)
						else
							return self.eventEmitter:emit("test-file-success", { test :: any, result })
						end
					end)
					:catch(function(err)
						if onFailure ~= nil then
							return onFailure(test, err)
						else
							return self.eventEmitter:emit("test-file-failure", { test :: any, err })
						end
					end)
			end)
		end
		return promise
	end)
end

function TestRunner:_createParallelTestRun(
	tests: { Test },
	watcher: TestWatcher,
	onStart: OnTestStart?,
	onResult: OnTestSuccess?,
	onFailure: OnTestFailure?
)
	return Promise.resolve():andThen(function()
		warn("Parallel tests run not implemented yet\nRunning tests in band instead")
		return self:_createInBandTestRun(tests, watcher, onStart, onResult, onFailure)
	end)
end

function TestRunner:on<Name>(eventName: Name, listener: (eventData: any) -> () | any): Emittery_UnsubscribeFn
	return self.eventEmitter:on(eventName, listener)
end

function TestRunner:cleanup()
	for _, val in self._loadedModuleFns do
		local cleanup = val[3]
		if cleanup ~= nil then
			cleanup()
		end
	end
end

type CancelRun = Error & {}
CancelRun = setmetatable({}, { __index = Error })
CancelRun.__index = CancelRun
function CancelRun.new(message: string?): CancelRun
	local self = setmetatable(Error.new(message), CancelRun)
	self.name = "CancelRun"
	return (self :: any) :: CancelRun
end

return TestRunner
