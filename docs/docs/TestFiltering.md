---
id: test-filtering
title: Test Filtering
---

Jest Roblox provides several ways to filter which tests are executed, making it easier to focus on and re-run specific test cases during development.

## Using `only` and `skip`

`.only` and `.skip` lets you control which tests are run **within a specific test file**. It does not affect tests in other files.

`describe.only` or `test.only` will only run the `describe` or `test` blocks marked with `.only`. On the other hand, `.skip` will guarantee that all `describe` or `test` blocks marked with it will be excluded from execution.

```lua
describe.only('run this describe block', function()
	test('this will run', function()
		expect(true).toBe(true)
	end)

	test.skip('but this will not run', function()
		expect(true).toBe(false)
	end)

	describe.skip('none of these will run', function()
		test('this will not run', function()
			expect(true).toBe(false)
		end)

		test.only('this will not run either', function()
			expect(true).toBe(false)
		end)
	end)
end)

test.only('also run this block', function()
	expect(true).toBe(true)
end)

test('do not run this block', function()
	expect(true).toBe(false)
end)
```

## Running tests by file name

Jest Roblox allows you to specify which test files to run a number of different ways.

:::caution
Matching by test file names only works as expected if Jest Roblox is run in an environment where it is able to resolve datamodel paths to filesystem paths (i.e. if you see test filesystem paths being reported in the test results). Otherwise, test path filtering will match against the path of the test in the datamodel, which is not necessarily the filesystem path and may be unintuitive.
:::

### Using `testMatch`

The [`testMatch`](configuration#testmatch-arraystring) configuration option allows you to define a set of glob patterns of tests to discover. By default, it will detect all `.spec.lua` or `.test.lua` files or any files inside a `__tests__` directory. Generally, the default is sensible unless you have files under `__tests__` that are not explicitly test files that you do not want run, in which case you may want to filter for `testMatch = { "**/*.test.lua" }`.

This option can also be defined as an argument to [`runCLI`](cli#testmatch-arraystring), which will apply globally and override any existing ones set by the `testMatch` configuration option in any `jest.config.lua` files.

[`testRegex`](configuration#testregex-string--arraystring) does the same thing but matches against a regex pattern instead of a glob. This configuration option is mutually exclusive with `testMatch`. For example `testRegex = { "foo\\.lua$" }` will match all test paths ending in `foo.lua`.

An important thing to note is that this option defines the set of tests discovered by Jest Roblox, so any further test filtering only applies if the test was discovered to begin with.

### Using `testPathPattern`

The [`testPathPattern`](cli#testpathpattern-regex) argument allows you to filter tests that match a file regex pattern. This will run all tests in files that contain "skippity" in their path.
```lua
Jest.runCLI(root, {
    testPathPattern = "skippity"
}, { root }):awaitStatus()
```

Similarly, [`testPathIgnorePattern`](cli#testpathignorepatterns-arrayregex) takes a list of patterns to exclude from the test run. This will exclude all tests in files that contain "skippity" in their path.
```lua
Jest.runCLI(root, {
    testPathIgnorePatterns = { "skippity" }
}, { root }):awaitStatus()
```

An easy way to filter by paths from the command line is to set `testPathPattern` to a Lua global, (e.g. `testPathPattern = _G.JEST_TESTPATHPATTERN`) and then use the `--lua.globals` flag in `roblox-cli` to set the value.

## Running tests by test name

### Using `testNamePattern`

The [`testNamePattern`](cli#testnamepattern-regex) argument can be used to only run tests that match a given regex pattern. It matches against the full path of test in the test hierarchy for the file that it is in (i.e. the test name and the entire chain of parent describe blocks).

Example:
```lua
describe("block A", function()
	test("test one", function()
		expect(true).toBe(true)
	end)

	test("test two", function()
		expect(true).toBe(true)
	end)
end)

describe("block B", function()
	test("test three", function()
		expect(true).toBe(true)
	end)
end)

test("test one two three", function()
	expect(true).toBe(true)
end)

-- "block A": matches "test one" and "test two"
-- "block A test one": matches "test one"
-- "test one": matches "test one" and "test one two three"
-- "block B": matches "test three"
-- "block B test one": matches no tests
```
