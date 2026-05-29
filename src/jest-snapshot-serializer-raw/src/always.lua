-- ROBLOX upstream: https://github.com/ikatyang/jest-snapshot-serializer-raw/blob/v1.2.0/src/always.ts
--[[
	MIT License

	Copyright (c) Ika <ikatyang@gmail.com> (https://github.com/ikatyang)
]]

local function test(value: any): boolean
	return typeof(value) == "string"
end

local function print(value: string): string
	return value
end

return {
	test = test,
	print = print,
}
