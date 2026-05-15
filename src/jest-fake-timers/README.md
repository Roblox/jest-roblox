# jest-fake-timers

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-fake-timers

Fake timers implementation for Jest Roblox. Activated via `jest.useFakeTimers()`. The API is aligned with Jest's "modern" fake timers, but the implementation is built natively for the Roblox engine.

## Mocked timers

- `delay`, `tick`, `time`
- `os.time`, `os.clock`
- `task.delay`, `task.cancel`, `task.wait`
- `DateTime.now`

## Engine frame time

Jest Roblox fake timers support a configurable engine frame time via `jest.setEngineFrameTime(ms)`. By default this is 0 (continuous time). When set, timers are processed in batches delineated by frame boundaries — a timer fires in the first frame after its scheduled time.
