<h1 align="center">Jest Roblox!</h1>

<div align="center">
	<a href="https://create.roblox.com/store/asset/16031830738/JestRoblox">
		<img src="./.github/assets/link-creator-store.svg" alt="Get it on Creator Store" />
	</a>
	<a href="CONTRIBUTING.md">
		<img src="./.github/assets/link-contributions.svg" alt="Contributions welcome" />
	</a>
	<a href="https://wally.run/package/roblox/jest">
		<img src="./.github/assets/link-wally.svg" alt="Wally (external link)" />
	</a>
	<br>
	<a href="https://github.com/Roblox/jest-roblox/actions/workflows/analyze.yml">
		<img src="https://github.com/Roblox/jest-roblox/actions/workflows/analyze.yml/badge.svg" alt="Analyze workflow status" />
	</a>
	<a href="https://roblox.github.io/jest-roblox/">
		<img src="https://img.shields.io/badge/docs-website-green.svg" alt="Documentation" />
	</a>
	<a href="https://coveralls.io/github/Roblox/jest-roblox">
		<img src="https://coveralls.io/repos/github/Roblox/jest-roblox/badge.svg?t=4czPqO&kill_cache=1" alt="Coverage Status" />
	</a>
</div>

<div>&nbsp;</div>

Jest Roblox is a Roblox port of [Jest v27.4.7](https://github.com/facebook/jest/tree/v27.4.7), the open source JavaScript testing framework.

Jest Roblox can run within Roblox itself, including via Roblox's OCALE (Open Cloud API for Luau Execution) for testing on CI systems.

We use Jest Roblox at Roblox for testing our apps, in-game core scripts, built-in Roblox Studio plugins, as well as libraries like [Roact Navigation](https://github.com/Roblox/roact-navigation).

---

## Installation

### Wally

Add the packages you need to your `wally.toml`'s dev-dependencies:

```toml
[dev-dependencies]
Jest = "roblox/jest@=3.20.0"
JestGlobals = "roblox/jest-globals@=3.20.0"
```

Then run `wally install`. See [wally.run/package/roblox/jest](https://wally.run/package/roblox/jest) and its siblings for the full set — Jest Roblox publishes 34 modules under the `roblox/*` scope, one per package in `src/`.

### Creator Store

Install Jest Roblox directly from the [Creator Store](https://create.roblox.com/store/asset/16031830738/JestRoblox) and drag the resulting `rbxm` into your project.

<details>
<summary>Internal</summary>

Add the packages you need to your `rotriever.toml`'s dev-dependencies:

```toml
[dev_dependencies]
Jest = "3.20.0"
JestGlobals = "3.20.0"
```

Then run `rotrieve install`.

</details>

## Usage

Author test suites as `.spec.lua` (or `.spec.luau`) files under any `__tests__/` directory in your project:

```luau
local JestGlobals = require(Packages.JestGlobals)
local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

describe("addition", function()
    it("adds two numbers", function()
        expect(1 + 1).toBe(2)
    end)
end)
```

See the [documentation site](https://roblox.github.io/jest-roblox/) for the full matcher API, mocking, snapshots, and configuration.

---

## Contributing
Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for information.

## License
Jest Roblox is available under the MIT license. See [LICENSE](LICENSE) for details.
