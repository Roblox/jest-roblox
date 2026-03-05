local Packages = script.Parent

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

local describe = readGlobal("describe")
local test = readGlobal("test")
local it = readGlobal("it")
local expect = readGlobal("expect")

-- When tests are loaded through plain require(module) fallback, Jest runtime
-- interception does not run. In that case, return the already-injected globals.
if describe ~= nil and (test ~= nil or it ~= nil) and expect ~= nil then
	local globals = {
		afterAll = readGlobal("afterAll"),
		afterEach = readGlobal("afterEach"),
		beforeAll = readGlobal("beforeAll"),
		beforeEach = readGlobal("beforeEach"),
		describe = describe,
		expect = expect,
		expectExtended = expect,
		fdescribe = readGlobal("fdescribe"),
		fit = readGlobal("fit"),
		it = it,
		jest = readGlobal("jest"),
		test = if test ~= nil then test else it,
		xdescribe = readGlobal("xdescribe"),
		xit = readGlobal("xit"),
		xtest = readGlobal("xtest"),
	}

	if globals.fdescribe == nil and type(globals.describe) == "table" then
		globals.fdescribe = (globals.describe :: any).only
	end
	if globals.xdescribe == nil and type(globals.describe) == "table" then
		globals.xdescribe = (globals.describe :: any).skip
	end
	if globals.fit == nil and type(globals.it) == "table" then
		globals.fit = (globals.it :: any).only
	end
	if globals.xit == nil and type(globals.it) == "table" then
		globals.xit = (globals.it :: any).skip
	end
	if globals.xtest == nil then
		globals.xtest = globals.xit
	end

	return globals
end

return require(Packages.JestGlobalsUpstream)
