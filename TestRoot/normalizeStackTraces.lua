-- Dependency packages whose *internal* frames surface in stack-trace snapshots.
-- Wally mounts them versioned under `_Index/roblox_<pkg>@<ver>/<pkg>` while
-- Rotriever mounts them flat under a PascalCase alias, so the same frame renders
-- differently per layout. Canonicalizing to the alias (and dropping the churny
-- line numbers inside third-party code) keeps snapshots stable across both
-- package managers and across dependency version bumps.
local DEPENDENCY_ALIASES: { { pattern: string, canonical: string } } = {
	{ pattern = "luau%-polyfill", canonical = "LuauPolyfill" },
	{ pattern = "promise", canonical = "Promise" },
}

local function removeRootFromStackTrace(line: string): string
	line = line:gsub("LoadedCode%.JestRoblox%.", ""):gsub("ReplicatedStorage%.Packages%.", "")
	-- Rotriever's native layout nests each workspace member under
	-- `_Workspace/<Member>/<Member>`, so its frames render as
	-- `_Workspace.Expect.Expect.…`. Collapse that to the flat `Expect.…` form the
	-- Wally layout produces so a single snapshot set matches both. (%1 is a
	-- back-reference to the captured member name, matching the doubled folder.)
	line = line:gsub("_Workspace%.(%w+)%.%1%.", "%1.")
	-- Collapse each layout's _Index wrapper to the bare package folder. Wally
	-- nests deps as `_Index.roblox_<pkg>@<ver>.<pkg>`; Rotriever nests them as
	-- `_Index.<Pkg>.<Pkg>` (%1 back-references the doubled folder name). Both
	-- reduce to `<pkg>.…` so dependency frames render identically per layout.
	line = line:gsub("_Index%.roblox_[%w%-]+@[%d%.]+%.", "")
	line = line:gsub("_Index%.(%w+)%.%1%.", "%1.")
	for _, dep in DEPENDENCY_ALIASES do
		line = line:gsub(dep.pattern, dep.canonical)
		line = line:gsub("(" .. dep.canonical .. "[%w%.]*):%d+", "%1")
	end
	return line
end

local function serialize(val: string | { [any]: any }, config, indentation, depth, refs, printer): string
	if typeof(val) == "table" then
		val.message = removeRootFromStackTrace(val.message)
	elseif typeof(val) == "string" then
		val = removeRootFromStackTrace(val)
	end

	return printer(val, config, indentation, depth, refs, printer)
end

local function containsStackTrace(val: string): boolean
	return string.find(val, "%s*LoadedCode%.JestRoblox") ~= nil
		or string.find(val, "%s*ReplicatedStorage%.Packages") ~= nil
end

local function test(val: any): boolean
	return (typeof(val) == "string" and containsStackTrace(val))
		or (typeof(val) == "table" and typeof(val.message) == "string" and containsStackTrace(val.message))
end

return {
	serialize = serialize,
	test = test,
}
