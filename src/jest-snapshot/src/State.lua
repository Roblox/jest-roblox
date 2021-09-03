-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/State.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

-- deviation: omitting fs and types file import and defining in line instead

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent

-- deviation: used to communicate with the TestEZ test runner
local JEST_TEST_CONTEXT = "__JEST_TEST_CONTEXT__"

local function getCoreScriptSyncService()
	local success, result = pcall(function()
		return game:GetService("CoreScriptSyncService")
	end)

	return success and result or nil
end
local CoreScriptSyncService = getCoreScriptSyncService()

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set

-- ROBLOX TODO: ADO-1633 fix Jest Types imports
-- local Config = require(Packages.JestTypes).Config
type ConfigPath = string
type ConfigSnapshotUpdateState = string

-- local JestMessageUtil = require(Packages.JestMessageUtil)
-- local getStackTraceLines = JestMessageUtil.getStackTraceLines
-- local getTopFrame = JestMessageUtil.getTopFrame

local utils = require(CurrentModule.utils)
local addExtraLineBreaks = utils.addExtraLineBreaks
local getSnapshotData = utils.getSnapshotData
local keyToTestName = utils.keyToTestName
local removeExtraLineBreaks = utils.removeExtraLineBreaks
-- ROBLOX TODO: ADO-1552 translate this function when we add inlineSnapshot functionality
-- local removeLinesBeforeExternalMatcherTrap = utils.removeLinesBeforeExternalMatcherTrap
local saveSnapshotFile = utils.saveSnapshotFile
local serialize = utils.serialize
local testNameToKey = utils.testNameToKey
local getParent = utils.robloxGetParent

-- ROBLOX TODO: ADO-1552 add inline_snapshots imports when we support this
-- functionality

local types = require(CurrentModule.types)
-- deviation: we do not have the BabelTraverse or Prettier types defined in the
-- types file

type SnapshotStateOptions = {
	updateSnapshot: ConfigSnapshotUpdateState,
	-- deviation: the function return is defined as any instead of null | Prettier
	-- getPrettier: () -> any,
	-- getBabelTraverse: () -> any,
	expand: boolean?
}

type SnapshotMatchOptions = {
	testName: string,
	received: any?,
	key: string?,
	inlineSnapshot: string?,
	isInline: boolean,
	-- deviation: error type defined as any instead of Error
	error_: any
}

type SnapshotReturnOptions = {
	actual: string,
	count: number,
	expected: string?,
	key: string,
	pass: boolean
}

type SaveStatus = {
	deleted: boolean,
	saved: boolean
}

type SnapshotState = {
	_counters: { [string]: number },
	_dirty: boolean,
	_index: number,
	_updateSnapshot: ConfigSnapshotUpdateState,
	_snapshotData: types.SnapshotData,
	_initialData: types.SnapshotData,
	_snapshotPath: ConfigPath,
	-- ROBLOX TODO: ADO-1552 align this type as Array<InlineSnapshot> when we support inlineSnapshot testing
	_inlineSnapshots: {any},
	-- deviation: defined as any for now because LuauPolyfill.Set<string> and Set.Set<string>
	-- both didn't seem to be working
	_uncheckedKeys: any,
	-- _uncheckedKeys: LuauPolyfill.Set<string>,
	-- deviation: omitting fields _getBabelTraverse and _getPrettier
	added: number,
	expand: boolean,
	matched: number,
	unmatched: number,
	updated: number
}

local SnapshotState = {}
SnapshotState.__index = SnapshotState

function SnapshotState.new(snapshotPath: ConfigPath, options: SnapshotStateOptions)
	local returnValue = getSnapshotData(
		snapshotPath,
		options.updateSnapshot
	)
	local data = returnValue.data
	local dirty = returnValue.dirty

	local self: SnapshotState = {
		_snapshotPath = snapshotPath,
		_initialData = data,
		_snapshotData = data,
		_dirty = dirty,
		-- deviation: omitting assignment for getBabelTraverse, getPrettier
		_inlineSnapshots = {},
		_uncheckedKeys = Set.new(Object.keys(data)),
		_counters = {},
		_index = 0,
		expand = options.expand or false,
		added = 0,
		matched = 0,
		unmatched = 0,
		_updateSnapshot = options.updateSnapshot,
		updated = 0
	}

	return setmetatable(self, SnapshotState)
