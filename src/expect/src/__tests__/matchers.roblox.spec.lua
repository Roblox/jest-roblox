--!nocheck
return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(CurrentModule)

	local chalk = require(Packages.Dev.ChalkLua)
	local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Error = LuauPolyfill.Error
	local Set = LuauPolyfill.Set

	local CustomClass = {}
	CustomClass.__index = CustomClass

	function CustomClass.new()
	    return setmetatable({ foo = true }, CustomClass)
	end

	beforeAll(function()
		jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)


	-- test cases devised from https://github.com/Roblox/jest-roblox/pull/27#discussion_r561374828
	it("tests toStrictEqual matcher with example class", function()
		jestExpect(CustomClass.new()).never.toBe(CustomClass.new()) -- not the same table
		jestExpect(CustomClass.new()).toStrictEqual(CustomClass.new()) -- not the same table, but same shape and same class
		jestExpect(CustomClass.new()).never.toStrictEqual({ foo = true}) -- same shape but not same class
		jestExpect(CustomClass.new()).toEqual({ foo = true}) -- same shape
	end)

	-- test case taken from Jest docs
	local LaCroix = {}
	LaCroix.__index = LaCroix
	function LaCroix.new(flavor)
		return setmetatable({
			flavor = flavor
		}, LaCroix)
	end

	it('the La Croix cans on my desk are not semantically the same', function()
		jestExpect(LaCroix.new('lemon')).toEqual({flavor = 'lemon'})
		jestExpect(LaCroix.new('lemon')).never.toStrictEqual({flavor = 'lemon'})
	end)

	it("tests the set polyfill", function()
		jestExpect(Set.new({1, 2, 5})).toEqual(Set.new{2, 5, 1})
		jestExpect(Set.new({1, 2, 6})).never.toEqual(Set.new{1, 2, 5})
		jestExpect(Set.new({{1, 2}, {3, 4}})).toEqual(Set.new{{3, 4}, {1, 2}})
		jestExpect(Set.new({{1, 2}, {3, 4}})).never.toEqual(Set.new{{1, 2}, {3, 5}})
		jestExpect(Set.new({"a"})).toContain("a")
	end)

	describe("chalk tests", function()
		it("tests basic chalked string", function()
			jestExpect(chalk.red("i am chalked")).toMatch("i am chalked")
			jestExpect(chalk.red("i am chalked")).toMatch(chalk.red("i am chalked"))
		end)

		it("tests nested chalk string", function()
			local nestedStyle = chalk.red .. chalk.bold .. chalk.bgYellow
			jestExpect(nestedStyle("i am heavily chalked")).toMatch("i am heavily chalked")
			jestExpect(nestedStyle("i am heavily chalked")).toMatch(chalk.bgYellow("i am heavily chalked"))
			jestExpect(nestedStyle("i am heavily chalked")).toMatch(chalk.bold(chalk.bgYellow("i am heavily chalked")))
			jestExpect(nestedStyle("i am heavily chalked")).toMatch(nestedStyle("i am heavily chalked"))

			jestExpect(nestedStyle("i am heavily chalked")).never.toMatch(chalk.red("i am heavily chalked"))
		end)
	end)

	local nestedFn = function(fn)
		local success, result = pcall(function()
			fn()
		end)
		if not success then
			error(result)
		end
	end

	it("tests stack traces for calls within pcalls", function()
		jestExpect(function()
			jestExpect(function()
				nestedFn(function()
					jestExpect(4).toBe(2)
				end)
			end).never.toThrow()
		end).toThrowErrorMatchingSnapshot()
	end)

	local nestedFnWithError = function(fn)
		local success, result = pcall(function()
			fn()
		end)
		if not success then
			error(Error(result))
		end
	end

	-- TODO: ADO-1716 unskip this test and determine how to reconcile behavior
	itSKIP("tests stack traces for calls within pcalls with Error polyfill", function()
		jestExpect(function()
			jestExpect(function()
				nestedFnWithError(function()
					jestExpect(4).toBe(2)
				end)
			end).never.toThrow()
		end).toThrowErrorMatchingSnapshot()
	end)
end