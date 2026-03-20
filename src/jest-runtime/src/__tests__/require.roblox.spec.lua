local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Map = LuauPolyfill.Map

local JestGlobals = require(Packages.Dev.JestGlobals)
local afterAll = JestGlobals.afterAll
local beforeAll = JestGlobals.beforeAll
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local JestConfig = require(Packages.Dev.JestConfig)

local Runtime = require(CurrentModule)
local rbsNativeErrors = require(script.Parent["rbs_native_errors.global"])

type FIXME_ANALYZE = any

it("should not allow ModuleScripts returning zero values", function()
	expect(function()
		local _requireZero = require(script.Parent["requireZero.roblox"]) :: any
	end).toThrow("ModuleScripts must return exactly one value")
end)

it("should allow ModuleScripts returning nil", function()
	expect(function()
		require(script.Parent["requireNil.roblox"])
	end).never.toThrow()
end)

it("should allow ModuleScripts returning value", function()
	expect(function()
		require(script.Parent["requireOne.roblox"])
	end).never.toThrow()
end)

it("should not allow ModuleScripts returning two values", function()
	expect(function()
		require(script.Parent["requireTwo.roblox"])
	end).toThrow("ModuleScripts must return exactly one value")
end)

it("should not override module function environment for another runtime", function()
	local loadedModuleFns = Map.new()

	local returnRequire = Runtime.new(JestConfig.projectDefaults, loadedModuleFns)
		:requireModule(script.Parent["returnRequire.roblox"])
	local requireRefBefore = returnRequire()

	Runtime.new(JestConfig.projectDefaults, loadedModuleFns):requireModule(script.Parent["returnRequire.roblox"])
	local requireRefAfter = returnRequire()

	expect(requireRefBefore).toBe(requireRefAfter)
end)

describe("require by string", function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local clone: Instance?

	beforeAll(function()
		clone = script.Parent.rbs_fixture:Clone()
		assert(clone, "failed to clone rbs_fixture")
		clone.Name = "RbsTestFixture"
		clone.Parent = ReplicatedStorage
	end)

	afterAll(function()
		if clone then
			clone:Destroy()
		end
	end)

	it("should resolve a sibling module via relative string path", function()
		local result = (require :: any)("./rbs_fixture")
		expect(result.name).toBe("rbs_fixture")
		expect(result.location).toBe("__tests__")
	end)

	it("should resolve a nested child via multi-part path", function()
		local result = (require :: any)("./test_rbs/sibling")
		expect(result.name).toBe("sibling")
		expect(result.location).toBe("test_rbs")
	end)

	it("should resolve a deeply nested module", function()
		local result = (require :: any)("./test_rbs/nested/deep")
		expect(result.name).toBe("deep")
		expect(result.location).toBe("test_rbs/nested")
	end)

	it("should resolve an ascending path via ../ prefix", function()
		local result = (require :: any)("../__tests__/rbs_fixture")
		expect(result.name).toBe("rbs_fixture")
		expect(result.location).toBe("__tests__")
	end)

	it("should resolve @self paths to a child of the calling script", function()
		local runtime = Runtime.new(JestConfig.projectDefaults)
		local result = runtime:requireModule(script.Parent.test_rbs.self_test)
		expect(result.name).toBe("self_child")
	end)

	it("should resolve @game paths from the game root", function()
		local result = (require :: any)("@game/ReplicatedStorage/RbsTestFixture")
		expect(result.name).toBe("rbs_fixture")
	end);

	(it.each :: FIXME_ANALYZE)({
		{ "@rbx/ThisWillNeverExist", rbsNativeErrors.rbx :: string },
		{ "@std/ThisWillNeverExist", rbsNativeErrors.std :: string },
	})("should pass %s through to native require", function(path, expectedError)
		expect(function()
			(require :: any)(path)
		end).toThrow(expectedError)
	end)

	it("should throw a resolution error for nonexistent paths", function()
		expect(function()
			(require :: any)("./nonExistentModule")
		end).toThrow("could not resolve")
	end)
end)
