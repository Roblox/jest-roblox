-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll
local afterEach = JestGlobals.afterEach

local LuauPolyfill = require(Packages.LuauPolyfill)
local Symbol = LuauPolyfill.Symbol

local JestConfig = require(Packages.Dev.JestConfig)

local JestRuntime = require(CurrentModule)
type JestRuntime = JestRuntime.Runtime
type Jest = JestRuntime.Jest

local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

local _runtime: JestRuntime?

local function getRuntime(): JestRuntime
	assert(_runtime)
	return _runtime
end

beforeAll(function()
	_runtime = JestRuntime.new(JestConfig.projectDefaults)
end)

afterAll(function()
	getRuntime():teardown()
	_runtime = nil
end)

afterEach(function()
	_G[RETRY_TIMES] = nil
end)

describe("jest.retryTimes", function()
	it("is exposed on the jest object", function()
		local jestObject = (getRuntime() :: any)._jestObject
		expect(jestObject.retryTimes).toBeDefined()
		expect(typeof(jestObject.retryTimes)).toBe("function")
	end)

	it("returns the jest object for chaining", function()
		local jestObject = (getRuntime() :: any)._jestObject
		local result = jestObject.retryTimes(3)
		expect(result).toBe(jestObject)
	end)

	it("sets the retry count in _G so circus/run.lua can read it", function()
		local jestObject = (getRuntime() :: any)._jestObject
		expect(_G[RETRY_TIMES]).toBeNil()

		jestObject.retryTimes(3)

		expect(_G[RETRY_TIMES]).toBe(3)
	end)

	it("allows updating the retry count", function()
		local jestObject = (getRuntime() :: any)._jestObject

		jestObject.retryTimes(5)
		expect(_G[RETRY_TIMES]).toBe(5)

		jestObject.retryTimes(1)
		expect(_G[RETRY_TIMES]).toBe(1)
	end)

	it("accepts zero to disable retries", function()
		local jestObject = (getRuntime() :: any)._jestObject

		jestObject.retryTimes(3)
		jestObject.retryTimes(0)

		expect(_G[RETRY_TIMES]).toBe(0)
	end)

	it("clears the retry count on teardown", function()
		local runtime = JestRuntime.new(JestConfig.projectDefaults)
		local jestObject = (runtime :: any)._jestObject

		jestObject.retryTimes(3)
		expect(_G[RETRY_TIMES]).toBe(3)

		runtime:teardown()

		expect(_G[RETRY_TIMES]).toBeNil()
	end)
end)
