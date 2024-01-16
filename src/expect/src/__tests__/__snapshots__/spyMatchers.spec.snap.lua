-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[lastCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[lastCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[lastCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.lastCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[lastCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with many arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       2:       <d>"foo"</>, <r>"bar1"</>
->     3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

exports[ [=[lastCalledWith works with many arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       2: <d>"foo"</>, <r>"bar2"</>
->     3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

exports[ [=[lastCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[lastCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[lastReturnedWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[lastReturnedWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[lastReturnedWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[lastReturnedWith lastReturnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>0</>
Received
       3: function call has not returned yet
->     4: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

exports[ [=[lastReturnedWith lastReturnedWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo3"</>
Received
       2:       <r>"foo2"</>
->     3:       <d>"foo3"</>

Number of returns: <r>3</>
]=]

exports[ [=[lastReturnedWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[lastReturnedWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[lastReturnedWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[lastReturnedWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

exports[ [=[nthCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith negative throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: inf
]=]

exports[ [=[nthCalledWith positive throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

exports[ [=[nthCalledWith positive throw matcher error for n that is not positive integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

exports[ [=[nthCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[nthCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[nthCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.nthCalledWith(n, ...expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[nthCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>, <g>"bar"</>
Received
->     1:       <d>"foo1"</>, <d>"bar"</>
       2:       <r>"foo"</>, <r>"bar1"</>

Number of calls: <r>3</>
]=]

exports[ [=[nthCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[nthCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[nthReturnedWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[nthReturnedWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[nthReturnedWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>6</>
Received
->     1: function call has not returned yet
       2: function call has not returned yet

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 2
Expected: <g>3</>
Received
       1: function call has not returned yet
->     2: function call has not returned yet
       3: <r>1</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 3]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 3
Expected: never <g>1</>
Received
       2:       function call has not returned yet
->     3:       <d>1</>
       4:       <r>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 4]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: never <g>0</>
Received
       3:       <r>1</>
->     4:       <d>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith negative throw matcher error for n that is not number 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has value: nil
]=]

exports[ [=[nthReturnedWith nthReturnedWith positive throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

exports[ [=[nthReturnedWith nthReturnedWith positive throw matcher error for n that is not positive integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

exports[ [=[nthReturnedWith nthReturnedWith should reject nth value greater than number of calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: <g>"foo"</>
Received
       3: <d>"foo"</>

Number of returns: <r>3</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar1"</>
Received
->     1: <r>"foo1"</>
       2: <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[nthReturnedWith nthReturnedWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[nthReturnedWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[nthReturnedWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[nthReturnedWith works with Immutable.js objects directly created 1]=] ] = [=[

expect(jest.fn()).never.nthReturnedWith(n, expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

exports[ [=[nthReturnedWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[nthReturnedWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

exports[ [=[toBeCalled .not fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toBeCalled .not passes when called 1]=] ] = [=[

<d>expect(</><r>spy</><d>).</>toBeCalled<d>()</>

Expected number of calls: >= <g>1</>
Received number of calls:    <r>0</>
]=]

exports[ [=[toBeCalled fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toBeCalled includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toBeCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: called with 0 arguments
]=]

exports[ [=[toBeCalled passes when called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: <r>"arg0"</>, <r>"arg1"</>, <r>"arg2"</>
]=]

exports[ [=[toBeCalled works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalled<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toBeCalledTimes .not only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toBeCalledTimes .not only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toBeCalledTimes .not only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toBeCalledTimes .not only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toBeCalledTimes .not passes if function called less than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

exports[ [=[toBeCalledTimes .not passes if function called more than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>3</>
]=]

exports[ [=[toBeCalledTimes .not works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toBeCalledTimes includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

exports[ [=[toBeCalledTimes only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toBeCalledTimes only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toBeCalledTimes only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toBeCalledTimes only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toBeCalledTimes passes if function called equal to expected times 1]=] ] = [=[

<d>expect(</><r>spy</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: never <g>2</>
]=]

exports[ [=[toBeCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toBeCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[toBeCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.toBeCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[toBeCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with many arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

exports[ [=[toBeCalledWith works with many arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       1: <d>"foo"</>, <r>"bar1"</>
       2: <d>"foo"</>, <r>"bar2"</>
       3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

exports[ [=[toBeCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toBeCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalled .not fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toHaveBeenCalled .not passes when called 1]=] ] = [=[

<d>expect(</><r>spy</><d>).</>toHaveBeenCalled<d>()</>

Expected number of calls: >= <g>1</>
Received number of calls:    <r>0</>
]=]

exports[ [=[toHaveBeenCalled fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toHaveBeenCalled includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: called with 0 arguments
]=]

exports[ [=[toHaveBeenCalled passes when called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: <r>"arg0"</>, <r>"arg1"</>, <r>"arg2"</>
]=]

exports[ [=[toHaveBeenCalled works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveBeenCalledTimes .not only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toHaveBeenCalledTimes .not only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toHaveBeenCalledTimes .not only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toHaveBeenCalledTimes .not only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toHaveBeenCalledTimes .not passes if function called less than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledTimes .not passes if function called more than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenCalledTimes .not works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveBeenCalledTimes includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledTimes only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toHaveBeenCalledTimes only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toHaveBeenCalledTimes only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toHaveBeenCalledTimes only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toHaveBeenCalledTimes passes if function called equal to expected times 1]=] ] = [=[

<d>expect(</><r>spy</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: never <g>2</>
]=]

exports[ [=[toHaveBeenCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveBeenCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[toHaveBeenCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.toHaveBeenCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[toHaveBeenCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with many arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenCalledWith works with many arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       1: <d>"foo"</>, <r>"bar1"</>
       2: <d>"foo"</>, <r>"bar2"</>
       3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveBeenLastCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.toHaveBeenLastCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[toHaveBeenLastCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with many arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       2:       <d>"foo"</>, <r>"bar1"</>
->     3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with many arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       2: <d>"foo"</>, <r>"bar2"</>
->     3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenLastCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith negative throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: inf
]=]

exports[ [=[toHaveBeenNthCalledWith positive throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

exports[ [=[toHaveBeenNthCalledWith positive throw matcher error for n that is not positive integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

exports[ [=[toHaveBeenNthCalledWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveBeenNthCalledWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with Immutable.js objects 1]=] ] = [=[

expect(jest.fn()).never.toHaveBeenNthCalledWith(n, ...expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

exports[ [=[toHaveBeenNthCalledWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that don't match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that don't match in number of arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <d>"bar"</>, <r>"plop"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that don't match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>Any<string></>, <g>Any<number></>
Received: <d>"foo"</>, <r>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that don't match with matchers even when argument is undefined 1]=] ] =
	[=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>Any<string></>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with arguments that match with matchers 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Any<string></>, <g>Any<string></>
Received:       <r>1</>, <r>{"foo", "bar"}</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>, <g>"bar"</>
Received
->     1:       <d>"foo1"</>, <d>"bar"</>
       2:       <r>"foo"</>, <r>"bar1"</>

Number of calls: <r>3</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with trailing undefined arguments 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveBeenNthCalledWith works with trailing undefined arguments if requested by the match query 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>nil</>

Number of calls: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveLastReturnedWith lastReturnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>0</>
Received
       3: function call has not returned yet
->     4: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveLastReturnedWith lastReturnedWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo3"</>
Received
       2:       <r>"foo2"</>
->     3:       <d>"foo3"</>

Number of returns: <r>3</>
]=]

exports[ [=[toHaveLastReturnedWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveLastReturnedWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveLastReturnedWith works with Immutable.js objects directly created 1]=] ] = [=[

expect(jest.fn()).never.toHaveLastReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

exports[ [=[toHaveLastReturnedWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveLastReturnedWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>6</>
Received
->     1: function call has not returned yet
       2: function call has not returned yet

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 2
Expected: <g>3</>
Received
       1: function call has not returned yet
->     2: function call has not returned yet
       3: <r>1</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 3]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 3
Expected: never <g>1</>
Received
       2:       function call has not returned yet
->     3:       <d>1</>
       4:       <r>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 4]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: never <g>0</>
Received
       3:       <r>1</>
->     4:       <d>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith negative throw matcher error for n that is not number 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has value: nil
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith positive throw matcher error for n that is not integer 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith positive throw matcher error for n that is not positive integer 1]=] ] =
	[=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith should reject nth value greater than number of calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: <g>"foo"</>
Received
       3: <d>"foo"</>

Number of returns: <r>3</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar1"</>
Received
->     1: <r>"foo1"</>
       2: <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[toHaveNthReturnedWith nthReturnedWith works with three calls 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

exports[ [=[toHaveNthReturnedWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveNthReturnedWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveNthReturnedWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveNthReturnedWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturned .not fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturned<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toHaveReturned .not passes when a call throws undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>1</>
]=]

exports[ [=[toHaveReturned .not passes when all calls throw 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>2</>
]=]

exports[ [=[toHaveReturned .not passes when not returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
]=]

exports[ [=[toHaveReturned .not works only on jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturned<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveReturned fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturned<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toHaveReturned includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

exports[ [=[toHaveReturned incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>4</>
]=]

exports[ [=[toHaveReturned passes when at least one call does not throw 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>2</>

1: <r>42</>
3: <r>42</>

Received number of calls:   <r>3</>
]=]

exports[ [=[toHaveReturned passes when returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

exports[ [=[toHaveReturned passes when undefined is returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>nil</>
]=]

exports[ [=[toHaveReturned throw matcher error if received is spy 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturned<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function all], "count": [Function count]}}</>
]=]

exports[ [=[toHaveReturnedTimes .not only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toHaveReturnedTimes .not only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toHaveReturnedTimes .not only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toHaveReturnedTimes .not only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toHaveReturnedTimes .not passes if function called less than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedTimes .not passes if function returned more than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>3</>
]=]

exports[ [=[toHaveReturnedTimes calls that return undefined are counted as returns 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

exports[ [=[toHaveReturnedTimes calls that throw are not counted 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>3</>
Received number of returns: <r>2</>
Received number of calls:   <r>3</>
]=]

exports[ [=[toHaveReturnedTimes calls that throw undefined are not counted 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>3</>
]=]

exports[ [=[toHaveReturnedTimes includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>1</>
Received number of returns: <r>2</>
]=]

exports[ [=[toHaveReturnedTimes incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>4</>
]=]

exports[ [=[toHaveReturnedTimes only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toHaveReturnedTimes only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toHaveReturnedTimes only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toHaveReturnedTimes only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toHaveReturnedTimes passes if function returned equal to expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

exports[ [=[toHaveReturnedTimes throw matcher error if received is spy 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function all], "count": [Function count]}}</>
]=]

exports[ [=[toHaveReturnedWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveReturnedWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toHaveReturnedWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveReturnedWith returnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received
       1: function call has not returned yet
       2: function call has not returned yet
       3: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

exports[ [=[toHaveReturnedWith returnedWith works with more calls than the limit 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received
       1: <r>"foo1"</>
       2: <r>"foo2"</>
       3: <r>"foo3"</>

Number of returns: <r>6</>
]=]

exports[ [=[toHaveReturnedWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toHaveReturnedWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toHaveReturnedWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toHaveReturnedWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturn .not fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturn<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toReturn .not passes when a call throws undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>1</>
]=]

exports[ [=[toReturn .not passes when all calls throw 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>2</>
]=]

exports[ [=[toReturn .not passes when not returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
]=]

exports[ [=[toReturn .not works only on jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturn<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toReturn fails with any argument passed 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturn<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

exports[ [=[toReturn includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

exports[ [=[toReturn incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>4</>
]=]

exports[ [=[toReturn passes when at least one call does not throw 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>2</>

1: <r>42</>
3: <r>42</>

Received number of calls:   <r>3</>
]=]

exports[ [=[toReturn passes when returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

exports[ [=[toReturn passes when undefined is returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>nil</>
]=]

exports[ [=[toReturn throw matcher error if received is spy 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturn<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function all], "count": [Function count]}}</>
]=]

exports[ [=[toReturnTimes .not only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toReturnTimes .not only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toReturnTimes .not only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toReturnTimes .not only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toReturnTimes .not passes if function called less than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>1</>
]=]

exports[ [=[toReturnTimes .not passes if function returned more than expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>3</>
]=]

exports[ [=[toReturnTimes calls that return undefined are counted as returns 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

exports[ [=[toReturnTimes calls that throw are not counted 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>3</>
Received number of returns: <r>2</>
Received number of calls:   <r>3</>
]=]

exports[ [=[toReturnTimes calls that throw undefined are not counted 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>3</>
]=]

exports[ [=[toReturnTimes includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>1</>
Received number of returns: <r>2</>
]=]

exports[ [=[toReturnTimes incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>4</>
]=]

exports[ [=[toReturnTimes only accepts a number argument 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

exports[ [=[toReturnTimes only accepts a number argument 2]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

exports[ [=[toReturnTimes only accepts a number argument 3]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

exports[ [=[toReturnTimes only accepts a number argument 4]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

exports[ [=[toReturnTimes passes if function returned equal to expected times 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

exports[ [=[toReturnTimes throw matcher error if received is spy 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function all], "count": [Function count]}}</>
]=]

exports[ [=[toReturnWith a call that throws is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toReturnWith a call that throws undefined is not considered to have returned 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

exports[ [=[toReturnWith includes the custom mock name in the error message 1]=] ] = [=[

<d>expect(</><r>named-mock</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toReturnWith returnedWith incomplete recursive calls are handled properly 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received
       1: function call has not returned yet
       2: function call has not returned yet
       3: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

exports[ [=[toReturnWith returnedWith works with more calls than the limit 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received
       1: <r>"foo1"</>
       2: <r>"foo2"</>
       3: <r>"foo3"</>

Number of returns: <r>6</>
]=]

exports[ [=[toReturnWith works only on spies or jest.fn 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

exports[ [=[toReturnWith works when not called 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

exports[ [=[toReturnWith works with Immutable.js objects directly created 1]=] ] = [=[

expect(jest.fn()).never.toReturnWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

exports[ [=[toReturnWith works with Map 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with Map 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with Set 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with Set 2]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with argument that does match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with argument that does not match 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

exports[ [=[toReturnWith works with undefined 1]=] ] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

return exports
