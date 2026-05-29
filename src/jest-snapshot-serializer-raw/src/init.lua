-- ROBLOX upstream: https://github.com/ikatyang/jest-snapshot-serializer-raw/blob/v1.2.0/src/index.ts
--[[
	MIT License

	Copyright (c) Ika <ikatyang@gmail.com> (https://github.com/ikatyang)
]]

local always = require(script.always)

local RAW = {} :: any

export type Wrapper = { [any]: string }

local function wrap(value: string): Wrapper
	return { [RAW] = value }
end

local function test(value: any): boolean
	return typeof(value) == "table" and always.test(value[RAW])
end

local function print(value: Wrapper): string
	return always.print(value[RAW])
end

return {
	wrap = wrap,
	test = test,
	print = print,
}
