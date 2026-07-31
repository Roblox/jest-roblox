local fs = require("@std/fs")
local run = require("./utils/run")

print("Running static analysis...")

-- The Roblox API definitions are committed rather than fetched per run; see
-- .lute/update-types.luau for what they are and when to refresh them. Checked
-- up front so a fresh clone doesn't wait through an install to hear about it.
if not fs.exists("globalTypes.d.luau") then
	error("globalTypes.d.luau is missing. Run `lute run update-types` to fetch it, then commit the result.")
end

run({ "wally", "install" })

run({ "selene", "src" })
run({ "stylua", "-c", "src" })

run({ "rojo", "sourcemap", "default.project.json", "-o", "sourcemap.json" })

-- DevLinks holds the same kind of link module as Packages (see CONTRIBUTING.md)
-- and needs the same type re-exports, or dev-only types such as React.ReactElement
-- are unresolvable from tests. Unlike Packages, DevLinks is committed and survives
-- `wally install`, and wally-package-types can only parse a link module in its
-- unenriched one-line form — so reset each one before handing the directory over.
for _, entry in fs.listDirectory("DevLinks") do
	local name = string.match(entry.name, "^(.+)%.lua$")
	if name then
		fs.writeStringToFile(`DevLinks/{entry.name}`, `return require(script.Parent.Parent.{name})\n`)
	end
end

run({ "wally-package-types", "--sourcemap", "sourcemap.json", "Packages", "DevLinks" })

-- Wally wipes Packages/ on every install, so this override is rewritten each
-- time. Without it, luau-lsp strict-checks wally deps and their real types
-- can cascade into spurious errors in src/ (e.g. chalk-lua's shape doesn't
-- unify with how src/ treats it). Must run after wally-package-types, which
-- globs Packages/ and treats every file as a package module — writing this
-- beforehand risks it being swept into that walk.
fs.writeStringToFile(
	"Packages/.config.luau",
	[[
return {
	luau = {
		languagemode = "nocheck",
		lint = {
			["*"] = false,
		},
	},
}
]]
)

run({
	"luau-lsp",
	"analyze",
	"--defs",
	"globalTypes.d.luau",
	"--sourcemap",
	"sourcemap.json",
	-- Skip error reports from within wally-installed packages. We can't fix
	-- third-party dep code from this repo; type info from wally-package-types'
	-- generated .d.luau shims is still available for src/ analysis.
	"--ignore=**/Packages/**",
	"src",
})

run({ "rojo", "build", "default.project.json", "-o", "check.rbxm" })
