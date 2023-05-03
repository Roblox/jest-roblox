-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/utils.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local path = require(Packages.Path).path
-- ROBLOX deviation START: not needed
-- local chalk = require(Packages.ChalkLua)
-- ROBLOX deviation END
-- ROBLOX deviation START: use inline implementation of stripAnsi
local stripAnsi = function(text: string)
	return string.gsub(text, "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
end
-- local stripAnsi = require(Packages["strip-ansi"])
-- ROBLOX deviation END
local makeProjectConfig = require(Packages.TestUtils).makeProjectConfig
local utilsModule = require(CurrentModule.utils)
local printDisplayName = utilsModule.printDisplayName
local trimAndFormatPath = utilsModule.trimAndFormatPath
local wrapAnsiString = utilsModule.wrapAnsiString

describe("wrapAnsiString()", function()
	-- ROBLOX deviation START: Not needed since we don't have a console width
	-- it("wraps a long string containing ansi chars", function()
	-- 	local string_ = ("abcde %s 1234456"):format(chalk.red("red-bold"))
	-- 		.. ("%s "):format(chalk.dim("bcd"))
	-- 		.. "123ttttttththththththththththththththththththththth"
	-- 		.. ("tetetetetettetetetetetetetete%s"):format(chalk.underline("stnhsnthsnth"))
	-- 		.. "ssot"

	-- 	expect(wrapAnsiString(string_, 10)).toMatchSnapshot()
	-- 	expect(stripAnsi(wrapAnsiString(string_, 10))).toMatchSnapshot()
	-- end)
	-- ROBLOX deviation END

	it("returns the string unaltered if given a terminal width of zero", function()
		local string = "This string shouldn't cause you any trouble"
		expect(wrapAnsiString(string, 0)).toMatchSnapshot()
		local stripped = stripAnsi(wrapAnsiString(string, 0))
		expect(stripped).toMatchSnapshot()
	end)
end)

describe("stripAnsi", function()
	it("does not mess up regular text content", function()
		local stripped = stripAnsi("...12/34/56.js")
		expect(stripped).toBe("...12/34/56.js")
		-- ROBLOX FIXME Luau: need to extract `utf8.len(stripped)` into a len variable. Otherwise, analyze complains about calling `expect` which is a callable table.
		local len = utf8.len(stripped)
		expect(len).toBe(14)
		expect(stripped:len()).toBe(14)
	end)
	it("strips ansi chars", function()
		local stripped = stripAnsi("[1m...12/34/56.js[22m")
		expect(stripped).toBe("...12/34/56.js")
		-- ROBLOX FIXME Luau: need to extract `utf8.len(stripped)` into a len variable. Otherwise, analyze complains about calling `expect` which is a callable table.
		local len = utf8.len(stripped)
		expect(len).toBe(14)
		expect(stripped:len()).toBe(14)
	end)
end)

describe("trimAndFormatPath()", function()
	it("trims dirname", function()
		local pad = 5
		local basename = "1234.js"
		local dirname = "1234567890/1234567890"
		local columns = 25
		local result = trimAndFormatPath(
			pad,
			makeProjectConfig({ cwd = "", rootDir = "" }),
			path:join(dirname, basename) :: string,
			columns
		)
		expect(result).toMatchSnapshot()
		expect(stripAnsi(result):len()).toBe(20)
	end)

	it("trims dirname (longer line width)", function()
		local pad = 5
		local basename = "1234.js"
		local dirname = "1234567890/1234567890"
		local columns = 30
		local result = trimAndFormatPath(
			pad,
			makeProjectConfig({ cwd = "", rootDir = "" }),
			path:join(dirname, basename) :: string,
			columns
		)
		expect(result).toMatchSnapshot()
		expect(stripAnsi(result):len()).toBe(25)
	end)

	it("trims dirname and basename", function()
		local pad = 5
		local basename = "1234.js"
		local dirname = "1234567890/1234567890"
		local columns = 15
		local result = trimAndFormatPath(
			pad,
			makeProjectConfig({ cwd = "", rootDir = "" }),
			path:join(dirname, basename) :: string,
			columns
		)
		expect(result).toMatchSnapshot()
		expect(stripAnsi(result):len()).toBe(10)
	end)

	it("does not trim anything", function()
		local pad = 5
		local basename = "1234.js"
		local dirname = "1234567890/1234567890"
		local columns = 50
		local totalLength = (basename .. path.sep .. dirname):len()
		local result = trimAndFormatPath(
			pad,
			makeProjectConfig({ cwd = "", rootDir = "" }),
			path:join(dirname, basename) :: string,
			columns
		)
		expect(result).toMatchSnapshot()
		expect(stripAnsi(result):len()).toBe(totalLength)
	end)

	it("split at the path.sep index", function()
		local pad = 5
		local basename = "1234.js"
		local dirname = "1234567890"
		local columns = 16
		local result = trimAndFormatPath(
			pad,
			makeProjectConfig({ cwd = "", rootDir = "" }),
			path:join(dirname, basename) :: string,
			columns
		)
		expect(result).toMatchSnapshot()
		expect(stripAnsi(result):len()).toBe(columns - pad)
	end)
end)

describe("printDisplayName", function()
	it("should default displayName color to white when displayName is a string", function()
		expect(printDisplayName(makeProjectConfig({ displayName = { color = "white", name = "hello" } }))).toMatchSnapshot()
	end)
	it("should default displayName color to white when color is not a valid value", function()
		expect(printDisplayName(makeProjectConfig({ displayName = { color = "rubbish" :: any, name = "hello" } }))).toMatchSnapshot()
	end)
	it("should correctly print the displayName when color and name are valid values", function()
		expect(printDisplayName(makeProjectConfig({ displayName = { color = "green", name = "hello" } }))).toMatchSnapshot()
	end)
end)
