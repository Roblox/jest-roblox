-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-get-type/src/__tests__/getType.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = require(Packages.LuauPolyfill).Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set

local RegExp = require(Packages.RegExp)
local Symbol = require(Packages.Dev.Symbol)

local getType = require(CurrentModule).getType

describe(".getType()", function()
	it("nil", function()
		expect(getType(nil)).toBe("nil")
	end)

	it("table", function()
		expect(getType({})).toBe("table")
	end)

	it("number", function()
		expect(getType(1)).toBe("number")
	end)

	it("string", function()
		expect(getType("oi")).toBe("string")
	end)

	it("function", function()
		expect(getType(function() end)).toBe("function")
	end)

	it("boolean", function()
		expect(getType(true)).toBe("boolean")
	end)

	it("symbol", function()
		expect(getType(Symbol("test"))).toBe("symbol")
		expect(getType(Symbol.for_("test"))).toBe("symbol")
		expect(getType(Symbol.for_("test2"))).toBe("symbol")
		expect(getType(Symbol())).toBe("symbol")
	end)

	it("regexp", function()
		expect(getType(RegExp("abc"))).toBe("regexp")
	end)

	it("map", function()
		expect(getType(Map.new())).toBe("map")
	end)

	it("set", function()
		expect(getType(Set.new())).toBe("set")
	end)

	it("DateTime", function()
		expect(getType(DateTime.now())).toBe("DateTime")
	end)

	it("error", function()
		expect(getType(Error("abc"))).toBe("error")
	end)

	it("Instance", function()
		expect(getType(Instance.new("Frame"))).toBe("Instance")
	end)

	it("userdata", function()
		expect(getType(newproxy())).toBe("userdata")
	end)
end)
