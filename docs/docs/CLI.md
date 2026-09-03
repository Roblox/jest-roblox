---
id: cli
title: runCLI Options
---

The `Jest` package exports `runCLI`, which is the main entrypoint for running Jest Roblox tests. Its options are based on [Jest's CLI options](https://jest-archive-august-2023.netlify.app/docs/27.x/cli).

A basic entrypoint script can look like the following:

```lua title="spec.lua"
local Packages = script.Parent.YourProject.Packages
local Jest = require(Packages.Jest)
local runCLI = Jest.runCLI

local status, result = runCLI(Packages.Project, {
	verbose = false,
	ci = false,
}, { Packages.Project }):awaitStatus()

if status == "Rejected" then
	print(result)
	error(result)
end

if not result.results.success then
	error("Tests failed")
end
```

The first argument to `runCLI` is the root directory of your project, the second argument is a list of [options](#options), and the third argument is a list of projects (directories with a `jest.config.lua`) for Jest Roblox to discover.

<details>
<summary>Internal command-line runner</summary>

`Jest.args` exposes command-line arguments passed through `roblox-cli`. Include them after a `--` (double dash) or use the `--args` flag, then forward the values you need to `runCLI`:

```lua
local args = Jest.args

local status, result = runCLI(Packages.Project, {
	verbose = args.verbose,
	ci = args.ci,
	testPathPattern = args.testPathPattern,
	testNamePattern = args.testNamePattern,
}, { Packages.Project }):awaitStatus()
```

</details>

## Options

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc.filter((node) => node.level === 3)
}/>

## Reference

### `ci` \[boolean]

When this option is provided, Jest Roblox will assume it is running in a CI environment. This changes the behavior when a new snapshot is encountered. Instead of the regular behavior of storing a new snapshot automatically, it will fail the test and require Jest Roblox to be run with `updateSnapshot`.

### `clearMocks` \[boolean]

Automatically clear mock calls, instances, contexts and results before every test. Equivalent to calling [`jest.clearAllMocks()`](jest-object#jestclearallmocks) before each test. This does not remove any mock implementation that may have been provided.

### `debug` \[boolean]

Print debugging info about your Jest config.

### `expand` \[boolean]

Use this flag to show full diffs and errors instead of a patch.

### `json` \[boolean]

Prints the test results in JSON. This mode will send all other test output and user messages to stderr.

### `listTests` \[boolean]

Lists all test files that Jest Roblox will run given the arguments, and exits.

### `noStackTrace` \[boolean]

Disables stack trace in test results output.

### `passWithNoTests` \[boolean]

Allows the test suite to pass when no files are found.

### `reporters` \[array&lt;Instance|string|table&gt;]

Run tests with specified reporters. Refer to the [reporter configuration](configuration#reporters-arrayinstancestringtable) for details.

### `resetMocks` \[boolean]

Automatically reset mock state before every test. Equivalent to calling [`jest.resetAllMocks()`](jest-object#jestresetallmocks) before each test. This will lead to any mocks having their fake implementations removed but does not restore their initial implementation.

### `showConfig` \[boolean]

Print your Jest config and then exits.

### `stackDepth` \[number]

Limits the number of call frames printed in stack traces. The default of `0` prints the full stack trace.

### `testMatch` \[array&lt;string&gt;]

The glob patterns Jest uses to detect test files. Please refer to the [`testMatch` configuration](configuration#testmatch-arraystring) for details.

### `testNamePattern` \[regex]

Run only tests with a name that matches the regex. For example, suppose you want to run only tests related to authorization which will have names like `"GET /api/posts with auth"`, then you can use `testNamePattern = "auth"`.

:::tip

The regex is matched against the full name, which is a combination of the test name and all its surrounding describe blocks.

:::

### `testPathIgnorePatterns` \[array&lt;regex&gt;]

An array of regexp pattern strings that are tested against all tests paths before executing the test. Contrary to `testPathPattern`, it will only run those tests with a path that does not match with the provided regexp expressions.

### `testPathPattern` \[regex]

A regexp pattern string that is matched against all tests paths before executing the test.

### `testTimeout` \[number]

Default timeout of a test in milliseconds. Default value: 5000.

### `updateSnapshot` \[boolean]

Use this flag to re-record every snapshot that fails during this test run. Can be used together with a test suite pattern or with `testNamePattern` to re-record snapshots.

### `verbose` \[boolean]

Display individual test results with the test suite hierarchy.
