--!nocheck
-- ROBLOX upstream: https://github.com/jasmine/jasmine/blob/v3.6.0/spec/core/SpySpec.js
--[[
	Our usual upstream of jest v28.0.0 doesn't include any tests for the
	createSpy file so we instead look to the source that the jest/jasmine2
	is based off of, jasmine
]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local createSpy = require(CurrentModule.createSpy)
local SpyStrategy = require(CurrentModule.SpyStrategy)
local CallTracker = require(CurrentModule.CallTracker)

describe("Spies", function()
	describe("createSpy", function()
		local TestClass = {}
		TestClass.prototype = {}

		beforeEach(function()
			setmetatable(TestClass, { __call = function() end })
			TestClass.prototype.someFunction = {}
			setmetatable(TestClass.prototype.someFunction, { __call = function() end })
			TestClass.prototype.someFunction.bob = "test"
		end)

		it("preserves the properties of the spied function", function()
			local spy = createSpy("TestClass.prototype", TestClass.prototype.someFunction)

			expect(spy.bob).toBe("test")
		end)

		-- ROBLOX deviation: test skipped because we don't implement the
		-- env.createSpy function that would actually allow for this
		it.skip("should allow you to omit the name argument and only pass the originalFn argument", function()
			--[[
					var fn = function test() {};
					var spy = env.createSpy(fn);

					// IE doesn't do `.name`
					if (fn.name === 'test') {
					expect(spy.and.identity).toEqual('test');
					} else {
					expect(spy.and.identity).toEqual('unknown');
					}
				]]
		end)

		it("warns the user that we intend to overwrite an existing property", function()
			TestClass.prototype.someFunction["and"] = "turkey"
			expect(function()
				createSpy("TestClass.prototype", TestClass.prototype.someFunction)
			end).toThrow(
				"Jasmine spies would overwrite the 'and', 'andAlso' and 'calls' properties on the object being spied upon"
			)

			TestClass.prototype.someFunction["and"] = nil
			TestClass.prototype.someFunction["andAlso"] = "turkey"
			expect(function()
				createSpy("TestClass.prototype", TestClass.prototype.someFunction)
			end).toThrow(
				"Jasmine spies would overwrite the 'and', 'andAlso' and 'calls' properties on the object being spied upon"
			)
		end)

		-- ROBLOX TODO: ADO-1475
		it("adds a spyStrategy and callTracker to the spy", function()
			local spy = createSpy("TestClass.prototype", TestClass.prototype.someFunction)

			expect(spy["and"].__index).toEqual(SpyStrategy)
			expect(spy.calls.__index).toEqual(CallTracker)
		end)

		-- ROBLOX TODO: implement more tests when we have more files
		-- translated such as spyRegistry (which will give access to the
		-- spyOn function)
	end)
end)
