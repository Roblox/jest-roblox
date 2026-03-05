--!strict

local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local String = LuauPolyfill.String

return {
	stringEncaseCRLFWithFirstIndex = function(str: string, prefix: string, postfix: string, index: number): string
		local endIndex = 1
		local returnValue = ""
		repeat
			local gotCR = string.sub(str, index - 1, index - 1) == "\r"
			returnValue ..= String.slice(str, endIndex, if gotCR then index - 2 else index - 1) .. prefix .. (if gotCR
				then "\r\n"
				else "\n") .. postfix
			endIndex = index + 1
			-- TODO: add String.indexOf and use it here
			-- Lua note: type solver doesn't understand 'until index == nil' means that endIndex will never be nil
			index = string.find(str, "\n", endIndex :: number) :: number
		until index == nil

		returnValue ..= String.slice(str, endIndex)
		return returnValue
	end,
}
