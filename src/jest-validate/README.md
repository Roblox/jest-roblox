# jest-validate

Upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-validate

Only `ValidationError` is ported — used by `jest-config` to surface invalid config and reporter options. The rest of upstream's validation engine (option matching, did-you-mean suggestions, formatted warnings) was not ported; jest-config uses its own validation paths.
