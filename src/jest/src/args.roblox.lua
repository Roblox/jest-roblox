local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local args = {}

if processServiceExists then
	for _, arg in ProcessService:GetCommandLineArgs() do
		local a = arg:split("=")
		a[1] = a[1]:gsub("^%-%-", "")
		args[a[1]] = a[2] or true
	end
end

return args
