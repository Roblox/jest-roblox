-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-config/src/__tests__/__snapshots__/normalize.test.ts.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP

local exports = {}

exports["rootDir throws error when rootDir is string 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Directory <bold>rootDir</> in the <bold>rootDir</> option was not found.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

exports["rootDir throws error when rootDir is table 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Directory <bold>TABLE</> in the <bold>rootDir</> option was not found.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

-- ROBLOX deviation START: not supported
-- exports["displayName generates a default color for the runner jest-runner 1"] = [["yellow"]]

-- exports["displayName generates a default color for the runner jest-runner-eslint 1"] = [["magenta"]]

-- exports["displayName generates a default color for the runner jest-runner-tsc 1"] = [["red"]]

-- exports["displayName generates a default color for the runner jest-runner-tslint 1"] = [["green"]]

-- exports["displayName generates a default color for the runner undefined 1"] = [["white"]]
-- ROBLOX deviation END

exports["displayName should throw an error when displayName is is an empty object 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

exports["displayName should throw an error when displayName is missing color 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

exports["displayName should throw an error when displayName is missing name 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

exports["displayName should throw an error when displayName is using invalid values 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

-- ROBLOX deviation START: not supported
-- exports["extensionsToTreatAsEsm should enforce leading dots 1"] = [[
-- ● Validation Error:

--   Option: extensionsToTreatAsEsm: ['ts'] includes a string that does not start with a period (.).
--   Please change your configuration to extensionsToTreatAsEsm: ['.ts'].

--   Configuration Documentation:
--   https://jestjs.io/docs/configuration
-- ]]

-- exports["extensionsToTreatAsEsm throws on .cjs 1"] = [[
-- ● Validation Error:

--   Option: extensionsToTreatAsEsm: ['.cjs'] includes '.cjs' which is always treated as CommonJS.

--   Configuration Documentation:
--   https://jestjs.io/docs/configuration
-- ]]

-- exports["extensionsToTreatAsEsm throws on .js 1"] = [[
-- ● Validation Error:

--   Option: extensionsToTreatAsEsm: ['.js'] includes '.js' which is always inferred based on type in its nearest package.json.

--   Configuration Documentation:
--   https://jestjs.io/docs/configuration
-- ]]

-- exports["extensionsToTreatAsEsm throws on .mjs 1"] = [[
-- ● Validation Error:

--   Option: extensionsToTreatAsEsm: ['.mjs'] includes '.mjs' which is always treated as an ECMAScript Module.

--   Configuration Documentation:
--   https://jestjs.io/docs/configuration
-- ]]

-- exports['preset throws when module was found but no "jest-preset.js" or "jest-preset.json" files 1'] = [[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Module <bold>exist-but-no-jest-preset</> should have \"jest-preset.js\" or \"jest-preset.json\" file at the root.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]

-- exports["preset throws when preset not found 1"] = [[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Preset <bold>doesnt-exist</> not found.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]
-- ROBLOX deviation END

exports["rootDir throws if the options is missing a rootDir property 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Configuration option <bold>rootDir</> must be specified.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

-- exports["runner throw error when a runner is not found 1"] = [[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Jest Runner <bold>missing-runner</> cannot be found. Make sure the <bold>runner</> configuration option points to an existing node module.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]

-- ROBLOX deviation START: not supported
-- exports["setupTestFrameworkScriptFile logs a deprecation warning when `setupTestFrameworkScriptFile` is used 1"] = [[
-- "<yellow><bold><bold>●</><bold> Deprecation Warning</>:</>
-- <yellow></>
-- <yellow>  Option <bold>\"setupTestFrameworkScriptFile\"</> was replaced by configuration <bold>\"setupFilesAfterEnv\"</>, which supports multiple paths.</>
-- <yellow></>
-- <yellow>  Please update your configuration.</>
-- <yellow></>
-- <yellow>  <bold>Configuration Documentation:</></>
-- <yellow>  https://jestjs.io/docs/configuration</>
-- <yellow></>"
-- ]]

-- exports["setupTestFrameworkScriptFile logs an error when `setupTestFrameworkScriptFile` and `setupFilesAfterEnv` are used 1"] =
-- 	[[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Options: <bold>setupTestFrameworkScriptFile</> and <bold>setupFilesAfterEnv</> cannot be used together.</>
-- <red>  Please change your configuration to only use <bold>setupFilesAfterEnv</>.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]

-- exports["testEnvironment throws on invalid environment names 1"] = [[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Test environment <bold>phantom</> cannot be found. Make sure the <bold>testEnvironment</> configuration option points to an existing node module.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]
-- ROBLOX deviation END

exports["testMatch throws if testRegex and testMatch are both specified 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Configuration options <bold>testMatch</> and <bold>testRegex</> cannot be used together.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

exports["testPathPattern <regexForTestFiles> ignores invalid regular expressions and logs a warning 1"] =
	[["<red>  Invalid testPattern a( supplied. Running all tests instead.</>"]]

exports["testPathPattern --testPathPattern ignores invalid regular expressions and logs a warning 1"] =
	[["<red>  Invalid testPattern a( supplied. Running all tests instead.</>"]]

exports["testTimeout should throw an error if timeout is a negative number 1"] = [[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>testTimeout</>\" must be a natural number.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://jestjs.io/docs/configuration</>
<red></>"
]]

-- exports["watchPlugins throw error when a watch plugin is not found 1"] = [[
-- "<red><bold><bold>● </><bold>Validation Error</>:</>
-- <red></>
-- <red>  Watch plugin <bold>missing-plugin</> cannot be found. Make sure the <bold>watchPlugins</> configuration option points to an existing node module.</>
-- <red></>
-- <red>  <bold>Configuration Documentation:</></>
-- <red>  https://jestjs.io/docs/configuration</>
-- <red></>"
-- ]]

return exports
