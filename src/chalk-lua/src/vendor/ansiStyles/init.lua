--[[
	MIT License

	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
	Lua port by Matt Hargett.

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

--!strict

local types = require(script.types)
type ansiStyles = types.ansiStyles

local ANSI_BACKGROUND_OFFSET = 10
local function wrapAnsi16(offset_: number?)
	local offset: number = if offset_ ~= nil then offset_ else 0
	return function(code: number)
		return ("%c[%dm"):format(27, code + offset)
	end
end
local function wrapAnsi256(offset_: number?)
	local offset: number = if offset_ ~= nil then offset_ else 0
	return function(code: number)
		return ("%c[%d;5;%dm"):format(27, 38 + offset, code)
	end
end
local function wrapAnsi16m(offset_: number?)
	local offset: number = if offset_ ~= nil then offset_ else 0
	return function(red, green, blue)
		return ("%c[%d;2;%s;%s;%sm"):format(27, 38 + offset, tostring(red), tostring(green), tostring(blue))
	end
end
local styles = (
	{
		modifier = {
			reset = { 0, 0 },
			-- 21 isn't widely supported and 22 does the same thing
			bold = { 1, 22 },
			dim = { 2, 22 },
			italic = { 3, 23 },
			underline = { 4, 24 },
			overline = { 53, 55 },
			inverse = { 7, 27 },
			hidden = { 8, 28 },
			strikethrough = { 9, 29 },
		},
		color = {
			black = { 30, 39 },
			red = { 31, 39 },
			green = { 32, 39 },
			yellow = { 33, 39 },
			blue = { 34, 39 },
			magenta = { 35, 39 },
			cyan = { 36, 39 },
			white = { 37, 39 },
			-- Bright color
			blackBright = { 90, 39 },
			gray = { 90, 39 },
			-- Alias of `blackBright`
			grey = { 90, 39 },
			-- Alias of `blackBright`
			redBright = { 91, 39 },
			greenBright = { 92, 39 },
			yellowBright = { 93, 39 },
			blueBright = { 94, 39 },
			magentaBright = { 95, 39 },
			cyanBright = { 96, 39 },
			whiteBright = { 97, 39 },
		},
		bgColor = {
			bgBlack = { 40, 49 },
			bgRed = { 41, 49 },
			bgGreen = { 42, 49 },
			bgYellow = { 43, 49 },
			bgBlue = { 44, 49 },
			bgMagenta = { 45, 49 },
			bgCyan = { 46, 49 },
			bgWhite = { 47, 49 },
			-- Bright color
			bgBlackBright = { 100, 49 },
			bgGray = { 100, 49 },
			-- Alias of `bgBlackBright`
			bgGrey = { 100, 49 },
			-- Alias of `bgBlackBright`
			bgRedBright = { 101, 49 },
			bgGreenBright = { 102, 49 },
			bgYellowBright = { 103, 49 },
			bgBlueBright = { 104, 49 },
			bgMagentaBright = { 105, 49 },
			bgCyanBright = { 106, 49 },
			bgWhiteBright = { 107, 49 },
		},
	} :: any
) :: ansiStyles

local function assembleStyles(): ansiStyles
	local codes = {}
	-- Lua note: needs manual pairs() iteration because type solver is confused
	for _, group in pairs(styles) do
		for styleName, style in group do
			-- Lua FIXME: style ends up being nil sometimes
			if style[1] then
				(styles :: any)[styleName] = {
					open = ("%c[%dm"):format(27, style[1]),
					close = ("%c[%dm"):format(27, style[2]),
				}

				group[styleName] = (styles :: any)[styleName]
				codes[style[1]] = style[2]
			end
		end
		-- Lua note: this is how you make properties on a table non-enumerable
		setmetatable(styles, {
			__index = function(self, key): any
				if key == "groupName" then
					return group
				elseif key == "codes" then
					return codes
				elseif key == "rgbToAnsi256" then
					return function(red: number, green: number, blue: number): number
						-- We use the extended greyscale palette here, with the exception of
						-- black and white. normal palette only has 4 greyscale shades.
						if red == green and green == blue then
							if red < 8 then
								return 16
							end
							if red > 248 then
								return 231
							end
							return math.round((red - 8) / 247 * 24) + 232
						end
						return 16
							+ 36 * math.round(red / 255 * 5)
							+ 6 * math.round(green / 255 * 5)
							+ math.round(blue / 255 * 5)
					end
				elseif key == "hexToRgb" then
					return function(hex: string): (number, number, number)
						local red = tonumber(string.sub(hex, 2, 3), 16)
						local green = tonumber(string.sub(hex, 6, 7), 16)
						local blue = tonumber(string.sub(hex, 4, 5), 16)
						if
							red == nil
							or green == nil
							or blue == nil
							or red ~= red
							or green ~= green
							or blue ~= blue
						then
							return 0, 0, 0
						end

						return red :: number, green :: number, blue :: number
					end
				elseif key == "hexToAnsi256" then
					return function(hex: string): number
						return styles.rgbToAnsi256(styles.hexToRgb(hex))
					end
				elseif key == "ansi256ToAnsi" then
					return function(code: number)
						if code < 8 then
							return 30 + code
						end
						if code < 16 then
							return 90 + (code - 8)
						end
						local red
						local green
						local blue
						if code >= 232 then
							red = ((code - 232) * 10 + 8) / 255
							green = red
							blue = red
						else
							code -= 16
							local remainder = code % 36
							red = math.floor(code / 36) / 5
							green = math.floor(remainder / 6) / 5
							blue = remainder % 6 / 5
						end
						local value = math.max(red, green, blue) * 2
						if value == 0 then
							return 30
						end
						local result = 30
							+ bit32.bor(
								bit32.bor(bit32.lshift(math.round(blue), 2), bit32.lshift(math.round(green), 1)),
								math.round(red)
							)
						if value == 2 then
							result += 60
						end
						return result
					end
				elseif key == "rgbToAnsi" then
					return function(red: number, green: number, blue: number): number
						return (styles :: ansiStyles).ansi256ToAnsi(
							(styles :: ansiStyles).rgbToAnsi256(red, green, blue)
						)
					end
				elseif key == "hexToAnsi" then
					return function(hex: string): number
						return (styles :: ansiStyles).ansi256ToAnsi((styles :: ansiStyles).hexToAnsi256(hex))
					end
				end
				return rawget(self, key)
			end,
		})
	end
	styles.color.close = ("%c[39m"):format(27)
	styles.bgColor.close = ("%c[49m"):format(27)
	styles.color.ansi = wrapAnsi16()
	styles.color.ansi256 = wrapAnsi256()
	styles.color.ansi16m = wrapAnsi16m()
	styles.bgColor.ansi = wrapAnsi16(ANSI_BACKGROUND_OFFSET)
	styles.bgColor.ansi256 = wrapAnsi256(ANSI_BACKGROUND_OFFSET)
	styles.bgColor.ansi16m = wrapAnsi16m(ANSI_BACKGROUND_OFFSET)

	return (styles :: any) :: ansiStyles
end
local ansiStyles: ansiStyles = assembleStyles()
return ansiStyles
