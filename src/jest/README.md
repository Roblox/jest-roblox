# jest

Upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest

Re-exports the public surface of `jest-core` (`SearchSource`, `TestWatcher`, `createTestScheduler`, `runCLI`). Most users want `JestGlobals` instead — see the [Jest documentation](https://roblox.github.io/jest-roblox-internal).

The `args` field parses command-line arguments via `ProcessService:GetCommandLineArgs()` for the Roblox CLI flow; upstream's `jest-cli` package is not ported.
