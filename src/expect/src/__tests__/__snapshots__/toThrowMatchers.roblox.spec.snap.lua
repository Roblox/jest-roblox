-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[Lua toThrowMatcher tests cleans stack trace and prints correct files 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      Expect.__tests__.toThrowMatchers.roblox.spec:172 function func2
      Expect.__tests__.toThrowMatchers.roblox.spec:178
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua AssertionError error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"AssertionError"</>
Error message: <r>""</>

      AssertionError [ERR_ASSERTION]
      Expect.__tests__.toThrowMatchers.roblox.spec:82 function error3
      Expect.__tests__.toThrowMatchers.roblox.spec:86 function test3
      Expect.__tests__.toThrowMatchers.roblox.spec:116
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua Error error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      Error
      Expect.__tests__.toThrowMatchers.roblox.spec:66 function error1
      Expect.__tests__.toThrowMatchers.roblox.spec:74 function test1
      Expect.__tests__.toThrowMatchers.roblox.spec:92
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      Expect.__tests__.toThrowMatchers.roblox.spec:70 function error2
      Expect.__tests__.toThrowMatchers.roblox.spec:78 function test2
      Expect.__tests__.toThrowMatchers.roblox.spec:100
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      Expect.__tests__.toThrowMatchers.roblox.spec:70 function error2
      Expect.__tests__.toThrowMatchers.roblox.spec:78 function test2
      Expect.__tests__.toThrowMatchers.roblox.spec:108
]=]

exports[ [=[Lua toThrowMatcher tests toThrow should fail if expected is a string and thrown message is a table 1]=] ] =
	[=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"string"</>
Received message:   <r>{"key": "value"}</>

]=]

return exports
