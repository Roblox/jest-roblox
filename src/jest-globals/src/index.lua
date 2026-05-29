-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-globals/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Packages = script.Parent.Parent

local JestEnvironment = require(Packages.JestEnvironment)
type Jest = JestEnvironment.Jest

local importedExpect = require(Packages.Expect)
type MatcherState = importedExpect.MatcherState
type ExpectExtended<E, State = MatcherState> = importedExpect.ExpectExtended<E, State>

local jestTypesModule = require(Packages.JestTypes)
type TestFrameworkGlobals = jestTypesModule.Global_TestFrameworkGlobals

type JestGlobals = {
	jest: Jest,
	expect: typeof(importedExpect),
	expectExtended: ExpectExtended<{ [string]: (...any) -> nil }>,
} & TestFrameworkGlobals

-- jest-runtime intercepts `require(Packages.JestGlobals)` inside tests and injects
-- the live globals; reaching this error means the module was imported outside that path.
error(
	"Do not import `JestGlobals` outside of the Jest 3 test environment.\n"
		.. "Tip: Jest 2 uses a different pattern - check your Jest version."
)

return ({} :: any) :: JestGlobals
