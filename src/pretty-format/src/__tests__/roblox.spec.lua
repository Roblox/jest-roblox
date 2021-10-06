--!nocheck

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local prettyFormat = require(CurrentModule).prettyFormat

	it('userdata', function()
		local testObject = newproxy()

		jestExpect(prettyFormat(testObject)).toContain('userdata: 0x')
	end)

	it('Instance', function()
		local testObject = Instance.new("Frame")

		jestExpect(prettyFormat(testObject)).toEqual("Frame")
	end)

	it('Builtin Datatypes', function()
		jestExpect(prettyFormat(Color3.new(1,1,1))).toEqual("Color3(1, 1, 1)")
		jestExpect(prettyFormat(UDim2.new(1,50,0,50))).toEqual("UDim2({1, 50}, {0, 50})")
		jestExpect(prettyFormat(Vector3.new(10,20,30))).toEqual("Vector3(10, 20, 30)")
	end)
end