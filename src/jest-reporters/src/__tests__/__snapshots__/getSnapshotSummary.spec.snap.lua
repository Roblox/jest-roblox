-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/__snapshots__/getSnapshotSummary.test.js.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP
local exports = {}

exports["creates a snapshot summary 1"] = [[

"<bold>Snapshot Summary</>
<bold><green> › 1 snapshot written </></>from 1 test suite.
<bold><red> › 1 snapshot failed</></> from 1 test suite. <dim>Inspect your code changes or press --u to update them.</>
<bold><green> › 1 snapshot updated </></>from 1 test suite.
<bold><yellow> › 1 snapshot file obsolete </></>from 1 test suite. <dim>To remove it, press --u.</>
<bold><yellow> › 1 snapshot obsolete </></>from 1 test suite. <dim>To remove it, press --u.</>
   ↳ <dim>path/to/</><bold>suite_one</>
     • unchecked snapshot 1"
]]

exports["creates a snapshot summary after an update 1"] = [[

"<bold>Snapshot Summary</>
<bold><green> › 1 snapshot written </></>from 1 test suite.
<bold><red> › 1 snapshot failed</></> from 1 test suite. <dim>Inspect your code changes or press --u to update them.</>
<bold><green> › 1 snapshot updated </></>from 1 test suite.
<bold><green> › 1 snapshot file removed </></>from 1 test suite.
<bold><green> › 1 snapshot removed </></>from 1 test suite.
   ↳ <dim>path/to/</><bold>suite_one</>
     • unchecked snapshot 1"
]]

exports["creates a snapshot summary with multiple snapshot being written/updated 1"] = [[

"<bold>Snapshot Summary</>
<bold><green> › 2 snapshots written </></>from 2 test suites.
<bold><red> › 2 snapshots failed</></> from 2 test suites. <dim>Inspect your code changes or press --u to update them.</>
<bold><green> › 2 snapshots updated </></>from 2 test suites.
<bold><yellow> › 2 snapshot files obsolete </></>from 2 test suites. <dim>To remove them all, press --u.</>
<bold><yellow> › 2 snapshots obsolete </></>from 2 test suites. <dim>To remove them all, press --u.</>
   ↳ <dim>path/to/</><bold>suite_one</>
     • unchecked snapshot 1
   ↳ <dim>path/to/</><bold>suite_two</>
     • unchecked snapshot 2"
]]

exports["returns nothing if there are no updates 1"] = [["<bold>Snapshot Summary</>"]]

return exports
