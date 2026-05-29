# test-utils

Upstream: https://github.com/jestjs/jest/tree/v28.0.0/packages/test-utils

Internal helpers for jest-roblox's own test suites:

- `alignedAnsiStyleSerializer` — snapshot serializer that translates chalk ANSI codes to short tags (`<r>`/`<g>`/`<b>`/...) so colored output snapshots stay readable.
- `makeGlobalConfig(overrides?)` / `makeProjectConfig(overrides?)` — build a `Config_GlobalConfig` / `Config_ProjectConfig` from defaults plus the given overrides; throws if any override key is not a recognized config field.
