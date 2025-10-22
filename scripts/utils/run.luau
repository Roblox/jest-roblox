local process = require("@lute/process")

return function(cmd)
	print(`> {table.concat(cmd, " ")}`)

	local ok, result = pcall(function()
		return process.run(cmd, { stdio = "inherit", env = { PATH = `{process.cwd()}:{process.env.PATH}` } })
	end)

	if not ok then
		error(result)
	end

	if result.ok then
		print(result.stdout)
		return result.stdout
	else
		error(`Error while running command: {result.stderr}`)
	end
end
