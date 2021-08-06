local Expectation = require(script.TestEZ.Expectation)
local TestBootstrap = require(script.TestEZ.TestBootstrap)
local TestEnum = require(script.TestEZ.TestEnum)
local TestPlan = require(script.TestEZ.TestPlan)
local TestPlanner = require(script.TestEZ.TestPlanner)
local TestResults = require(script.TestEZ.TestResults)
local TestRunner = require(script.TestEZ.TestRunner)
local TestSession = require(script.TestEZ.TestSession)
local TextReporter = require(script.TestEZ.Reporters.TextReporter)
local TextReporterQuiet = require(script.TestEZ.Reporters.TextReporterQuiet)
local TeamCityReporter = require(script.TestEZ.Reporters.TeamCityReporter)

local function run(testRoot, callback)
	local modules = TestBootstrap:getModules(testRoot)
	local plan = TestPlanner.createPlan(modules)
	local results = TestRunner.runPlan(plan)

	callback(results)
end

local TestEZ = {
	run = run,

	Expectation = Expectation,
	TestBootstrap = TestBootstrap,
	TestEnum = TestEnum,
	TestPlan = TestPlan,
	TestPlanner = TestPlanner,
	TestResults = TestResults,
	TestRunner = TestRunner,
	TestSession = TestSession,

	Reporters = {
		TextReporter = TextReporter,
		TextReporterQuiet = TextReporterQuiet,
		TeamCityReporter = TeamCityReporter,
	},
}

TestEZ.Globals = require(script.Globals)

return TestEZ
