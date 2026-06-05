--!nonstrict
-- ROBLOX upstream: https://github.com/sindresorhus/emittery/blob/v0.11.0/index.js
-- ROBLOX upstream types: https://github.com/sindresorhus/emittery/blob/v0.11.0/index.d.ts
--[[
	MIT License

	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
]]
local Packages = script.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local Symbol = require(Packages.Symbol)
local jestTypesModule = require(Packages.JestTypes)
local Error = jestTypesModule.Error
type Promise<T> = jestTypesModule.Promise<T>

local Promise = require(Packages.Promise)

type EventName = string | number

local HttpService = game:GetService("HttpService")

local isMetaEvent

-- Special marker because { nil } is equivalent to empty array and won't be iterated over
local NIL = Object.None

local anyMap = WeakMap.new()
local eventsMap = WeakMap.new()
local producersMap = WeakMap.new()
local anyProducer = Symbol("anyProducer")
local resolvedPromise = Promise.resolve()

-- Define symbols for "meta" events.
local listenerAdded = Symbol("listenerAdded")
local listenerRemoved = Symbol("listenerRemoved")

-- Define a symbol that allows internal code to emit meta events, but prevents userland from doing so.
local metaEventsAllowed = Symbol("metaEventsAllowed")

local isGlobalDebugEnabled = false

local function isSymbol(value: any): boolean
	return typeof(value) == "userdata" and tostring(value):match("Symbol%(.*%)") ~= nil
end

-- Allows both functions and callable tables to be passed as listeners
local function isCallable(f: any): boolean
	return typeof(f) == "function"
		or (
			typeof(f) == "table"
			and typeof(getmetatable(f)) == "table"
			and typeof(getmetatable(f).__call) == "function"
		)
end

local function assertEventName(eventName, allowMetaEvents)
	if typeof(eventName) ~= "string" and not isSymbol(eventName) and typeof(eventName) ~= "number" then
		error(Error.new("`eventName` must be a string, symbol, or number"))
	end
	if isMetaEvent(eventName) and allowMetaEvents ~= metaEventsAllowed then
		error(Error.new("`eventName` cannot be meta event `listenerAdded` or `listenerRemoved`"))
	end
end

local function assertListener(listener)
	if not isCallable(listener) then
		error(Error.new("listener must be a function"))
	end
end

local function getListeners(instance, eventName)
	local events = eventsMap:get(instance)
	if not events:has(eventName) then
		events:set(eventName, Set.new())
	end
	return events:get(eventName)
end

local function getEventProducers(instance, eventName)
	local key = if typeof(eventName) == "string"
			or isSymbol(eventName)
			or typeof(eventName) == "number"
		then eventName
		else anyProducer
	local producers = producersMap:get(instance)
	if not producers:has(key) then
		producers:set(key, Set.new())
	end
	return producers:get(key)
end

local function enqueueProducers(instance, eventName, eventData)
	local producers = producersMap:get(instance)
	if producers:has(eventName) then
		for _, producer in producers:get(eventName) do
			producer:enqueue(eventData)
		end
	end
	if producers:has(anyProducer) then
		local item = Promise.all({
			Promise.resolve(eventName),
			Promise.resolve(eventData),
		})
		for _, producer in producers:get(anyProducer) do
			producer:enqueue(item)
		end
	end
end

local function iterator(instance, eventNames)
	eventNames = if type(eventNames) == "table" then eventNames elseif eventNames ~= nil then { eventNames } else { NIL }
	local isFinished = false
	local function flush() end
	local queue = {} :: { any }?

	local producer = {
		enqueue = function(self, item)
			table.insert(queue, item)
			flush()
		end,
		finish = function(self)
			isFinished = true
			flush()
		end,
	}

	for _, eventName in eventNames do
		getEventProducers(instance, eventName):add(producer)
	end

	return {
		next = function(self)
			return Promise.resolve():andThen(function()
				if queue == nil then
					return { done = true }
				end
				if #queue == 0 then
					if isFinished then
						queue = nil
						return self:next()
					end

					Promise.new(function(resolve)
						flush = resolve
					end):expect()

					return self:next()
				end
				return {
					done = false,
					value = Promise.resolve(table.remove(queue, 1) :: any):expect(),
				}
			end)
		end,
		["return"] = function(self, ...)
			local value = ...
			local arguments = { ... }
			return Promise.resolve():andThen(function()
				queue = nil

				for _, eventName in eventNames do
					getEventProducers(instance, eventName):delete(producer)
				end

				flush()

				return if #arguments > 0 then { done = true, value = value:expect() } else { done = true }
			end)
		end,
	}
end

function isMetaEvent(eventName)
	return eventName == listenerAdded or eventName == listenerRemoved
end

