-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/__snapshots__/SummaryReporter.test.js.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP
local exports = {}

exports["snapshots all have results (after update) 1"] = [[

"<bold>Snapshot Summary</>
<bold><green> › 1 snapshot written </></>from 1 test suite.
<bold><red> › 1 snapshot failed</></> from 1 test suite. <dim>Inspect your code changes or run `yarn test -u` to update them.</>
<bold><green> › 1 snapshot updated </></>from 1 test suite.
<bold><green> › 1 snapshot file removed </></>from 1 test suite.
<bold><green> › 1 snapshot removed </></>from 1 test suite.
   ↳ <dim>path/to/</><bold>suite_one</>
     • unchecked snapshot 1

<bold>Test Suites: </><bold><red>1 failed</></>, 1 total
<bold>Tests:       </><bold><red>1 failed</></>, 1 total
<bold>Snapshots:   </><bold><red>1 failed</></>, <bold><green>1 removed</></>, <bold><green>1 file removed</></>, <bold><green>1 updated</></>, <bold><green>1 written</></>, <bold><green>2 passed</></>, 2 total
<bold>Time:</>        0.01 s
<dim>Ran all test suites</><dim>.</>
"
]]
exports["snapshots all have results (no update) 1"] = [[

"<bold>Snapshot Summary</>
<bold><green> › 1 snapshot written </></>from 1 test suite.
<bold><red> › 1 snapshot failed</></> from 1 test suite. <dim>Inspect your code changes or run `yarn test -u` to update them.</>
<bold><green> › 1 snapshot updated </></>from 1 test suite.
<bold><yellow> › 1 snapshot file obsolete </></>from 1 test suite. <dim>To remove it, run `yarn test -u`.</>
<bold><yellow> › 1 snapshot obsolete </></>from 1 test suite. <dim>To remove it, run `yarn test -u`.</>
   ↳ <dim>path/to/</><bold>suite_one</>
     • unchecked snapshot 1

<bold>Test Suites: </><bold><red>1 failed</></>, 1 total
<bold>Tests:       </><bold><red>1 failed</></>, 1 total
<bold>Snapshots:   </><bold><red>1 failed</></>, <bold><yellow>1 obsolete</></>, <bold><yellow>1 file obsolete</></>, <bold><green>1 updated</></>, <bold><green>1 written</></>, <bold><green>2 passed</></>, 2 total
<bold>Time:</>        0.01 s
<dim>Ran all test suites</><dim>.</>
"
]]
exports["snapshots needs update with npm test 1"] = [[

"<bold>Snapshot Summary</>
<bold><red> › 2 snapshots failed</></> from 1 test suite. <dim>Inspect your code changes or run `npm test -- -u` to update them.</>

<bold>Test Suites: </><bold><red>1 failed</></>, 1 total
<bold>Tests:       </><bold><red>1 failed</></>, 1 total
<bold>Snapshots:   </><bold><red>2 failed</></>, 2 total
<bold>Time:</>        0.01 s
<dim>Ran all test suites</><dim>.</>
"
]]
exports["snapshots needs update with yarn test 1"] = [[

"<bold>Snapshot Summary</>
<bold><red> › 2 snapshots failed</></> from 1 test suite. <dim>Inspect your code changes or run `yarn test -u` to update them.</>

<bold>Test Suites: </><bold><red>1 failed</></>, 1 total
<bold>Tests:       </><bold><red>1 failed</></>, 1 total
<bold>Snapshots:   </><bold><red>2 failed</></>, 2 total
<bold>Time:</>        0.01 s
<dim>Ran all test suites</><dim>.</>
"
]]

return exports
