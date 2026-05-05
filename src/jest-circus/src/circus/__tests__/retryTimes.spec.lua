-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Symbol = LuauPolyfill.Symbol

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local test = JestGlobals.test
local afterEach = JestGlobals.afterEach

local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

local runTest = require(script.Parent.Parent.__mocks__.testUtils).runTest

local function countOccurrences(text: string, pattern: string): number
	local _, count = string.gsub(text, pattern, "")
	return count
end

local loadModuleEnabled = pcall((debug :: any).loadmodule, Instance.new("ModuleScript"))
if not loadModuleEnabled then
	test = test.skip :: any
end

afterEach(function()
	_G[RETRY_TIMES] = nil
end)

test("retries a failing test when retryTimes is set", function()
	local stdout = runTest([[
		local LuauPolyfill = require(script_.Parent.Parent.Parent.Parent.LuauPolyfill)
		local Symbol = LuauPolyfill.Symbol
		local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

		_G[RETRY_TIMES] = 2

		local attempts = 0

		describe("retry", function()
			test("fails then passes", function()
				attempts = attempts + 1
				if attempts < 3 then
					error(Error.new("not yet"))
				end
			end)
		end)
	]]).stdout

	expect(countOccurrences(stdout, "test_retry: fails then passes")).toBe(2)
	expect(countOccurrences(stdout, "test_fn_failure: fails then passes")).toBe(2)
	expect(countOccurrences(stdout, "test_fn_success: fails then passes")).toBe(1)
	expect(stdout).toContain("unhandledErrors: 0")
end)

test("does not retry when retryTimes is 0", function()
	local stdout = runTest([[
		local LuauPolyfill = require(script_.Parent.Parent.Parent.Parent.LuauPolyfill)
		local Symbol = LuauPolyfill.Symbol
		local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

		_G[RETRY_TIMES] = 0

		describe("no retry", function()
			test("fails immediately", function()
				error(Error.new("always fails"))
			end)
		end)
	]]).stdout

	expect(countOccurrences(stdout, "test_retry: fails immediately")).toBe(0)
	expect(countOccurrences(stdout, "test_fn_failure: fails immediately")).toBe(1)
	expect(countOccurrences(stdout, "test_fn_success: fails immediately")).toBe(0)
	expect(stdout).toContain("unhandledErrors: 0")
end)

test("stops retrying after exhausting retries", function()
	local stdout = runTest([[
		local LuauPolyfill = require(script_.Parent.Parent.Parent.Parent.LuauPolyfill)
		local Symbol = LuauPolyfill.Symbol
		local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

		_G[RETRY_TIMES] = 1

		describe("exhausted retries", function()
			test("always fails", function()
				error(Error.new("permanent failure"))
			end)
		end)
	]]).stdout

	expect(countOccurrences(stdout, "test_retry: always fails")).toBe(1)
	expect(countOccurrences(stdout, "test_fn_failure: always fails")).toBe(2)
	expect(countOccurrences(stdout, "test_fn_success: always fails")).toBe(0)
	expect(stdout).toContain("unhandledErrors: 0")
end)

test("only retries tests that failed, not passing ones", function()
	local stdout = runTest([[
		local LuauPolyfill = require(script_.Parent.Parent.Parent.Parent.LuauPolyfill)
		local Symbol = LuauPolyfill.Symbol
		local RETRY_TIMES = Symbol.for_("RETRY_TIMES")

		_G[RETRY_TIMES] = 2

		local passCount = 0

		describe("mixed", function()
			afterAll(function()
				console.log("passCount:", passCount)
			end)

			test("passes first time", function()
				passCount = passCount + 1
			end)

			test("always fails", function()
				error(Error.new("nope"))
			end)
		end)
	]]).stdout

	expect(countOccurrences(stdout, "test_retry: passes first time")).toBe(0)
	expect(countOccurrences(stdout, "test_fn_success: passes first time")).toBe(1)
	expect(countOccurrences(stdout, "passCount: 1")).toBe(1)
	expect(countOccurrences(stdout, "test_retry: always fails")).toBe(2)
	expect(countOccurrences(stdout, "test_fn_failure: always fails")).toBe(3)
	expect(countOccurrences(stdout, "test_fn_success: always fails")).toBe(0)
	expect(stdout).toContain("unhandledErrors: 0")
end)
