local CurrentModule = script.Parent
local Packages = CurrentModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

local cleanLoadStringStack = require(CurrentModule.Parent.cleanLoadStringStack)

it("should reformat a loadstring stacktrace to look like a normal stacktrace", function()
	local stack =
		[=[[string "_Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec"]:118]=]
	expect(cleanLoadStringStack(stack)).toEqual(
		"_Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:118"
	)
end)

it("should reformat a loadstring stacktrace with a function name to look like a normal stacktrace", function()
	local stack = [=[[string "_Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec"]:34: kaboom]=]
	expect(cleanLoadStringStack(stack)).toEqual(
		"_Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:34: kaboom"
	)
end)
