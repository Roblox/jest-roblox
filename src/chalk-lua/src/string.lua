--[[
    derived from documentation and reference implementation at:
    https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/lastIndexOf
    Attributions and copyright licensing by Mozilla Contributors is licensed under CC-BY-SA 2.5
]]
--!nonstrict

local LuauPolyfill = require(script.Parent.Parent.LuauPolyfill)
local String = LuauPolyfill.String

local exports = {}

-- TODO: support utf8 and the substring "" case documented in MDN
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replaceAll
exports.replaceAll = function(str: string, substring: string, replacer)
	local index = string.find(str, substring, 1, true)
	if index == nil then
		return str
	end

	local output = ""
	local substringLength = string.len(substring)
	local endIndex = 1

	repeat
		output ..= string.sub(str, endIndex, index - 1) .. substring .. replacer
		endIndex = index + substringLength
		-- TODO: add indexOf to string and use it here
		index = string.find(str, substring, endIndex, true)
	until index == nil

	output ..= String.slice(str, endIndex)
	return output
end

return exports
