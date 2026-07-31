# Contributing to jest-roblox

[![Open for community contributions, click to learn more](./.github/assets/open-for-community-contributions.svg)](https://devforum.roblox.com/t/evolving-luau-oss-community-contributions-more/4566806)

Thanks for your interest in contributing! This document covers how to set up the project locally, run checks, and submit changes.

## Ways to Contribute

- **Bug Reports:** Open a [GitHub Issue](https://github.com/Roblox/jest-roblox/issues/new) with a clear description and reproduction steps. If possible, file an issue or create a pull request to fix the bug in upstream [Jest](https://github.com/facebook/jest) and link to it here.
- **Feature Requests:** Open an issue with your idea and rationale.
- **Code Contributions:** Clone this repository, create a branch, and submit a PR (see below for PR guidelines).

## Repository Structure

The repository is a multi-package [Wally](https://wally.run/) workspace with 34 packages. Source code lives under `src/`, with each package containing its own `src/` directory and tests at `src/__tests__/`.

```
src/
  jest/                        # Entry point; re-exports JestCore
  jest-globals/                # describe / it / expect / jest / beforeEach ...
  jest-core/                   # Test runner
  expect/                      # Assertion library
  pretty-format/               # Value serialization for diffs and snapshots
  jest-snapshot/               # Snapshot capture + comparison
  jest-diff/                   # Diff rendering for failed assertions
  jest-mock/                   # jest.fn, jest.spyOn, mock factories
  jest-fake-timers/            # jest.useFakeTimers()
  jest-benchmark/              # Micro-benchmark harness
  ... (24 more sub-packages under src/)
```

Please only make modifications in the directories above. You may notice there are duplicate config files for some of our tooling (`foreman.toml` vs `foreman-internal.toml`, per-module `rotriever.toml` vs per-module `wally.toml`). Repo maintainers use `foreman-internal.toml` to run the same tests on internal tooling. `default.project.json` describes the published Wally package layout, used for both the public analyze pipeline and local/CI OCALE testing; `rotriever.project.json` is the internal-only equivalent, used when `Packages/` is populated by `rotrieve install` instead of `wally install` (Rotriever vendors external dependencies per-workspace-member rather than flattening them, so its externals need separate aliasing); `.lute/` holds the local task scripts (`analyze`, `test`) invoked via `lute run <task>`.

Tests reach dev-only dependencies as `require(Packages.Dev.<Name>)`. Rotriever gives every workspace member its own `Dev` folder, so that resolves natively; Wally has no equivalent, and `DevLinks/` supplies it — `default.project.json` mounts that directory as `Packages.Dev`, and each module in it forwards to the flat `Packages.<Name>`. Forwarding through `require` rather than mounting the same file twice keeps both paths pointing at one ModuleScript, so `Packages.Dev.JestGlobals` and `Packages.JestGlobals` stay the same singleton. `lute run analyze` runs `wally-package-types` over `DevLinks/` alongside `Packages/` to re-export each target's Luau types, so treat those modules as generated: adding a dev dependency means writing the one-line `return require(script.Parent.Parent.<Name>)` and letting analyze fill in the rest.

If you want to add or modify any of the repo tooling (e.g. updating `foreman.toml` or a per-module `wally.toml`), please open an issue and reach out to the maintainers for assistance.

> [!NOTE]
> You may notice that we depend on some packages (for example, React) which are still based on the legacy source-available mirroring process (`jsdotlua/*`). We're in the process of upgrading our dependency graph so that we can more broadly accept Community Contributions throughout all of our dependencies.

## Code Guidelines

All CLI tools are installed via [Foreman](https://github.com/Roblox/foreman) (`foreman install`).

Contributions should follow existing code styling. In support of this, we use the following tools:

- All Luau code should be formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua) and pass [Selene](https://kampfkarren.github.io/selene/) linting.
- Static analysis uses [luau-lsp](https://github.com/JohnnyMorganz/luau-lsp). Run the full local pipeline (Selene, StyLua check, sourcemap, wally install, type check, build) with:

```bash
lute run analyze
```

This is defined in `.lute/analyze.luau` and is the same pipeline public CI runs — if it passes locally, it passes in CI.

Type checking needs `globalTypes.d.luau`, the Roblox API definitions. luau-lsp doesn't ship them, so they are fetched and committed rather than downloaded on every run — that keeps analyze offline and stops an upstream regeneration from changing CI's answer without a commit of ours. Refresh them deliberately, when bumping the pinned luau-lsp or to pick up newly released Roblox APIs, and commit the diff:

```bash
lute run update-types
```

Additionally:

1. Every functionality change should come with tests that express the desired behavior of the code being added.
2. Tests live in each module's `src/__tests__/` directory and run in CI via [rocale-cli](https://github.com/Roblox/rocale-cli). See the [rocale-cli repository](https://github.com/Roblox/rocale-cli) for instructions on setting up local test execution.
3. Small, incremental contributions are preferred over sweeping changes.

Running tests locally:

```bash
foreman install
wally install
export ROBLOX_API_KEY="your generated OCALE API key"
export ROBLOX_UNIVERSE_ID="your test universe id"
export ROBLOX_PLACE_ID="your test place id"
lute run test ocale
```

New snapshot tests fail on their first run, because writing a `.snap.lua` needs filesystem access the cloud runner doesn't have. Regenerate snapshots with the `update-snapshots` configuration, which runs locally through robloxdev-cli and rewrites the files in place:

```bash
lute run test update-snapshots
```

## Setting up a Fork

1. Create a fork of the repository using the GitHub UI.
2. Generate an API key for OCALE (skip if you already have this):
    - Create a new experience in Roblox Studio.
    - Go to your newly created experience, click on Places, and get your universe and place ID.
    - Navigate to the API Keys tab.
    - Create a new API key with write access to your experience for `luau-execution-sessions` and `universe-places`.
3. On your fork, add these secrets under Settings → Secrets and variables → Actions:
    - `ROBLOX_API_KEY`
    - `ROBLOX_UNIVERSE_ID`
    - `ROBLOX_PLACE_ID`

## Pull Request Guidelines

When submitting a pull request:

1. Create a feature branch from `master`.
2. Ensure lint, format, and type checks pass before opening a PR.
3. Write a clear PR title that describes the change from a user's perspective.
4. All pull requests must pass the `CI` workflow before merging.

## Licensing

By providing code in an issue or opening a pull request, you agree to license that code under the MIT License, and indicate that you have the legal right to do so.
