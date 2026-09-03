---
id: getting-started
title: Getting Started
slug: /
---

The Jest Roblox API is similar to [the API used by JavaScript Jest](https://jest-archive-august-2023.netlify.app/docs/27.x/api).

Jest Roblox tests run in a Roblox environment. You can run them in Studio or in [OCALE](https://create.roblox.com/docs/cloud/reference/features/luau-execution).

Add the `JestGlobals` and `Jest` packages to your dev dependencies in `wally.toml`.
```toml title="wally.toml"
[dev-dependencies]
Jest = "roblox/jest@^3.20.0"
JestGlobals = "roblox/jest-globals@^3.20.0"
```

Run `wally install` to install Jest Roblox.

<details>
<summary>Internal</summary>

Add the packages to your `rotriever.toml` instead:

```toml title="rotriever.toml"
[dev_dependencies]
Jest = "3.20.1"
JestGlobals = "3.20.1"
```

Then run `rotrieve install`.

The examples below use Wally package paths. Rotriever places dev dependencies under `Packages.Dev`, so require `Packages.Dev.Jest` and `Packages.Dev.JestGlobals` instead.

</details>

Create a `default.project.json` to set up your project structure and include the `Packages` directory created by Wally.
```json title="default.project.json"
{
	"name": "YourProject",
	"tree": {
		"$className": "Folder",
		"Packages": {
			"$path": "Packages",
			"Project": {
				"$path": "src"
			}
		}
	}
}
```

Create a `spec.lua` to point the test runner to the correct directory with your tests. This is the entrypoint for Jest Roblox. For more information, see [runCLI Options](cli).
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

<details>
<summary>Internal command-line runner</summary>

When running tests through `roblox-cli`, `Jest.args` exposes arguments passed to the test entrypoint. `ProcessService` can also return the test result as the process exit code:

```lua
local args = Jest.args
local ProcessService = game:GetService("ProcessService")

local status, result = runCLI(Packages.Project, {
	verbose = args.verbose,
	ci = args.ci,
}, { Packages.Project }):awaitStatus()

if status == "Rejected" then
	print(result)
	ProcessService:ExitAsync(1)
elseif result.results.success then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
```

Run the entrypoint with:

```bash
roblox-cli run --load.model default.project.json --run spec.lua --fastFlags.overrides EnableLoadModule=true
```

</details>

Inside `src`, create a basic [configuration](configuration) file.
```lua title="jest.config.lua"
return {
	testMatch = { "**/*.spec" }
}
```

Let's get started by writing a test for a hypothetical function that adds two numbers. First, create a `sum.lua` under your `src` directory.
```lua title="sum.lua"
return function(a, b)
	return a + b
end
```

Then, create a `__tests__` directory under your `src` directory and create a `sum.spec.lua` in it. This will contain our actual test:
```lua title="sum.spec.lua"
local Workspace = script.Parent.Parent
local Packages = Workspace.Parent

local JestGlobals = require(Packages.JestGlobals)
local it = JestGlobals.it
local expect = JestGlobals.expect

local sum = require(Workspace.sum)

it('adds 1 + 2 to equal 3', function()
	expect(sum(1, 2)).toBe(3)
end)
```

:::caution
Any functionality needed _must_ be explicitly required from `JestGlobals`, see [Globals](api).
:::

Finally, run `spec.lua` in your Roblox environment and your tests should pass!

**You just successfully wrote your first test using Jest Roblox!**

This test used `expect` and `toBe` to test that two values were exactly identical. To learn about other things that Jest Roblox can test, see [Using Matchers](using-matchers).
