local Workspace = script.Parent

return {
	setupFilesAfterEnv = { Workspace.testSetupFile },
	testMatch = { "**/*.(spec|test)?(.lua|.luau)", "**/__tests__/index" },
	-- Wally-installed dependencies live under Packages/_Index/<pkg>@<ver>/ and
	-- may ship their own __tests__ files (unless the dependency's wally.toml
	-- excludes them at publish time — not something we control).
	testPathIgnorePatterns = { "/_Index/" },
	snapshotSerializers = { Workspace.normalizeStackTraces },
}
