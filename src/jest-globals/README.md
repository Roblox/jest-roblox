# jest-globals

Upstream: https://github.com/jestjs/jest/tree/v28.0.0/packages/jest-globals

This package exports the "global" methods used by Jest (`describe`, `it`, `test`, `expect`, `beforeEach`, etc.). See the [Jest documentation](https://roblox.github.io/jest-roblox-internal) for full API docs.

Importing `JestGlobals` only works inside a running Jest test environment — `jest-runtime` intercepts the require and injects the live globals. Required outside that path, the module errors immediately.
