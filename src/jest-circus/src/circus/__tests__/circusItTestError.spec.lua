-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-circus/src/__tests__/circusItTestError.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip

local typesModule = require(Packages.JestTypes)

type Global_It = typesModule.Global_It
local circusIt: Global_It
local circusTest: Global_It

-- using jest-jasmine2's 'it' to test jest-circus's 'it'. Had to differentiate
-- the two with this alias.

local function aliasCircusIt()
	local ref = require(script.Parent.Parent)
	local it, test = ref.it, ref.test
	circusIt = it
	circusTest = test
end

aliasCircusIt()

describe("test/it error throwing", function()
	-- ROBLOX FIXME START: we can't run circusTest insinde of circus's it
	itSKIP("it doesn't throw an error with valid arguments", function()
		jestExpect(function()
			circusIt("test1", function() end)
		end).never.toThrow()
	end)
	-- ROBLOX FIXME END

	it("it throws error with missing callback function", function()
		jestExpect(function()
			-- @ts-expect-error: Easy, we're testing runtime errors here
			(circusIt :: any)("test2")
		end).toThrowError(
			"Missing second argument. It must be a callback function. Perhaps you want to use `test.todo` for a test placeholder."
		)
	end)

	it("it throws an error when first argument isn't a string", function()
		jestExpect(function()
				-- @ts-expect-error: Easy, we're testing runtime errors here
				(circusIt :: any)(function() end)
			end)
			-- ROBLOX deviation: function printing is different in lua
			.toThrowError("Invalid first argument, [Function anonymous]. It must be a string.")
	end)

	it("it throws an error when callback function is not a function", function()
		jestExpect(function()
			-- @ts-expect-error: Easy, we're testing runtime errors here
			(circusIt :: any)("test4", "test4b")
		end).toThrowError("Invalid second argument, test4b. It must be a callback function.")
	end)

	-- ROBLOX FIXME START: we can't run circusTest insinde of circus's it
	itSKIP("test doesn't throw an error with valid arguments", function()
		jestExpect(function()
			circusTest("test5", function() end)
		end).never.toThrow()
	end)
	-- ROBLOX FIXME END

	it("test throws error with missing callback function", function()
		jestExpect(function()
			-- @ts-expect-error: Easy, we're testing runtime errors here
			(circusIt :: any)("test6")
		end).toThrowError(
			"Missing second argument. It must be a callback function. Perhaps you want to use `test.todo` for a test placeholder."
		)
	end)

	it("test throws an error when first argument isn't a string", function()
		jestExpect(function()
			-- @ts-expect-error: Easy, we're testing runtime errors here
			(circusIt :: any)(function() end)
		end).toThrowError("Invalid first argument, [Function anonymous]. It must be a string.")
	end)

	it("test throws an error when callback function is not a function", function()
		jestExpect(function()
			-- @ts-expect-error: Easy, we're testing runtime errors here
			(circusIt :: any)("test8", "test8b")
		end).toThrowError("Invalid second argument, test8b. It must be a callback function.")
	end)
end)

return {}