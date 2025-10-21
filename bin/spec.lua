--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace

if ReplicatedStorage:FindFirstChild("Packages") then
	Workspace = ReplicatedStorage.Packages._Workspace
	-- rojo doesn't combine folders in the DM with the same name
	for _, child in ipairs(ReplicatedStorage.Packages.TestRoot:GetChildren()) do
		child.Parent = Workspace
	end
else
	Workspace = script.Parent.JestRoblox._Workspace
end

local Jest = require(Workspace.Jest.Jest)
local runCLI = Jest.runCLI
local args = Jest.args

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local status, result = runCLI(Workspace, {
	verbose = args.verbose,
	ci = args.ci,
	updateSnapshot = args.updateSnapshot,
	testPathPattern = args.testPathPattern,
	testNamePattern = args.testNamePattern,
	reporters = if args.githubActions then { "default", "github-actions" } else nil
}, { Workspace }):awaitStatus()

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
