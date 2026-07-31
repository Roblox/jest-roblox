-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[.formatExecError() - Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      JestMessageUtil.__tests__.messages.roblox.spec:51
"
]=]

exports[ [=[.formatExecError() - Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    JestMessageUtil.__tests__.messages.roblox.spec:36: kaboom

      JestMessageUtil.__tests__.messages.roblox.spec:36
"
]=]

exports[ [=[.formatExecError() - nested Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      JestMessageUtil.__tests__.messages.roblox.spec:84
"
]=]

exports[ [=[.formatExecError() - nested Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    JestMessageUtil.__tests__.messages.roblox.spec:67: kaboom

      JestMessageUtil.__tests__.messages.roblox.spec:67
"
]=]

return exports
