-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local Runtime = require(script.Parent.Parent)

local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local test = JestGlobals.test

local JestConfig = require(Packages.Dev.JestConfig)

local testFenvPath = script.Parent.test_fenv

describe("mockDataModel configuration", function()
	test("mocks game when enabled", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.mockDataModel = true
		local runtime = Runtime.new(config)
		local module = runtime:requireModule(testFenvPath)
		expect(module.game).toEqual(expect.any("table"))
	end)

	test("does not mock other globals when enabled", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.mockDataModel = true
		local runtime = Runtime.new(config)
		local module = runtime:requireModule(testFenvPath)
		expect(module.workspace).toEqual(workspace)
	end)

	test("does not mock any globals when disabled", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.mockDataModel = false
		local runtime = Runtime.new(config)
		local module = runtime:requireModule(testFenvPath)
		expect(module.game).toEqual(game)
		expect(module.workspace).toEqual(workspace)
	end)

	test("defaults to not mocking for backwards compatibility", function()
		local runtime = Runtime.new(JestConfig.projectDefaults)
		local module = runtime:requireModule(testFenvPath)

		expect(module.game).toEqual(game)
		expect(module.workspace).toEqual(workspace)
	end)
end)

describe("temporary protections", function()
	test("GetService is allowed", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.mockDataModel = true
		local runtime = Runtime.new(config)
		local module = runtime:requireModule(testFenvPath)

		expect(function()
			module.jest.spyOn(module.game, "GetService")
		end).never.toThrow()
	end)

	test("other DataModel methods are not allowed", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.mockDataModel = true
		local runtime = Runtime.new(config)
		local module = runtime:requireModule(testFenvPath)

		expect(function()
			module.jest.spyOn(module.game, "GetFullName")
		end).toThrow("not mockable")
	end)
end)
