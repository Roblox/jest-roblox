local Workspace = script.Parent

return {
	setupFilesAfterEnv = { Workspace.testSetupFile },
	testMatch = { "**/*.(spec|test)?(.lua|.luau)", "**/__tests__/index" },
	snapshotSerializers = { Workspace.normalizeStackTraces }
}
