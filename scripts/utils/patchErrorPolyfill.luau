local fs = require("@lute/fs")

local OPTIMIZE_DIRECTIVE = "--!optimize 1"

return function(path)
	local file = fs.open(path, "r+")
	if file == nil then
		error(`Failed to open file: {path}`)
	end

	local contents = string.split(fs.readfiletostring(path), "\n")

	if contents[1] ~= OPTIMIZE_DIRECTIVE then
		table.insert(contents, 1, OPTIMIZE_DIRECTIVE)
		fs.write(file, table.concat(contents, "\n"))
	end

	fs.close(file)
end
