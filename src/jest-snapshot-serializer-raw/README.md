# jest-snapshot-serializer-raw

Upstream: https://github.com/ikatyang/jest-snapshot-serializer-raw/tree/v1.2.0

A snapshot serializer that prints raw strings without quoting or escaping. Use `wrap(s)` on a string in your test to opt that string into raw serialization.

```lua
local rawSerializer = require(Packages.JestSnapshotSerializerRaw)
expect.addSnapshotSerializer(rawSerializer)

expect(rawSerializer.wrap("hello\nworld")).toMatchSnapshot()
```
