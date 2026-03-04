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
}
local cwd = process.cwd()
local ci: boolean = table.find(extraArgs, "--ci") ~= nil

local patchErrorPolyfill = require("./utils/patchErrorPolyfill")
patchErrorPolyfill("Packages/_Index/LuauPolyfill/LuauPolyfill/Error/Error.global.lua")

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
		"ocale.project.json",
		"--verbose",
	})

	return
end

local runCmd = {
	"robloxdev-cli",
	"run",
	"--load.model",
	"default.project.json",
	"--run",
	"scripts/run-tests.luau",
	"--testService.errorExitCode=1",
}

if configuration == "default" then
	table.insert(runCmd, "--load.asRobloxScript")
	table.insert(runCmd, "--fastFlags.allOnLuau")
	table.insert(runCmd, "--fastFlags.overrides")
	table.insert(runCmd, "EnableLoadModule=true")
	table.insert(runCmd, "EngineStylingEnabled2=true")
	table.insert(runCmd, "EnableInstanceGetStyledAPI=true")
	table.insert(runCmd, "InstanceGetStyledPublicSecurity=true")
	-- Enable headless renderer for styling support
	table.insert(runCmd, "--headlessRenderer=true")
	table.insert(runCmd, "--virtualInput=true")

	if ci then
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

if configuration == "loadstring" then
	table.insert(runCmd, "--load.asRobloxScript")
	table.insert(runCmd, "--fastFlags.overrides")
	table.insert(runCmd, "EnableLoadModule=false")
	table.insert(runCmd, "EngineStylingEnabled2=true")
	table.insert(runCmd, "EnableInstanceGetStyledAPI=true")
	table.insert(runCmd, "InstanceGetStyledPublicSecurity=true")
	-- Enable headless renderer for styling support
	table.insert(runCmd, "--headlessRenderer=true")
	table.insert(runCmd, "--virtualInput=true")
end

if #extraArgs > 0 then
	table.insert(runCmd, "--")
	table.move(extraArgs, 1, #extraArgs, #runCmd + 1, runCmd)
end

run(runCmd)
