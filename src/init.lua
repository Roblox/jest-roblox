local TestEZ = require(script.TestEZ)
local Globals = require(script.Globals)

return {
	run = TestEZ.run,

	Expectation = TestEZ.Expectation,
	TestBootstrap = TestEZ.TestBootstrap,
	TestEnum = TestEZ.TestEnum,
	TestPlan = TestEZ.TestPlan,
	TestPlanner = TestEZ.TestPlanner,
	TestResults = TestEZ.TestResults,
	TestRunner = TestEZ.TestRunner,
	TestSession = TestEZ.TestSession,

	Reporters = TestEZ.Reporters,

	Globals = Globals
}