end

function SnapshotState:markSnapshotsAsCheckedForTest(testName: string): ()
	for index, uncheckedKey in self._uncheckedKeys:ipairs() do
		if keyToTestName(uncheckedKey) == testName then
			self._uncheckedKeys:delete(uncheckedKey)
		end
	end
end

-- deviation: Error type annotated as any
function SnapshotState:_addSnapshot(
	key: string,
	receivedSerialized: string,
	options: {isInline: boolean, error: any?}
): ()
	self._dirty = true
	if options.isInline then
		-- ROBLOX TODO: ADO-1552 Add when we support inlineSnapshot testing
		error(Error("Jest-Roblox: inline snapshot testing is not currently supported"))
	else
		self._snapshotData[key] = receivedSerialized
	end
end

function SnapshotState:clear(): ()
	self._snapshotData = self._initialData
	self._inlineSnapshots = {}
	self._counters = {}
	self._index = 0
	self.added = 0
	self.matched = 0
	self.unmatched = 0
	self.updated = 0
end

function SnapshotState:save(): SaveStatus
	local hasExternalSnapshots = #Object.keys(self._snapshotData)
	local hasInlineSnapshots = #self._inlineSnapshots > 0
	local isEmpty = not hasExternalSnapshots and not hasInlineSnapshots

	local status: SaveStatus = {
		deleted = false,
		saved = false
	}

	-- deviation: error when FileSystemService doesn't exist
	if not CoreScriptSyncService then
		error(Error(
			'Attempting to save snapshots in an environment where CoreScriptSyncService is inaccessible.\n' ..
			'You may need to pass in --load.asRobloxScript.'
		))
	end

	-- deviation: SnapshotState._snapshotPath stores the path in the DOM of the snapshot
	-- and not the filesystem path
	-- CoreScriptSyncService:GetScriptFilePath is used to convert the test Packagescript
	-- into its filesystem location
	local snapshotPath = CoreScriptSyncService:GetScriptFilePath(_G[JEST_TEST_CONTEXT].instance)
	-- gets path of parent directory, GetScriptFilePath can only be called on ModuleScripts
	snapshotPath = getParent(snapshotPath, 1)
	snapshotPath = snapshotPath
		.. "/__snapshots__/"
		.. _G[JEST_TEST_CONTEXT].instance.Name:match("(.*)%.spec")
		.. ".snap.lua"

	if (self._dirty or self._uncheckedKeys.size) and not isEmpty then
		if hasExternalSnapshots then
			saveSnapshotFile(self._snapshotData, snapshotPath)
		end
		if hasInlineSnapshots then
			-- ROBLOX TODO: Add when we support inlineSnapshot testing
			error(Error("Jest-Roblox: inline snapshot testing is not currently supported"))
		end
		status.saved = true
	elseif not hasExternalSnapshots and require(snapshotPath) then
	 	-- deviation: omitted part of code dealing with unlinking file until we have
		-- robust final solution for I/O. This may not even be needed in our translation?
		if self._updateSnapshot == 'all' then
			error("Jest-Roblox: Updating snapshots is not yet supported, it will be included in a separate PR.")
		--	fs.unlinkSync(this._snapshotPath)
		end
		status.deleted = true
	end

	return status
end

function SnapshotState:getUncheckedCount(): number
	return self._uncheckedKeys.size or 0
end

function SnapshotState:getUncheckedKeys(): {string}
	return Array.from(self._uncheckedKeys)
end

function SnapshotState:removeUncheckedKeys(): ()
	if self._updateSnapshot == 'all' and self._uncheckedKeys.size > 0 then
		self._dirty = true
		for index, key in self._uncheckedKeys:ipairs() do
			self._snapshotData[key] = nil
		end
		self._uncheckedKeys:clear()
	end
