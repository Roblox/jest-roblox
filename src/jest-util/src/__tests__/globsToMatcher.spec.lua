-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/globsToMatcher.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent
	local jestExpect = require(Packages.Expect)

	local micromatch: any = function() end -- ROBLOX TODO: import micromatch if available
	local globsToMatcher = require(CurrentModule.globsToMatcher).default

	itSKIP("works like micromatch with only positive globs", function()
		local globs = { "**/*.test.js", "**/*.test.jsx" }
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)

	itSKIP("works like micromatch with a mix of overlapping positive and negative globs", function()
		local globs = { "**/*.js", "!**/*.test.js", "**/*.test.js" }
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		local globs2 = { "**/*.js", "!**/*.test.js", "**/*.test.js", "!**/*.test.js" }
		local matcher2 = globsToMatcher(globs2)
		jestExpect(matcher2("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs2).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher2("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs2).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)

	itSKIP("works like micromatch with only negative globs", function()
		local globs = { "!**/*.test.js", "!**/*.test.jsx" }
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)

	itSKIP("works like micromatch with empty globs", function()
		local globs = {}
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)

	itSKIP("works like micromatch with pure negated extglobs", function()
		local globs = { "**/*.js", "!(some-module.test.js)" }
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("some-module.test.js")).toBe(
			micromatch({ "some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)

	itSKIP("works like micromatch with negated extglobs", function()
		local globs = { "**/*.js", "!(tests|coverage)/*.js" }
		local matcher = globsToMatcher(globs)
		jestExpect(matcher("some-module.js")).toBe(
			micromatch({ "some-module.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
		jestExpect(matcher("tests/some-module.test.js")).toBe(
			micromatch({ "tests/some-module.test.js" }, globs).length > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	end)
end