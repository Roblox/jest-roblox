-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[reporter extracts the correct filename and line 1]=] ] = [=[
"::error file=/Users/rng/jest-roblox/src/jest-reporters/src/__tests__/some.spec.lua,line=9::Error: expect(received).toEqual(expected) -- deep equality%0A        %0A        Expected: \"b\"%0A        Received: \"a\"%0A        JestReporters.__tests__.some.spec:9%0A        JestCircus.circus.utils:369%0A        _Index.Promise.Promise function runExecutor%0A        _Index.Promise.Promise"]=]

return exports