end

function SnapshotState:match(
	snapshotMatchOptions: SnapshotMatchOptions
): SnapshotReturnOptions
	local testName = snapshotMatchOptions.testName
	local received = snapshotMatchOptions.received
	local key = snapshotMatchOptions.key
	-- local inlineSnapshot = snapshotMatchOptions.inlineSnapshot
	local isInline = snapshotMatchOptions.isInline
	local error_ = snapshotMatchOptions.error_

	self._counters[testName] = (self._counters[testName] or 0) + 1
	local count = self._counters[testName]

	if not key then
		key = testNameToKey(testName, count)
	end

	-- // Do not mark the snapshot as "checked" if the snapshot is inline and
	-- // there's an external snapshot. This way the external snapshot can be
	-- // removed with `--updateSnapshot`.

	if not (isInline and self._snapshotData[key]) then
		self._uncheckedKeys:delete(key)
	end

	local receivedSerialized = addExtraLineBreaks(serialize(received))
	local expected
	if isInline then
		-- ROBLOX TODO: ADO-1552 Add when we support inlineSnapshot testing
		error(Error("Jest-Roblox: inline snapshot testing is not currently supported"))
	else
		expected = self._snapshotData[key]
	end

	local pass = expected == receivedSerialized
	local hasSnapshot = expected ~= nil
	local snapshotPathExists, _ = pcall(function() require(self._snapshotPath) end)
	local snapshotIsPersisted = isInline or snapshotPathExists

	if pass and not isInline then
		-- // Executing a snapshot file as JavaScript and writing the strings back
		-- // when other snapshots have changed loses the proper escaping for some
		-- // characters. Since we check every snapshot in every test, use the newly
		-- // generated formatted string.
		-- // Note that this is only relevant when a snapshot is added and the dirty
		-- // flag is set.
		self._snapshotData[key] = receivedSerialized
	end

	-- // These are the conditions on when to write snapshots:
	-- //  * There's no snapshot file in a non-CI environment.
	-- //  * There is a snapshot file and we decided to update the snapshot.
	-- //  * There is a snapshot file, but it doesn't have this snaphsot.
	-- // These are the conditions on when not to write snapshots:
	-- //  * The update flag is set to 'none'.
	-- //  * There's no snapshot file or a file without this snapshot on a CI environment.
	if
		(hasSnapshot and self._updateSnapshot == 'all') or
		((not hasSnapshot or not snapshotIsPersisted) and
			(self._updateSnapshot == 'new' or self._updateSnapshot == 'all'))
	then
		if self._updateSnapshot == 'all' then
			if not pass then
				if hasSnapshot then
					self.updated = self.updated + 1
				else
					self.added = self.added + 1
				end
				self:_addSnapshot(key, receivedSerialized, {error = error_, isInline = isInline})
			else
				self.matched = self.matched + 1
			end
		else
			self:_addSnapshot(key, receivedSerialized, {error = error_, isInline = isInline})
			self.added = self.added + 1
		end

		return {
			actual = "",
			count = count,
			expected = "",
			key = key,
			pass = true
		}
	else
		if not pass then
			self.unmatched = self.unmatched + 1
			local expectedValue
			if expected then
				expectedValue = removeExtraLineBreaks(expected)
			else
				expectedValue = nil
			end
			return {
				actual = removeExtraLineBreaks(receivedSerialized),
				count = count,
				expected = expectedValue,
				key = key,
				pass = false
			}
		else
			self.matched = self.matched + 1
			return {
				actual = "",
				count = count,
				expected = "",
				key = key,
				pass = true
			}
		end
	end
end

-- deviation: changed string? to string so that return type could align
function SnapshotState:fail(testName: string, _received: any, key: string): string
	self._counters[testName] = (self._counters[testName] or 0) + 1
	local count = self._counters[testName]

	key = key or testNameToKey(testName, count)

	self._uncheckedKeys:delete(key)
	self.unmatched = self.unmatched + 1
	return key
end

return SnapshotState