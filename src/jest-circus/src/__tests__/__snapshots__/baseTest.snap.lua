-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-circus/src/__tests__/__snapshots__/baseTest.test.ts.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP

local exports = {}

exports["failures 1"] = [[

start_describe_definition: describe
add_hook: beforeEach
add_hook: afterEach
add_test: one
add_test: two
finish_describe_definition: describe
run_start
run_describe_start: ROOT_DESCRIBE_BLOCK
run_describe_start: describe
test_start: one
hook_start: beforeEach
hook_success: beforeEach
test_fn_start: one
test_fn_failure: one
hook_start: afterEach
hook_failure: afterEach
test_done: one
test_start: two
hook_start: beforeEach
hook_success: beforeEach
test_fn_start: two
test_fn_success: two
hook_start: afterEach
hook_failure: afterEach
test_done: two
run_describe_finish: describe
run_describe_finish: ROOT_DESCRIBE_BLOCK
run_finish

unhandledErrors: 0
]]

exports["simple test 1"] = [[

start_describe_definition: describe
add_hook: beforeEach
add_hook: afterEach
add_test: one
add_test: two
finish_describe_definition: describe
run_start
run_describe_start: ROOT_DESCRIBE_BLOCK
run_describe_start: describe
test_start: one
hook_start: beforeEach
hook_success: beforeEach
test_fn_start: one
test_fn_success: one
hook_start: afterEach
hook_success: afterEach
test_done: one
test_start: two
hook_start: beforeEach
hook_success: beforeEach
test_fn_start: two
test_fn_success: two
hook_start: afterEach
hook_success: afterEach
test_done: two
run_describe_finish: describe
run_describe_finish: ROOT_DESCRIBE_BLOCK
run_finish

unhandledErrors: 0
]]

return exports
