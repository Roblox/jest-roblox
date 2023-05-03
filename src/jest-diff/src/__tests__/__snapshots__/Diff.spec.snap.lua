-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-diff/src/__tests__/__snapshots__/diff.test.ts.snap

local snapshots = {}

snapshots["collapses big diffs to patch format 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<y>@@ -6,9 +6,9 @@</>
<d>      4,</>
<d>      5,</>
<d>      6,</>
<d>      7,</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
<d>  }</>
]=]

snapshots["color of text (expanded) 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    "searching": "",</>
<d>    "sorting": Table {</>
<r>+     Table {</>
<d>        "descending": false,</>
<d>        "fieldKey": "what",</>
<r>+     },</>
<d>    },</>
<d>  }</>
]=]

-- ROBLOX deviation: all context number of lines tests use } instead of }
snapshots["context number of lines: -1 (5 default) 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>@@ -6,9 +6,9 @@</>
<d>      4,</>
<d>      5,</>
<d>      6,</>
<d>      7,</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
<d>  }</>
]=]

snapshots["context number of lines: 0  1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<y>@@ -11,1 +11,0 @@</>
<g>-     9,</>
<y>@@ -13,0 +12,1 @@</>
<r>+     9,</>
]=]

snapshots["context number of lines: 1  1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<y>@@ -10,4 +10,4 @@</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
]=]

snapshots["context number of lines: 2  1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<y>@@ -9,6 +9,6 @@</>
<d>      7,</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
<d>  }</>
]=]

snapshots["context number of lines: 3.1 (5 default) 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>@@ -6,9 +6,9 @@</>
<d>      4,</>
<d>      5,</>
<d>      6,</>
<d>      7,</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
<d>  }</>
]=]

-- ROBLOX deviation: nil instead of undefined
snapshots["context number of lines: nil (5 default) 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>@@ -6,9 +6,9 @@</>
<d>      4,</>
<d>      5,</>
<d>      6,</>
<d>      7,</>
<d>      8,</>
<g>-     9,</>
<d>      10,</>
<r>+     9,</>
<d>    },</>
<d>  }</>
]=]

snapshots["diffStringsUnified edge cases empty both a and b 1"] = [=[

<g>- Expected  - 0</>
<r>+ Received  + 0</>


]=]

snapshots["diffStringsUnified edge cases empty only a 1"] = [=[

<g>- Expected  - 0</>
<r>+ Received  + 1</>

<r>+ one-line string</>
]=]

snapshots["diffStringsUnified edge cases empty only b 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 0</>

<g>- one-line string</>
]=]

snapshots["diffStringsUnified edge cases equal both non-empty 1"] = [=[

<g>- Expected  - 0</>
<r>+ Received  + 0</>

<d>  one-line string</>
]=]

snapshots["diffStringsUnified edge cases multiline has no common after clean up chaff 1"] = [=[

<g>- Expected  - 2</>
<r>+ Received  + 2</>

<g>- delete</>
<g>- two</>
<r>+ insert</>
<r>+ 2</>
]=]

snapshots["diffStringsUnified edge cases one-line has no common after clean up chaff 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<g>- delete</>
<r>+ insert</>
]=]

-- ROBLOX deviation: edited to say 'Table' and 'Function anonymous', ordering changed
snapshots["falls back to not call toJSON if it throws and then objects have differences 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "line": 1,</>
<r>+   "line": 2,</>
<d>    "toJSON": [Function anonymous],</>
<d>  }</>
]=]

-- ROBLOX deviation: edited to say 'Table' and 'Function anonymous', ordering changed
snapshots["falls back to not call toJSON if serialization has no differences but then objects have differences 1"] = [=[

<d>Compared values serialize to the same structure.</>
<d>Printing internal object structure without calling `toJSON` instead.</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "line": 1,</>
<r>+   "line": 2,</>
<d>    "toJSON": [Function anonymous],</>
<d>  }</>
]=]

snapshots["oneline strings 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<g>- ab</>
<r>+ aa</>
]=]

snapshots["oneline strings 2"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<g>- 123456789</>
<r>+ 234567890</>
]=]

snapshots["oneline strings 3"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 2</>

<g>- oneline</>
<r>+ multi</>
<r>+ line</>
]=]

snapshots["oneline strings 4"] = [=[

<g>- Expected  - 2</>
<r>+ Received  + 1</>

<g>- multi</>
<g>- line</>
<r>+ oneline</>
]=]

