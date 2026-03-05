-- --[[
-- 	MIT License

-- 	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
-- 	Lua port by Matt Hargett.

-- 	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

-- 	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

-- 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ]]
-- --!strict
-- local process = require("@lune/process")
-- type Object = { [string]: any }
-- local Array = require("../../array.lua");

-- (os :: any).getenv = function(_name: string): string?
-- 	return nil
-- end

-- -- From: https://github.com/sindresorhus/has-flag/blob/main/index.js
-- local function hasFlag(flag, argv_: { string }?)
-- 	local argv = argv_ or {}
-- 	local prefix = if string.find(flag, "-") then "" else if string.len(flag) == 1 then "-" else "--"
-- 	local position = table.find(argv, prefix .. flag)
-- 	local terminatorPosition = table.find(argv, "--")
-- 	return position and (terminatorPosition == nil or (position < terminatorPosition))
-- end

-- local flagForceColor
-- if hasFlag("no-color") or hasFlag("no-colors") or hasFlag("color=false") or hasFlag("color=never") then
-- 	flagForceColor = 0
-- elseif hasFlag("color") or hasFlag("colors") or hasFlag("color=true") or hasFlag("color=always") then
-- 	flagForceColor = 1
-- end

-- local function envForceColor(): number?
-- 	if process.env.FORCE_COLOR then
-- 		if process.env.FORCE_COLOR == "true" then
-- 			return 1
-- 		end

-- 		if process.env.FORCE_COLOR == "false" then
-- 			return 0
-- 		end

-- 		return if string.len(process.env.FORCE_COLOR) == 0
-- 			then 1
-- 			else math.min(tonumber(process.env.FORCE_COLOR or "3", 10) or 3, 3)
-- 	end

-- 	return nil
-- end

-- local function translateLevel(level): boolean | { level: number, hasBasic: boolean, has256: boolean, has16m: boolean }
-- 	if level == 0 then
-- 		return false
-- 	end

-- 	return {
-- 		level = level,
-- 		hasBasic = true,
-- 		has256 = level >= 2,
-- 		has16m = level >= 3,
-- 	}
-- end

-- local function _supportsColor(haveStream, options_)
-- 	local options = options_ or {}
-- 	local streamIsTTY = options.streamIsTTY
-- 	local sniffFlags = if options.sniffFlags == nil then true else options.sniffFlags
-- 	local noFlagForceColor = envForceColor()
-- 	if noFlagForceColor ~= nil then
-- 		flagForceColor = noFlagForceColor
-- 	end

-- 	local forceColor = if sniffFlags then flagForceColor else noFlagForceColor

-- 	if forceColor == 0 then
-- 		return 0
-- 	end

-- 	if sniffFlags then
-- 		if hasFlag("color=16m") or hasFlag("color=full") or hasFlag("color=truecolor") then
-- 			return 3
-- 		end

-- 		if hasFlag("color=256") then
-- 			return 2
-- 		end
-- 	end

-- 	-- Check for Azure DevOps pipelines.
-- 	-- Has to be above the `!streamIsTTY` check.
-- 	if process.env.TF_BUILD and process.env.AGENT_NAME then
-- 		return 1
-- 	end

-- 	if haveStream and not streamIsTTY and forceColor == nil then
-- 		return 0
-- 	end

-- 	local min = forceColor or 0

-- 	if process.env.TERM == "dumb" then
-- 		return min
-- 	end

-- 	-- Lua note: we assume Win10 post-2017 is always the case for now, otherwise we'd have to use os.exec to probe
-- 	-- if (process.platform == 'win32') {
-- 	-- 	-- Windows 10 build 10586 is the first Windows release that supports 256 colors.
-- 	-- 	-- Windows 10 build 14931 is the first release that supports 16m/TrueColor.
-- 	-- 	local osRelease = os.release().split('.');
-- 	-- 	if (
-- 	-- 		Number(osRelease[0]) >= 10
-- 	-- 		&& Number(osRelease[2]) >= 10_586
-- 	-- 	) {
-- 	-- 		return Number(osRelease[2]) >= 14_931 ? 3 : 2;
-- 	-- 	}

-- 	-- 	return 1;
-- 	-- }

-- 	if process.env.CI then
-- 		if process.env.GITHUB_ACTIONS then
-- 			return 3
-- 		end

-- 		if
-- 			Array.some({ "TRAVIS", "CIRCLECI", "APPVEYOR", "GITLAB_CI", "BUILDKITE", "DRONE" }, function(sign)
-- 				return process.env[sign] ~= nil
-- 			end) or process.env.CI_NAME == "codeship"
-- 		then
-- 			return 1
-- 		end

-- 		return min
-- 	end

-- 	if process.env.TEAMCITY_VERSION then
-- 		-- Lua note: we assume TeamCity 9+ has color capabilities rather than a brittle regexp
-- 		-- return /^(9\.(0*[1-9]\d*)\.,\d{2,}\.)/.test(env.TEAMCITY_VERSION) ? 1 : 0;
-- 		return if (tonumber(string.sub(process.env.TEAMCITY_VERSION or "9.0", 1, 3)) or 9.0) > 9.0 then 1 else 0
-- 	end

-- 	if process.env.COLORTERM then
-- 		return 3
-- 	end

-- 	if process.env["xterm-kitty"] then
-- 		return 3
-- 	end

-- 	if process.env.TERM_PROGRAM then
-- 		local version = tonumber((process.env.TERM_PROGRAM_VERSION or "").split(".")[1], 10) or 0

-- 		if process.env.TERM_PROGRAM == "iTerm.app" then
-- 			return if version >= 3 then 3 else 2
-- 		elseif process.env.TERM_PROGRAM == "Apple_Terminal" then
-- 			return 2
-- 		end
-- 		-- No default
-- 	end

-- 	if string.find(process.env.TERM, "-256") then
-- 		return 2
-- 	end

-- 	if
-- 		Array.some({ "screen", "xterm", "vt100", "vt220", "rxvt", "color", "ansi", "cygwin", "linux" }, function(term)
-- 			return string.find(process.env.TERM, term) ~= nil
-- 		end)
-- 	then
-- 		return 1
-- 	end

-- 	if process.env.COLORTERM then
-- 		return 1
-- 	end

-- 	return min
-- end

-- local function createSupportsColor(stream, options_: Object?)
-- 	local options = options_ or {} :: Object
-- 	options.streamIsTTY = stream and stream.isTTY
-- 	local level = _supportsColor(stream, options)

-- 	return translateLevel(level)
-- end

-- local exports = {
-- 	createSupportsColor = createSupportsColor,
-- 	supportsColor = {
-- 		stdout = createSupportsColor({ isTTY = true }), -- Lua note: assume io.stdout is always a tty tty.isatty(1)}),
-- 		stderr = createSupportsColor({ isTTY = true }), -- Lua note: assume io.stdout is always a tty tty.isatty(2)}),
-- 	},
-- }

-- return exports
