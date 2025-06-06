local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Map = LuauPolyfill.Map

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

local JestConfig = require(Packages.Dev.JestConfig)

local Runtime = require(CurrentModule)

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
end);

(it.each :: FIXME_ANALYZE)({
	"",
	"/",
	"foo",
	"/foo",
	"foo/bar",
	"/foo/bar",
	"@alias",
	"@",
	"@alias/foo",
	"@alias/foo/bar",
})("should explicitly disallow all forms of require by string", function(path)
	expect(function()
		(require :: any)(path)
	end).toThrow("not enabled")
end)
