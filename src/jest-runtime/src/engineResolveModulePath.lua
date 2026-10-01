--[[
	ScriptService:ResolveModulePath resolves a require-by-string path with the
	engine's own require navigator, so it understands everything `require`
	does (including `.config` aliases). It is gated behind an engine flag, so
	this is nil when the method is missing or disabled.
]]

type ResolveModulePath = (relativeTo: Instance, path: string) -> Instance

local engineResolveModulePath: ResolveModulePath? = nil

local hasScriptService, ScriptService = pcall(game.GetService, game, "ScriptService")
if hasScriptService and ScriptService then
	local isEnabled = pcall(function()
		return (ScriptService :: any):ResolveModulePath(script, "@self")
	end)

	if isEnabled then
		engineResolveModulePath = function(relativeTo: Instance, path: string): Instance
			return (ScriptService :: any):ResolveModulePath(relativeTo, path)
		end
	end
end

return engineResolveModulePath
