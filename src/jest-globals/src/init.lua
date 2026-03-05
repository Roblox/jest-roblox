local Packages = script.Parent
local jestCircus = require(Packages.JestCircus)
local expect = require(Packages.Expect)

local function readGlobal(name: string): any
	local env: any = getfenv(0)
	local value = env[name]
	if value ~= nil then
		return value
	end

	local maybeGlobal = env._G
	if type(maybeGlobal) == "table" then
		return maybeGlobal[name]
	end

	return nil
end

local injectedGlobals = readGlobal("__STRONK_JEST_GLOBALS__")
if type(injectedGlobals) == "table" then
	return injectedGlobals
end

local globals = {
	afterAll = jestCircus.afterAll,
	afterEach = jestCircus.afterEach,
	beforeAll = jestCircus.beforeAll,
	beforeEach = jestCircus.beforeEach,
	describe = jestCircus.describe,
	expect = expect,
	expectExtended = expect,
	fdescribe = jestCircus.describe.only,
	fit = jestCircus.it.only,
	it = jestCircus.it,
	jest = readGlobal("jest"),
	test = jestCircus.test,
	xdescribe = jestCircus.describe.skip,
	xit = jestCircus.it.skip,
	xtest = jestCircus.test.skip,
}

return globals
