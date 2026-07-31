local fs = require("@std/fs")

local OPTIMIZE_DIRECTIVE = "--!optimize 1"

-- Prepend `--!optimize 1` to `path` if not already present. The directive is
-- a performance hint, not a correctness requirement — if the file doesn't
-- exist (e.g. LuauPolyfill was installed under a different layout than the
-- caller expected), silently no-op rather than aborting the whole test run.
-- `fs.open` raises on missing files rather than returning nil, so wrap with
-- pcall to convert that failure mode into the same silent skip.
return function(path)
	local ok, file = pcall(fs.open, path, "r+")
	if not ok or file == nil then
		return
	end

	local contents = string.split(fs.readFileToString(path), "\n")

	if contents[1] ~= OPTIMIZE_DIRECTIVE then
		table.insert(contents, 1, OPTIMIZE_DIRECTIVE)
		fs.write(file, table.concat(contents, "\n"))
	end

	fs.close(file)
end