export type Emittery = {
	new: (options: { [string]: any }?) -> Emittery,
	logIfDebugEnabled: (self: Emittery, type_: any, eventName: any, eventData: any) -> any,
	on: (self: Emittery, eventNames: any, listener: any) -> Emittery_UnsubscribeFn,
	off: (self: Emittery, eventNames: any, listener: any) -> any,
	once: (self: Emittery, eventNames: any) -> any,
	events: (self: Emittery, eventNames: any) -> any,
	emit: (self: Emittery, eventName: any, eventData: any, allowMetaEvents: any?) -> any,
	emitSerial: (self: Emittery, eventName: any, eventData: any, allowMetaEvents: any) -> any,
	onAny: (self: Emittery, listener: any) -> any,
	anyEvent: (self: Emittery) -> any,
	offAny: (self: Emittery, listener: any) -> Emittery_UnsubscribeFn,
	clearListeners: (self: Emittery, eventNames: any) -> any,
	listenerCount: (self: Emittery, eventNames: any) -> any,
}
local Emittery = {} :: Emittery;
(Emittery :: any).__index = Emittery
function Emittery.new(options_: { [string]: any }?): Emittery
	local self = setmetatable({}, Emittery)
	local options = if options_ ~= nil then options_ else {}
	anyMap:set(self, Set.new())
	eventsMap:set(self, Map.new())
	producersMap:set(self, Map.new())
	self.debug = options.debug or {}

	if self.debug.enabled == nil then
		self.debug.enabled = false
	end

	if not self.debug.logger then
		self.debug.logger = function(_self: any, type_, debugName, eventName, eventData)
			xpcall(function()
				-- TODO: Use https://github.com/sindresorhus/safe-stringify when the package is more mature. Just copy-paste the code.
				eventData = HttpService:JSONEncode(eventData)
			end, function()
				local keys = {}
				for k in eventData do
					table.insert(keys, k)
				end
				eventData = ("Object with the following keys failed to stringify: %s"):format(table.concat(keys, ","))
			end)

			if isSymbol(eventName) or typeof(eventName) == "number" then
				eventName = tostring(eventName)
			end

			local currentTime = DateTime.now():ToUniversalTime()
			local logTime = ("%d:%d:%d.%d"):format(
				currentTime.Hour,
				currentTime.Minute,
				currentTime.Second,
				currentTime.Millisecond
			)
			print(
				("[%s][emittery:%s][%s] Event Name: %s\n\tdata: %s"):format(
					logTime,
					tostring(type_),
					tostring(debugName),
					tostring(eventName),
					tostring(eventData)
				)
			)
		end
	end
	return (self :: any) :: Emittery
end

function Emittery.getIsDebugEnabled(): boolean
	return isGlobalDebugEnabled
end

function Emittery.setIsDebugEnabled(newValue: boolean)
	isGlobalDebugEnabled = newValue
end

function Emittery:logIfDebugEnabled(type_, eventName, eventData)
	if Emittery.getIsDebugEnabled() or self.debug.enabled then
		self.debug:logger(type_, self.debug.name, eventName, eventData)
	end
end

function Emittery:on(eventNames, listener)
	assertListener(listener)

	eventNames = if type(eventNames) == "table" then eventNames else { eventNames }
	for _, eventName in eventNames do
		assertEventName(eventName, metaEventsAllowed)
		getListeners(self, eventName):add(listener)

		self:logIfDebugEnabled("subscribe", eventName, nil)

		if not isMetaEvent(eventName) then
			self:emit(listenerAdded, { eventName = eventName, listener = listener }, metaEventsAllowed)
		end
	end
	return function()
		return self:off(eventNames, listener)
	end
end

function Emittery:off(eventNames, listener)
	assertListener(listener)

	eventNames = if type(eventNames) == "table" then eventNames else { eventNames }
	for _, eventName in eventNames do
		assertEventName(eventName, metaEventsAllowed)
		getListeners(self, eventName):delete(listener)

		self:logIfDebugEnabled("unsubscribe", eventName, nil)

		if not isMetaEvent(eventName) then
			self:emit(listenerRemoved, { eventName = eventName, listener = listener }, metaEventsAllowed)
		end
	end
end

function Emittery:once(eventNames)
	return Promise.new(function(resolve)
		local off
		off = self:on(eventNames, function(data)
			off()
			resolve(data)
		end)
	end)
end

function Emittery:events(eventNames)
	eventNames = if type(eventNames) == "table" then eventNames else { eventNames }

	for _, eventName in eventNames do
		assertEventName(eventName, metaEventsAllowed)
	end

	return iterator(self, eventNames)
end