-- ROBLOX deviation: unescaped backticks and ${}
snapshots["options 7980 diff 1"] = [=[

<r>- Original</>
<g>+ Modified</>

<r>- `${Ti.App.name} ${Ti.App.version} ${Ti.Platform.name} ${Ti.Platform.version}`</>
<g>+ `${Ti.App.getName()} ${Ti.App.getVersion()} ${Ti.Platform.getName()} ${Ti.Platform.getVersion()}`</>
]=]

-- ROBLOX deviation: unescaped backticks and ${}
snapshots["options 7980 diffStringsUnified 1"] = [=[

<r>- Original</>
<g>+ Modified</>

<r>- `${Ti.App.<i>n</i>ame} ${Ti.App.<i>v</i>ersion} ${Ti.Platform.<i>n</i>ame} ${Ti.Platform.<i>v</i>ersion}`</>
<g>+ `${Ti.App.<i>getN</i>ame<i>()</i>} ${Ti.App.<i>getV</i>ersion<i>()</i>} ${Ti.Platform.<i>getN</i>ame<i>()</i>} ${Ti.Platform.<i>getV</i>ersion<i>()</i>}`</>
]=]

snapshots["options change color diffStringsUnified 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- delete</>
<g>- changed <b>from</></>
<r>+ changed <b>to</></>
<r>+ insert</>
<y>  common</>
]=]

snapshots["options change color no diff 1"] = [=[<y>Compared values have no visual difference.</>]=]

-- ROBLOX deviation: Table {} instead of Array []
snapshots["options change indicators diff 1"] = [=[

<g>< Expected</>
<r>> Received</>

<d>  Table {</>
<g><   "delete",</>
<g><   "change from",</>
<r>>   "change to",</>
<r>>   "insert",</>
<d>    "common",</>
<d>  }</>
]=]

-- ROBLOX deviation: Table {} instead of Array []
snapshots["options common diff 1"] = [=[

<g>- Expected</>
<r>+ Received</>

= Table {
<g>-   "delete",</>
<g>-   "change from",</>
<r>+   "change to",</>
<r>+   "insert",</>
=   "common",
= }
]=]

-- ROBLOX deviation: Table {} instead of Array []
snapshots["options includeChangeCounts false diffLinesUnified 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<g>-   "delete",</>
<g>-   "change from",</>
<r>+   "change to",</>
<r>+   "insert",</>
<d>    "common",</>
<d>  }</>
]=]

snapshots["options includeChangeCounts false diffStringsUnified 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- change <i>from</i></>
<r>+ change <i>to</i></>
<d>  common</>
]=]

snapshots["options includeChangeCounts true padding diffLinesUnified a has 2 digits 1"] = [=[

<g>- Before  - 10</>
<r>+ After   +  1</>

<d>  common</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<g>- a</>
<r>+ b</>
]=]

snapshots["options includeChangeCounts true padding diffLinesUnified b has 2 digits 1"] = [=[

<g>- Before  -  1</>
<r>+ After   + 10</>

<d>  common</>
<g>- a</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
<r>+ b</>
]=]

snapshots["options includeChangeCounts true padding diffStringsUnified 1"] = [=[

<g>- Before  - 1</>
<r>+ After   + 1</>

<g>- change <i>from</i></>
<r>+ change <i>to</i></>
<d>  common</>
]=]

-- ROBLOX deviation: Table {} instead of Array []
snapshots["options omitAnnotationLines true diff 1"] = [=[

<d>  Table {</>
<g>-   "delete",</>
<g>-   "change from",</>
<r>+   "change to",</>
<r>+   "insert",</>
<d>    "common",</>
<d>  }</>
]=]

snapshots["options omitAnnotationLines true diffStringsUnified and includeChangeCounts true 1"] = [=[

<g>- change <i>from</i></>
<r>+ change <i>to</i></>
<d>  common</>
]=]

snapshots["options omitAnnotationLines true diffStringsUnified empty strings 1"] = ""

snapshots["options trailingSpaceFormatter diff default no color 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- delete 1 trailing space: </>
<r>+ delete 1 trailing space:</>
<d>  common 2 trailing spaces:  </>
<g>- insert 1 trailing space:</>
<r>+ insert 1 trailing space: </>
]=]

snapshots["options trailingSpaceFormatter diff middle dot 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- delete 1 trailing space:·</>
<r>+ delete 1 trailing space:</>
<d>  common 2 trailing spaces:··</>
<g>- insert 1 trailing space:</>
<r>+ insert 1 trailing space:·</>
]=]

snapshots["options trailingSpaceFormatter diff yellowish common 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- delete 1 trailing space: </>
<r>+ delete 1 trailing space:</>
<d>  common 2 trailing spaces:<Y>  </></>
<g>- insert 1 trailing space:</>
<r>+ insert 1 trailing space: </>
]=]

return snapshots
