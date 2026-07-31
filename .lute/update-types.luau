local fs = require("@std/fs")
local run = require("./utils/run")

-- Refresh globalTypes.d.luau, the Roblox API type definitions that luau-lsp
-- analyses against. luau-lsp doesn't ship them -- its releases carry only the
-- binaries and the Studio plugin -- they're generated from the Roblox API dump
-- by a scheduled job in the luau-lsp repo, so they have to be fetched.
--
-- The result is committed so that `lute run analyze` needs no network and gives
-- the same answer today as it did last week. Upstream regenerates the file
-- whenever the API dump moves, so fetching it per analyze run would let CI break
-- (or start passing) with no change of ours. Run this deliberately -- when
-- bumping luau-lsp, or to pick up newly released Roblox APIs -- and commit the
-- diff.

local DEFS_FILE = "globalTypes.d.luau"

-- Track the luau-lsp version pinned in foreman.toml, so the definitions always
-- match the analyser that reads them. Upstream tags carry no `v` prefix.
local function pinnedAnalyzerVersion(): string
	local manifest = fs.readFileToString("foreman.toml")
	local version = string.match(manifest, 'luau%-lsp%s*=%s*{[^}]-version%s*=%s*"=?([^"]+)"')

	return version or error("Could not find a luau-lsp version pinned in foreman.toml")
end

local version = pinnedAnalyzerVersion()

print(`Fetching {DEFS_FILE} for luau-lsp {version}...`)

run({
	"curl",
	"-fsSL",
	"-o",
	DEFS_FILE,
	`https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/{version}/scripts/globalTypes.d.luau`,
})

print(`Wrote {DEFS_FILE}. Commit it if anything changed.`)
