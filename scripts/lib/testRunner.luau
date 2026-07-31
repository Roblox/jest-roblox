--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
]]

--[[
	Shared jest-runner entry point. Mounted at Packages.TestRunner via
	default.project.json / rotriever.project.json so scripts/run-tests.luau can
	use it. rocale-cli's --script only uploads one file, so shared code has to
	live inside the rojo-built place tree — hence this mount.
]]

return function()
	-- Enable React testing globals (must be set before React is required).
	_G.__DEV__ = true
	_G.__ROACT_17_MOCK_SCHEDULER__ = true
	_G.__ROACT_17_INLINE_ACT__ = true

	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	-- Under legacy `--load.model default.project.json` invocations, the model
	-- was placed next to the runner script as `JestRoblox` — we retain that
	-- fallback for the internal test runner during the transition.
	local Packages = ReplicatedStorage:FindFirstChild("Packages")
		or script.Parent:FindFirstChild("JestRoblox")
	assert(Packages, "Could not find Packages tree — check the project file")

	local TestRoot = Packages:FindFirstChild("TestRoot")
	if TestRoot then
		for _, child in ipairs(TestRoot:GetChildren()) do
			child.Parent = Packages
		end
	end

	local Jest = require(Packages.Jest)
	local runCLI = Jest.runCLI
	local args = Jest.args

	local processServiceExists, ProcessService = pcall(function()
		return game:GetService("ProcessService")
	end)

	-- Rewriting .snap.lua files is opt-in via `--update-snapshots`, which only
	-- `lute run test update-snapshots` passes. Requiring the bare flag means
	-- any other spelling leaves snapshots verified rather than overwritten,
	-- which is the safe way to be wrong about it.
	local updateSnapshots = args["update-snapshots"] == true

	local status, result = runCLI(Packages, {
		verbose = args.verbose,
		ci = args.ci,
		updateSnapshot = updateSnapshots,
		testPathPattern = args.testPathPattern,
		testNamePattern = args.testNamePattern,
		reporters = if args.githubActions then { "default", "github-actions" } else nil,
	}, { Packages }):awaitStatus()

	if status == "Rejected" then
		print(result)
	end

	if status == "Resolved" and result.results.success then
		if processServiceExists then
			ProcessService:ExitAsync(0)
		end
	else
		if processServiceExists then
			ProcessService:ExitAsync(1)
		else
			error("Tests failed")
		end
	end

	return nil
end
