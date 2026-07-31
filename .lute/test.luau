local fs = require("@std/fs")
local process = require("@lute/process")
local run = require("./utils/run")

local ARGS = { ... }
local configuration = ARGS[2]
local extraArgs: { string } = table.move(ARGS, 3, #ARGS, 1, {})

local availableConfigurations = {
	"default",
	"loadstring",
	"deferredlua",
	"ocale",
	"update-snapshots",
}
local cwd = process.cwd()
local ci: boolean = table.find(extraArgs, "--ci") ~= nil

-- Package layout selector. Defaults to the public, Wally-shaped
-- default.project.json (what CI and external contributors use); pass
-- `--rotriever` to target the internal rotriever.project.json, which aliases
-- externals out of their nested Rotriever _Index locations. This single flag
-- drives both the local robloxdev-cli flows and the rocale cloud flow.
local rotriever: boolean = table.find(extraArgs, "--rotriever") ~= nil
local projectFile = if rotriever then "rotriever.project.json" else "default.project.json"

-- LuauPolyfill's Error.global.lua sits at different paths under Rotriever
-- (internal, PascalCase, no version) vs. Wally (public, kebab-case, versioned).
-- Try both — patchErrorPolyfill no-ops on the one that doesn't exist.
local patchErrorPolyfill = require("./utils/patchErrorPolyfill")
patchErrorPolyfill("Packages/_Index/LuauPolyfill/LuauPolyfill/Error/Error.global.lua")
patchErrorPolyfill("Packages/_Index/roblox_luau-polyfill@1.2.5/luau-polyfill/src/Error/Error.global.lua")

if not table.find(availableConfigurations, configuration) then
	error(
		`Invalid test configuration {configuration}\n`
			.. `Configuration must be one of: {table.concat(availableConfigurations, ", ")}\n`
	)
end

if configuration == "ocale" then
	if not process.env.ROBLOX_API_KEY then
		error("ROBLOX_API_KEY environment variable is not set")
	end

	local universeId = tonumber(process.env.ROBLOX_UNIVERSE_ID)
		or error("ROBLOX_UNIVERSE_ID environment variable is not set")
	local placeId = tonumber(process.env.ROBLOX_PLACE_ID) or error("ROBLOX_PLACE_ID environment variable is not set")

	-- Build against the layout selected above (Wally default, --rotriever for the
	-- internal layout, T11/T28). Dependency __tests__ live under Packages/_Index/
	-- in both layouts, so testPathIgnorePatterns ({ "/_Index/" }) excludes them
	-- from discovery without any project-file surgery.
	run({
		"rocale-cli",
		"run",
		"--script",
		"scripts/run-tests.luau",
		"--universeId",
		universeId,
		"--placeId",
		placeId,
		"--load.project",
		projectFile,
		"--verbose",
	})

	return
end

local runCmd = {
	"rbx-aged-cli",
	"run",
	"robloxdev-cli",
	"--",
	"run",
	"--load.place",
	projectFile,
	"--run",
	"scripts/run-tests.luau",
	"--testService.errorExitCode=1",
}

if configuration == "loadstring" then
	table.insert(runCmd, "--load.asRobloxScript")
end

-- Snapshot regeneration runs the same engine configuration as `default`; the
-- only difference is that Jest writes the snapshots instead of comparing them.
if configuration == "default" or configuration == "update-snapshots" then
	table.insert(runCmd, "--load.asRobloxScript")
	table.insert(runCmd, "--fastFlags.allOnLuau")
	table.insert(runCmd, "--fastFlags.overrides")
	table.insert(runCmd, "EnableLoadModule=true")
	table.insert(runCmd, "EngineStylingEnabled2=true")
	table.insert(runCmd, "EnableInstanceGetStyledAPI=true")
	table.insert(runCmd, "InstanceGetStyledPublicSecurity=true")
	table.insert(runCmd, "--headlessRenderer=true") -- Enable headless renderer for styling support
	table.insert(runCmd, "--virtualInput=true")

	-- Coverage is only wanted from CI's verification run. Every other run gets
	-- workspace write access instead, which is what lets a snapshot run persist
	-- regenerated .snap.lua files.
	if ci and configuration == "default" then
		table.insert(runCmd, "--coverage.on")
		table.insert(runCmd, "--coverage.includes")
		table.insert(runCmd, "src/*")
	else
		table.insert(runCmd, `--fs.readwrite={cwd}`)
	end
end

if configuration == "deferredlua" then
	table.insert(runCmd, "--load.asRobloxScript")
	table.insert(runCmd, "--fastFlags.allOnLuau")
	table.insert(runCmd, "--fastFlags.overrides")
	table.insert(runCmd, "EnableLoadModule=true")
	table.insert(runCmd, "DebugForceDeferredSignalBehavior=true")
	table.insert(runCmd, "EngineStylingEnabled2=true")
	table.insert(runCmd, "EnableInstanceGetStyledAPI=true")
	table.insert(runCmd, "InstanceGetStyledPublicSecurity=true")
	-- Enable headless renderer for styling support
	table.insert(runCmd, "--headlessRenderer=true")
	table.insert(runCmd, "--virtualInput=true")
end

-- Forward any remaining flags (e.g. --ci, testPathPattern) to run-tests.luau,
-- but drop --rotriever: it selects the layout here and is not a runner arg.
local passthroughArgs = {}
for _, arg in extraArgs do
	if arg ~= "--rotriever" then
		table.insert(passthroughArgs, arg)
	end
end

if configuration == "update-snapshots" then
	print("Regenerating snapshots — .snap.lua files will be rewritten in place.")
	table.insert(passthroughArgs, "--update-snapshots")
end

if #passthroughArgs > 0 then
	table.insert(runCmd, "--")
	table.move(passthroughArgs, 1, #passthroughArgs, #runCmd + 1, runCmd)
end

fs.move("foreman.toml", "foreman.toml.public")
fs.move("foreman-internal.toml", "foreman.toml")

local ok, err = pcall(run, runCmd)

fs.move("foreman.toml", "foreman-internal.toml")
fs.move("foreman.toml.public", "foreman.toml")

if not ok then
	error(err)
end
