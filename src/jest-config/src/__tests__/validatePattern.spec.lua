-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-config/src/__tests__/validatePattern.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local validatePattern = require(script.Parent.Parent.validatePattern).default

describe("validate pattern function", function()
	it("without passed args returns true", function()
		local isValid = validatePattern()
		expect(isValid).toBeTruthy()
	end)

	it("returns true for empty pattern", function()
		local isValid = validatePattern("")
		expect(isValid).toBeTruthy()
	end)

	it("returns true for valid pattern", function()
		local isValid = validatePattern("abc+")
		expect(isValid).toBeTruthy()
	end)

	it("returns false for invalid pattern", function()
		local isValid = validatePattern("\\")
		expect(isValid).toBeFalsy()
	end)
end)
