-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local beforeEach = (JestGlobals.beforeEach :: any) :: Function

local clearLine = require(SrcModule.clearLine).default

describe("clearLine", function()
	local writeMock
	local stream
	beforeEach(function()
		writeMock = jest.fn()
		stream = {
			write = writeMock,
		}
	end)

	it("should NOT clear line if stream is NOT TTY", function()
		clearLine(stream)

		jestExpect(writeMock).never.toHaveBeenCalled()
	end)

	it("should clear line if stream is TTY", function()
		stream.isTTY = true
		clearLine(stream)

		jestExpect(writeMock).toHaveBeenCalledTimes(1)
		jestExpect(writeMock).toHaveBeenCalledWith(stream, "\x1b[999D\x1b[K")
	end)
end)

return {}
