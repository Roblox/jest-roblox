# jest-get-type

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-get-type

Utility functions for getting the type of a value. Returns type strings for Lua primitives (`nil`, `boolean`, `number`, `string`, `function`, `table`, `userdata`, `thread`), polyfill types (`symbol`, `regexp`, `error`, `map`, `set`), Roblox data types (`DateTime`, `Vector3`, etc.), and Roblox instances (`Instance`).

## Exports

- **`getType(value: any) -> string`** — Returns a string identifying the type of the value
- **`isPrimitive(value: any) -> boolean`** — Returns `true` for non-table, non-function, non-Instance values
- **`isRobloxBuiltin(value: any) -> boolean`** — Returns `true` for Roblox engine data types (Vector3, Color3, UDim2, etc.)
