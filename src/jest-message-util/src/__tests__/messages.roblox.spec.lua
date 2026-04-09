--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
local Packages = script.Parent.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local Promise = require(Packages.Dev.Promise)
local Error = require(Packages.LuauPolyfill).Error

local RobloxShared = require(Packages.RobloxShared)
local pruneDeps = RobloxShared.pruneDeps

local CurentModule = require(script.Parent.Parent)
local formatExecError = CurentModule.formatExecError
local getStackTraceLines = CurentModule.getStackTraceLines

it(".formatExecError() - Promise throw string", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				error("kaboom")
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - Promise throw Error", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				error(Error.new("kaboom"))
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - nested Promise throw string", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				return Promise.resolve():andThen(function()
					return error("kaboom")
				end)
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - nested Promise throw Error", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				return Promise.resolve():andThen(function()
					return error(Error.new("kaboom"))
				end)
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

describe("getStackTraceLines - stackDepth", function()
	local fakeStack = table.concat({
		"Error: boom",
		"    at Object.<anonymous> (foo.lua:1:1)",
		"    at Object.<anonymous> (bar.lua:2:1)",
		"    at Object.<anonymous> (baz.lua:3:1)",
		"    at Object.<anonymous> (qux.lua:4:1)",
		"    at Object.<anonymous> (quux.lua:5:1)",
	}, "\n")

	it("returns all lines when stackDepth is 0", function()
		local lines = getStackTraceLines(fakeStack, { noStackTrace = false, stackDepth = 0 })
		expect(#lines).toBeGreaterThanOrEqual(5)
	end)

	it("returns all lines when stackDepth is nil", function()
		local lines = getStackTraceLines(fakeStack, { noStackTrace = false })
		expect(#lines).toBeGreaterThanOrEqual(5)
	end)

	it("truncates to stackDepth lines and appends a truncation message", function()
		local lines = getStackTraceLines(fakeStack, { noStackTrace = false, stackDepth = 2 })
		expect(#lines).toBe(3)
		expect(lines[3]).toMatch("more lines truncated")
	end)

	it("does not truncate when stackDepth >= number of lines", function()
		local lines = getStackTraceLines(fakeStack, { noStackTrace = false, stackDepth = 100 })
		-- no truncation message should be present
		for _, line in lines do
			expect(line).never.toMatch("truncated")
		end
	end)

	it("truncates to exactly 1 line when stackDepth is 1", function()
		local lines = getStackTraceLines(fakeStack, { noStackTrace = false, stackDepth = 1 })
		expect(#lines).toBe(2)
		expect(lines[2]).toMatch("more lines truncated")
	end)
end)

return {}
