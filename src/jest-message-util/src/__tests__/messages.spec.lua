--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Packages = script.Parent.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local CurentModule = require(script.Parent.Parent)
local formatExecError = CurentModule.formatExecError

beforeEach(function()
	jest.clearAllMocks()
end)

it(".formatExecError()", function()
	local message = formatExecError(
		{ message = "Whoops!", stack = "" },
		{ rootDir = "" :: any, testMatch = {} },
		{ noStackTrace = false },
		"path_test"
	)
	expect(message).toMatchSnapshot()
end)
