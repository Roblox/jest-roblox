-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/e2e/__tests__/locationInResults.test.ts
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/e2e/location-in-results/__tests__/test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent
local runTest = require(script.Parent.Parent.__mocks__.testUtils).runTest

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

local loadModuleEnabled = pcall((debug :: any).loadmodule, Instance.new("ModuleScript"))
if not loadModuleEnabled then
	it = it.skip :: any
end

-- ROBLOX DEVIATION: upstream runs a test file under the Jest CLI and reads the JSON
-- report. Here the same file runs through the circus harness, so `xit`/`fit` are
-- `test.skip`/`test.only`, the bodies are empty because the harness exposes no
-- `expect`, and the result is `makeRunResult`'s. The line layout is upstream's, so
-- each location is asserted relative to the first test rather than absolutely.
local locationInResultsSource = [[
test("it no ancestors", function()
end)

test.skip("xit no ancestors", function()
end)

test.only("fit no ancestors", function()
end)

test.each({ true, true })("it each no ancestors", function()
end)

describe("nested", function()
	test("it nested", function()
	end)

	test.skip("xit nested", function()
	end)

	test.only("fit nested", function()
	end)

	test.each({ true, true })("it each nested", function()
	end)
end)
]]

it("defaults to nil for location", function()
	local result = runTest(locationInResultsSource).result

	local assertions = result.testResults
	expect(#assertions).toBe(10)
	for _, assertion in assertions do
		expect(assertion.location).toBeNil()
	end
end)

it("adds correct location info when provided with flag", function()
	local result = runTest(
		'require(script_.Parent.Parent.state).dispatchSync({ name = "include_test_location_in_result" })\n'
			.. locationInResultsSource
	).result

	local assertions = result.testResults
	expect(#assertions).toBe(10)

	-- Upstream's lines are 12, 16, 20, 24, 24, 29, 33, 37, 41, 41; the same layout
	-- here starts at whatever line the harness puts the first test on.
	local firstLine = assertions[1].location.line
	expect(firstLine).toEqual(expect.any("number"))
	local lineOffsets = { 0, 4, 8, 12, 12, 17, 21, 25, 29, 29 }

	for index, offset in lineOffsets do
		-- ROBLOX DEVIATION: Luau frames carry no column, so it is reported as 0.
		expect(assertions[index].location).toEqual({
			column = 0,
			line = firstLine + offset,
		})
	end
end)
