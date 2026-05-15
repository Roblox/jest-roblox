# diff-sequences

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/diff-sequences

Compare items in two sequences to find a longest common subsequence. Implements the linear space variation of the Myers O(ND) difference algorithm.

## API

The module returns a single function:

```lua
local diff = require(Packages.DiffSequences)

diff(aLength, bLength, isCommon, foundSubsequence)
```

### Parameters

- **`aLength`** `number` — Length of the first sequence (must be a non-negative integer)
- **`bLength`** `number` — Length of the second sequence (must be a non-negative integer)
- **`isCommon`** `(aIndex: number, bIndex: number) -> boolean` — Callback that returns whether items at the given 0-based indexes are equal
- **`foundSubsequence`** `(nCommon: number, aCommon: number, bCommon: number) -> ()` — Called for each common subsequence found, with the number of adjacent common items and the 0-based starting indexes in each sequence

### Example

```lua
local a = { "a", "b", "c", "d" }
local b = { "a", "c", "d", "e" }

diff(#a, #b, function(aIndex, bIndex)
    return a[aIndex + 1] == b[bIndex + 1]
end, function(nCommon, aCommon, bCommon)
    print(string.format("%d common items starting at a[%d], b[%d]", nCommon, aCommon, bCommon))
end)
-- Output:
-- 1 common items starting at a[0], b[0]   ("a")
-- 2 common items starting at a[2], b[1]   ("c", "d")
```

Note: indexes passed to callbacks are 0-based (matching the algorithm's conventions), so add 1 when indexing into Lua tables.