function Emittery:emit(eventName, eventData, allowMetaEvents)
	return Promise.resolve():andThen(function()
		assertEventName(eventName, allowMetaEvents)

		self:logIfDebugEnabled("emit", eventName, eventData)

		enqueueProducers(self, eventName, eventData)

		local listeners = getListeners(self, eventName)
		local anyListeners = anyMap:get(self)
		local staticListeners = {}
		for _, v in listeners do
			table.insert(staticListeners, v)
		end
		local staticAnyListeners = {}
		if not isMetaEvent(eventName) then
			for _, v in anyListeners do
				table.insert(staticAnyListeners, v)
			end
		end

		resolvedPromise
			:andThen(function(...)
				return Promise.delay(0):andThenReturn(...)
			end)
			:expect()
		local promises = {}
		for _, listener in staticListeners do
			table.insert(
				promises,
				Promise.resolve():andThen(function()
					if listeners:has(listener) then
						return listener(eventData)
					end
					return
				end)
			)
		end
		for _, listener in staticAnyListeners do
			table.insert(
				promises,
				Promise.resolve():andThen(function()
					if anyListeners:has(listener) then
						return listener(eventName, eventData)
					end
					return
				end)
			)
		end
		Promise.all(promises):expect()
	end)
end

function Emittery:emitSerial(eventName, eventData, allowMetaEvents)
	return Promise.resolve():andThen(function()
		assertEventName(eventName, allowMetaEvents)

		self:logIfDebugEnabled("emitSerial", eventName, eventData)

		local listeners = getListeners(self, eventName)
		local anyListeners = anyMap:get(self)
		local staticListeners = {}
		for _, v in listeners do
			table.insert(staticListeners, v)
		end
		local staticAnyListeners = {}
		for _, v in anyListeners do
			table.insert(staticAnyListeners, v)
		end

		resolvedPromise
			:andThen(function(...)
				return Promise.delay(0):andThenReturn(...)
			end)
			:expect()
		for _, listener in staticListeners do
			if listeners:has(listener) then
				Promise.resolve(listener(eventData)):expect()
			end
		end

		for _, listener in staticAnyListeners do
			if anyListeners:has(listener) then
				Promise.resolve(listener(eventName, eventData)):expect()
			end
		end
	end)
end

function Emittery:onAny(listener)
	assertListener(listener)

	self:logIfDebugEnabled("subscribeAny", nil, nil)

	anyMap:get(self):add(listener)
	self:emit(listenerAdded, { listener = listener }, metaEventsAllowed)
	return function()
		self:offAny(listener)
	end
end

function Emittery:anyEvent()
	return iterator(self)
end

function Emittery:offAny(listener)
	assertListener(listener)

	self:logIfDebugEnabled("unsubscribeAny", nil, nil)

	self:emit(listenerRemoved, { listener = listener }, metaEventsAllowed)
	anyMap:get(self):delete(listener)
end

function Emittery:clearListeners(eventNames)
	eventNames = if type(eventNames) == "table" then eventNames elseif eventNames ~= nil then { eventNames } else { NIL }

	for _, eventName in eventNames do
		self:logIfDebugEnabled("clear", eventName, nil)

		if typeof(eventName) == "string" or isSymbol(eventName) or typeof(eventName) == "number" then
			getListeners(self, eventName):clear()

			local producers = getEventProducers(self, eventName)

			for _, producer in producers do
				producer:finish()
			end

			producers:clear()
		else
			anyMap:get(self):clear()

			for _, listeners in eventsMap:get(self):values() do
				listeners:clear()
			end

			for _, producers in producersMap:get(self):values() do
				for _, producer in producers do
					producer:finish()
				end

				producers:clear()
			end
		end
	end
end

function Emittery:listenerCount(eventNames)
	eventNames = if type(eventNames) == "table" then eventNames elseif eventNames ~= nil then { eventNames } else { NIL }
	local count = 0

	for _, eventName in eventNames do
		if typeof(eventName) == "string" then
			count += anyMap:get(self).size + getListeners(self, eventName).size + getEventProducers(self, eventName).size + getEventProducers(
				self
			).size
			continue
		end

		if eventName ~= nil and eventName ~= NIL then
			assertEventName(eventName, metaEventsAllowed)
		end

		count += anyMap:get(self).size

		for _, value in eventsMap:get(self):values() do
			count += value.size
		end

		for _, value in producersMap:get(self):values() do
			count += value.size
		end
	end

	return count
end

Emittery.listenerAdded = listenerAdded
Emittery.listenerRemoved = listenerRemoved

--[[*
Removes an event subscription.
]]
export type Emittery_UnsubscribeFn = () -> ()

--[[*
The data provided as `eventData` when listening for `Emittery.listenerAdded` or `Emittery.listenerRemoved`.
]]
export type Emittery_ListenerChangedData = {
	--[[*
	The listener that was added or removed.
	]]
	listener: (eventData: unknown?) -> ...Promise<nil>,

	--[[*
	The name of the event that was added or removed if `.on()` or `.off()` was used, or `undefined` if `.onAny()` or `.offAny()` was used.
	]]
	eventName: EventName?,
}

return { default = Emittery }
