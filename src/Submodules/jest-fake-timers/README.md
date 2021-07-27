# jest-fake-timers

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-fake-timers

Version: v26.5.2

---

### :pencil2: Notes
:exclamation: The fake timer API in Jest Roblox is aligned with the "modern" fake timer implementation in Jest. However, the actual implementation of fake timers in Jest Roblox under the hood massively deviates from upstream so that it works natively with the Roblox ecosystem.

Similar to how Jest fake timers work by mocking the native timer functions (i.e. `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`) and `Date`, Jest Roblox fake timers work by mocking the native timer functions in Roblox (i.e. `delay`, `tick`), the Roblox `DateTime` and the Lua native timer methods `os.time` and `os.clock`.

### :x: Excluded
```
src/legacyFakeTimers.ts
__tests__/legacyFakeTimers.test.ts
__tests__/__snapshots__/legacyFakeTimers.test.ts.snap
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-fake-timers/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| @jest/types | 26.5.2 |:x: Not needed | |
| @sinonjs/fake-timers | 6.0.1 |:x: Not needed | |
| @types/node | * |:x: Not needed | |
| jest-message-util | 26.5.2 | :x: Not needed | |
| jest-mock | 26.5.2 | :x: Not needed | |
| jest-util | 26.5.2 |:x: Not needed | |