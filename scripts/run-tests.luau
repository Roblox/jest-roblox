--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
]]

-- Thin entry point uploaded via `rocale-cli --script`, and the same script the
-- local robloxdev-cli flows run. Runner logic lives in Packages.TestRunner
-- (rojo-mounted from scripts/lib/testRunner.luau); pass `--update-snapshots`
-- to regenerate snapshots rather than verify them.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
	or script.Parent:FindFirstChild("JestRoblox")
assert(Packages, "Could not find Packages tree — check the project file")

local TestRunner = require(Packages.TestRunner)
return TestRunner()
