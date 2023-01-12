-- ROBLOX NOTE: no upstream
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local setInterval = LuauPolyfill.setInterval

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local describe = JestGlobals.describe
local test = JestGlobals.test
local jest = JestGlobals.jest

describe("timers", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)
	afterEach(function()
		jest.useRealTimers()
	end)

	test("setTimeout - should not trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(false)
	end)

	test("setTimeout - should trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(true)
	end)

	test("setInterval - should not trigger", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(0)
	end)

	test("setInterval - should trigger once", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(1)
	end)

	test("setInterval - should trigger multiple times", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(100)
		expect(triggered).toBe(0)

		jest.advanceTimersByTime(99)
		expect(triggered).toBe(0)

		jest.advanceTimersByTime(1)
		expect(triggered).toBe(1)

		jest.advanceTimersByTime(100)
		expect(triggered).toBe(1)

		jest.advanceTimersByTime(100)
		expect(triggered).toBe(2)

		jest.advanceTimersByTime(199)
		expect(triggered).toBe(2)

		jest.advanceTimersByTime(1)
		expect(triggered).toBe(3)
	end)

	test("task.delay - should trigger", function()
		local triggered = false
		task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(2000)
		expect(triggered).toBe(true)
	end)

	test("task.delay - should not trigger", function()
		local triggered = false
		task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(1999)
		expect(triggered).toBe(false)
	end)

	test("should not timeout", function()
		local triggered = false
		task.delay(10, function()
			triggered = true
		end)
		jest.advanceTimersByTime(10000)
		expect(triggered).toBe(true)
	end, 1000)
end)
