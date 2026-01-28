# pretty-format

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/pretty-format

Stringify any Luau value
* Supports Luau builtins and Roblox Instances.
* Can be extended with user defined plugins.

---

## Roblox Instance Formatting Options

The following options control how Roblox `Instance` objects are serialized:

### `printInstanceDefaults` \[boolean]

Default: `true`

When `true`, prints all readable properties of an Instance. When `false`, only prints properties that differ from their default values.

```lua
local prettyFormat = require(Packages.PrettyFormat).default
local RobloxInstance = require(Packages.PrettyFormat).plugins.RobloxInstance

local label = Instance.new("TextLabel")
label.Text = "Hello"

-- With printInstanceDefaults = false, only non-default properties are shown
print(prettyFormat(label, {
    plugins = { RobloxInstance },
    printInstanceDefaults = false,
}))
-- Output: TextLabel { "Text": "Hello" }
```

### `printInstanceTags` \[boolean]

Default: `false`

When `true`, prints tags applied to an Instance (via `CollectionService:AddTag()` or `React.Tag`). Tags are sorted alphabetically and appear before properties.

```lua
local label = Instance.new("TextLabel")
label.Name = "MyLabel"
label:AddTag("Styled")
label:AddTag("Animated")

print(prettyFormat(label, {
    plugins = { RobloxInstance },
    printInstanceDefaults = false,
    printInstanceTags = true,
}))
-- Output:
-- TextLabel {
--   "Tags": Table {
--     "Animated",
--     "Styled",
--   },
--   "Name": "MyLabel",
-- }
```

### `useStyledProperties` \[boolean]

Default: `false`

When `true`, reads Instance properties using the `GetStyled` API, returning computed values after StyleSheet rules are applied. When `false`, reads properties directly from the Instance.

This is useful when testing styled components to verify that style rules are correctly applied.

```lua
-- With useStyledProperties = true, the styled value (from StyleSheet) is shown
-- With useStyledProperties = false, the base property value is shown
```

**Note on Pseudoinstances:** Styling infrastructure instances (`StyleSheet`, `StyleRule`, `StyleLink`, `StyleDerive`) currently appear in serialized output when they are children of a formatted Instance. This behavior is documented and tested in the test suite.

---

### :pencil2: Notes
* :warning: Our `prettyFormat` doesn't distinguish between `Tables`, `Arrays`, `Objects`, etc. and prints out all Lua table-like types as `Table`.
    * For example, an empty array is printed as `Table {}` and an array with values is printed as `Table {1, 2, 3,}`.
    * `printComplexValue` is reduced to just arrays and tables.
* :x: Color formatting isn't supported so all related methods are omitted.
* :hammer: Built-in plugins for `prettyFormat` are not implemented yet.
* `prettyFormat` formats Roblox `DateTime` objects as a replacement for JS `Date`.
* Formats using the Lua native string representations of primitives like `nil`, `nan` and `inf` over the JS `null`, `NaN` and `Infinity`. The tests are modified accordingly.
* Formatting for any Javascript specific types in are omitted, `Symbol`, named `Function`, `Error`, `Date`, `BigInt`, etc.
* `getConfig` is rewritten to avoid ternary operators.
loop is rewritten with a `for` loop instead of an `iterator.next()`.
* `Collections.lua` deviates from upstream substantially since Lua only has tables. We only have two functions: `printTableEntries` for formatting key, value pairs and `printListItems` for formatting arrays.
