--[[
	MIT License

	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
	Lua port by Matt Hargett.

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

--!strict
export type CSPair = {
	--[[*
	The ANSI terminal control sequence for starting this style.
	]]
	open: string,

	--[[*
	The ANSI terminal control sequence for ending this style.
	]]
	close: string,
}

export type ColorBase = {
	--[[*
	The ANSI terminal control sequence for ending this color.
	]]
	close: string,

	ansi: (code: number) -> string,

	ansi256: (code: number) -> string,

	ansi16m: (red: number, green: number, blue: number) -> string,
}

export type Modifier = {
	--[[*
	Resets the current color chain.
	]]
	reset: CSPair,

	--[[*
	Make text bold.
	]]
	bold: CSPair,

	--[[*
	Emitting only a small amount of light.
	]]
	dim: CSPair,

	--[[*
	Make text italic. (Not widely supported)
	]]
	italic: CSPair,

	--[[*
	Make text underline. (Not widely supported)
	]]
	underline: CSPair,

	--[[*
	Make text overline.

	Supported on VTE-based terminals, the GNOME terminal, mintty, and Git Bash.
	]]
	overline: CSPair,

	--[[*
	Inverse background and foreground colors.
	]]
	inverse: CSPair,

	--[[*
	Prints the text, but makes it invisible.
	]]
	hidden: CSPair,

	--[[*
	Puts a horizontal line through the center of the text. (Not widely supported)
	]]
	strikethrough: CSPair,
}

export type ForegroundColor = {
	black: CSPair,
	red: CSPair,
	green: CSPair,
	yellow: CSPair,
	blue: CSPair,
	cyan: CSPair,
	magenta: CSPair,
	white: CSPair,

	--[[*
	Alias for `blackBright`.
	]]
	gray: CSPair,

	--[[*
	Alias for `blackBright`.
	]]
	grey: CSPair,

	blackBright: CSPair,
	redBright: CSPair,
	greenBright: CSPair,
	yellowBright: CSPair,
	blueBright: CSPair,
	cyanBright: CSPair,
	magentaBright: CSPair,
	whiteBright: CSPair,
}

export type BackgroundColor = {
	bgBlack: CSPair,
	bgRed: CSPair,
	bgGreen: CSPair,
	bgYellow: CSPair,
	bgBlue: CSPair,
	bgCyan: CSPair,
	bgMagenta: CSPair,
	bgWhite: CSPair,

	--[[*
	Alias for `bgBlackBright`.
	]]
	bgGray: CSPair,

	--[[*
	Alias for `bgBlackBright`.
	]]
	bgGrey: CSPair,

	bgBlackBright: CSPair,
	bgRedBright: CSPair,
	bgGreenBright: CSPair,
	bgYellowBright: CSPair,
	bgBlueBright: CSPair,
	bgCyanBright: CSPair,
	bgMagentaBright: CSPair,
	bgWhiteBright: CSPair,
}

export type ConvertColor = {
	--[[*
	Convert from the RGB color space to the ANSI 256 color space.

	@param red - (`0...255`)
	@param green - (`0...255`)
	@param blue - (`0...255`)
	]]
	rgbToAnsi256: (red: number, green: number, blue: number) -> number,

	--[[*
	Convert from the RGB HEX color space to the RGB color space.

	@param hex - A hexadecimal string containing RGB data.
	]]
	hexToRgb: (hex: string) -> (number, number, number), -- Lua note: original TS was [red: number, green: number, blue: number];

	--[[*
	Convert from the RGB HEX color space to the ANSI 256 color space.

	@param hex - A hexadecimal string containing RGB data.
	]]
	hexToAnsi256: (hex: string) -> number,

	--[[*
	Convert from the ANSI 256 color space to the ANSI 16 color space.

	@param code - A number representing the ANSI 256 color.
	]]
	ansi256ToAnsi: (code: number) -> number,

	--[[*
	Convert from the RGB color space to the ANSI 16 color space.

	@param red - (`0...255`)
	@param green - (`0...255`)
	@param blue - (`0...255`)
	]]
	rgbToAnsi: (red: number, green: number, blue: number) -> number,

	--[[*
	Convert from the RGB HEX color space to the ANSI 16 color space.

	@param hex - A hexadecimal string containing RGB data.
	]]
	hexToAnsi: (hex: string) -> number,
}

--[[*
Basic modifier names.
]]
export type ModifierName = string -- Lua note: original TS was keyof Modifier;

--[[*
Basic foreground color names.

[More colors here.](https:--github.com/chalk/chalk/blob/main/readme.md#256-and-truecolor-color-support)
]]
export type ForegroundColorName = string -- Lua note: original TS was keyof ForegroundColor;

--[[*
Basic background color names.

[More colors here.](https:--github.com/chalk/chalk/blob/main/readme.md#256-and-truecolor-color-support)
]]
export type BackgroundColorName = string -- Lua note: original TS was keyof BackgroundColor;

--[[*
Basic color names. The combination of foreground and background color names.

[More colors here.](https:--github.com/chalk/chalk/blob/main/readme.md#256-and-truecolor-color-support)
]]
export type ColorName = ForegroundColorName | BackgroundColorName

--[[*
Basic modifier names.
]]
-- export const modifierNames: ModifierName[];

--[[*
Basic foreground color names.
]]
-- export const foregroundColorNames: ForegroundColorName[];

--[[*
Basic background color names.
]]
-- export const backgroundColorNames: BackgroundColorName[];

--[[
Basic color names. The combination of foreground and background color names.
]]
-- export const colorNames: ColorName[];

export type ansiStyles = {
	modifier: Modifier,
	color: ColorBase & ForegroundColor,
	bgColor: ColorBase & BackgroundColor,
	codes: { [number]: number },
} & ForegroundColor & BackgroundColor & Modifier & ConvertColor

return {}
