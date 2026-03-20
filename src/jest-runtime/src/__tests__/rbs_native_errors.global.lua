-- Captures the actual error messages from the native require for @rbx and @std
-- passthrough paths. These vary across roblox-cli versions, so we capture them
-- dynamically rather than hardcoding expected strings.
--
-- This module must be loaded with the real Roblox native require, NOT Jest's
-- sandboxed require.

local function captureNativeError(path): string?
	local ok, err = pcall(function()
		(require :: any)(path)
	end)
	if ok then
		return nil
	end
	local msg = tostring(err)
	-- Strip the "LoadedCode...:line: " location prefix so we get just the
	-- engine's error message, which is the part toThrow will match against.
	return msg:match(":%d+:%s*(.+)$") or msg
end

return {
	rbx = captureNativeError("@rbx/ThisWillNeverExist"),
	std = captureNativeError("@std/ThisWillNeverExist"),
}
