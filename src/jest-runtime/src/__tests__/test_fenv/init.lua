-- ROBLOX NOTE: no upstream

local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest

return {
	game = game,
	workspace = workspace,
	jest = jest,
}
