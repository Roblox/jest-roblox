local function removeRootFromStackTrace(line: string): string
	return line:gsub("LoadedCode.JestRoblox.", ""):gsub("ReplicatedStorage.Packages.", "")
end

local function serialize(val: string | { [any]: any }, config, indentation, depth, refs, printer): string
	if typeof(val) == "table" then
		val.message = removeRootFromStackTrace(val.message)
	elseif typeof(val) == "string" then
		val = removeRootFromStackTrace(val)
	end

	return printer(
		val,
		config,
		indentation,
		depth,
		refs,
		printer
	)
end

local function containsStackTrace(val: string): boolean
	return string.find(val, "%s*LoadedCode%.JestRoblox") ~= nil
		or string.find(val, "%s*ReplicatedStorage%.Packages") ~= nil
end

local function test(val: any): boolean
	return (typeof(val) == "string" and containsStackTrace(val)) or (typeof(val) == "table" and typeof(val.message) == "string" and containsStackTrace(val.message))
end

return {
	serialize = serialize,
	test = test,
}
