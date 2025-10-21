-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[Lua toThrowMatcher tests cleans stack trace and prints correct files 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:169 function func2
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:175
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua AssertionError error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"AssertionError"</>
Error message: <r>""</>

      AssertionError [ERR_ASSERTION]
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:79 function error3
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:83 function test3
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:113
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua Error error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      Error
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:63 function error1
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:71 function test1
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:89
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:67 function error2
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:75 function test2
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:97
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:67 function error2
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:75 function test2
      _Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:105
]=]

exports[ [=[Lua toThrowMatcher tests toThrow should fail if expected is a string and thrown message is a table 1]=] ] =
	[=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"string"</>
Received message:   <r>{"key": "value"}</>

]=]

return exports
