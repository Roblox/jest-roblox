--!nonstrict
-- Upstream: https://github.com/sindresorhus/emittery/blob/v0.11.0/test/index.js
--[[
	MIT License

	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
]]

local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local setTimeout = LuauPolyfill.setTimeout
local Symbol = LuauPolyfill.Symbol
local Promise = require(Packages.Promise)
local setImmediate = setTimeout
local TypeError = Error

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it
local itFIXME = function(description: string, ...: any)
	JestGlobals.it.todo(description)
end

-- Implement t object to match upstream test helper interface
local function pEvent(emitter, eventName, _options: { [string]: any }?)
	return emitter:once(eventName)
end
local t = {
	deepEqual = function(_self, value1, value2)
		expect(value1).toEqual(value2)
	end,
	is = function(_self, value1, value2)
		expect(value1).toBe(value2)
	end,
	true_ = function(_self, value)
		expect(value).toBe(true)
	end,
	false_ = function(_self, value)
		expect(value).toBe(false)
	end,
	pass = function(_self) end,
	fail = function(_self)
		error(Error.new("fail"))
	end,
	throws = function(_self, fn, err)
		expect(fn).toThrow(err)
	end,
	throwsAsync = function(_self, ...)
		error("throwsAsync not implemented yet")
	end,
	notThrowsAsync = function(_self, ...)
		error("notThrowsAsync not implemented yet")
	end,
}

local Emittery = require(script.Parent.Parent).default
it("on()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local calls = {}
			local function listener1()
				table.insert(calls, 1)
			end

			local function listener2()
				table.insert(calls, 2)
			end

			local function listener3()
				table.insert(calls, 3)
			end

			emitter:on("🦄", listener1)
			emitter:on("🦄", listener2)
			emitter:on(eventName, listener3)
			emitter:emit("🦄"):expect()
			emitter:emit(eventName):expect()
			t:deepEqual(calls, { 1, 2, 3 })
		end)
		:expect()
end)

it("on() - multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local count = 0
			local function listener()
				count += 1
			end

			emitter:on({ "🦄", "🐶", eventName }, listener)
			emitter:emit("🦄"):expect()
			emitter:emit("🐶"):expect()
			emitter:emit(eventName):expect()
			t:is(count, 3)
		end)
		:expect()
end)

it("on() - symbol eventName", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local calls = {}
			local function listener1()
				table.insert(calls, 1)
			end

			local function listener2()
				table.insert(calls, 2)
			end

			emitter:on(eventName, listener1)
			emitter:on(eventName, listener2)
			emitter:emit(eventName):expect()
			t:deepEqual(calls, { 1, 2 })
		end)
		:expect()
end)

it("on() - listenerAdded", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			setImmediate(function()
				return emitter:on("abc", addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerAdded, { rejectionEvents = {} }):expect()
			local eventName, listener = ref.eventName, ref.listener
			t:is(listener, addListener)
			t:is(eventName, "abc")
		end)
		:expect()
end)

it("on() - listenerRemoved", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			emitter:on("abc", addListener)
			setImmediate(function()
				return emitter:off("abc", addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerRemoved, { rejectionEvents = {} }):expect()
			local eventName, listener = ref.eventName, ref.listener
			t:is(listener, addListener)
			t:is(eventName, "abc")
		end)
		:expect()
end)

it("on() - listenerAdded onAny", function()
	return Promise.resolve():andThen(function()
		local emitter = Emittery.new()
		local function addListener()
			return 1
		end
		setImmediate(function()
			return emitter:onAny(addListener)
		end)
		local ref = pEvent(emitter, Emittery.listenerAdded, { rejectionEvents = {} }):expect()
		local eventName, listener = ref.eventName, ref.listener
		t:is(listener, addListener)
		t:is(eventName, nil)
	end)
end)

it("off() - listenerAdded", function()
	local emitter = Emittery.new()
	local off = emitter:on(Emittery.listenerAdded, function()
		return t:fail()
	end)
	off()
	emitter:emit("a")
	t:pass()
end)

it("off() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	local off = emitter:on("test", function() end)
	off()
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "unsubscribe")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("on() - listenerAdded offAny", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			emitter:onAny(addListener)
			setImmediate(function()
				return emitter:offAny(addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerRemoved):expect()
			local listener, eventName = ref.listener, ref.eventName
			t:is(listener, addListener)
			t:is(eventName, nil)
		end)
		:expect()
end)

it("on() - eventName must be a string, symbol, or number", function()
	local emitter = Emittery.new()

	emitter:on("string", function() end)
	emitter:on(Symbol("symbol"), function() end)
	emitter:on(42, function() end)

	t:throws(function()
		emitter:on(true, function() end)
	end, TypeError)
end)

it("on() - must have a listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:on("🦄")
	end, TypeError)
end)

it("on() - returns a unsubcribe method", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			local off = emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			off()
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("on() - dedupes identical listeners", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on("🦄", listener)
			emitter:on("🦄", listener)
			emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("on() - isDebug logs output", function()
	local eventStore = {}
	local calls = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function(data)
		return table.insert(calls, data)
	end)
	t:true_(#eventStore > 0)
	t:is(eventStore[1].type, "subscribe")
	t:is(eventStore[1].debugName, "testEmitter")
	t:is(eventStore[1].eventName, "test")
end)

it("events() - return() called during emit", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = nil
			emitter:on("🦄", function()
				iterator["return"](iterator)
			end)
			iterator = emitter:events("🦄")
			emitter:emit("🦄", "🌈")
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌈" })
			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("events() - return() awaits its argument", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			t:deepEqual(iterator["return"](iterator, Promise.resolve(1)):expect(), { done = true, value = 1 })
		end)
		:expect()
end)

it("events() - return() without argument", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			t:deepEqual(iterator["return"](iterator):expect(), { done = true })
		end)
		:expect()
end)

it("events() - discarded iterators should stop receiving events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")

			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { value = "🌈", done = false })
			iterator["return"](iterator):expect()
			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { done = true })

			setTimeout(function()
				emitter:emit("🦄", "🌟")
			end, 10)

			Promise.new(function(resolve)
				setTimeout(resolve, 20)
			end):expect()

			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("off()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			emitter:off("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("off() - multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on({ "🦄", "🐶", "🦊" }, listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			emitter:off({ "🦄", "🐶" }, listener)
			emitter:emit("🦄"):expect()
			emitter:emit("🐶"):expect()
			t:deepEqual(calls, { 1 })

			emitter:emit("🦊"):expect()
			t:deepEqual(calls, { 1, 1 })
		end)
		:expect()
end)

it("off() - eventName must be a string, symbol, or number", function()
	local emitter = Emittery.new()
	emitter:on("string", function() end)
	emitter:on(Symbol("symbol"), function() end)
	emitter:on(42, function() end)
	t:throws(function()
		emitter:off(true)
	end, TypeError)
end)

it("off() - no listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:off("🦄")
	end, TypeError)
end)

it("once()", function()
	return Promise.resolve()
		:andThen(function()
			local fixture = "🌈"
			local emitter = Emittery.new()
			local promise = emitter:once("🦄")
			emitter:emit("🦄", fixture)
			t:is(promise:expect(), fixture)
		end)
		:expect()
end)

it("once() - multiple event names", function()
	return Promise.resolve():andThen(function()
		local fixture = "🌈"
		local emitter = Emittery.new()
		local promise = emitter:once({ "🦄", "🐶" })
		emitter:emit("🐶", fixture)
		t:is(promise:expect(), fixture)
	end)
end)

itFIXME("once() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			emitter:once("string")
			emitter:once(Symbol("symbol"))
			emitter:once(42)
			t:throwsAsync(emitter:once("true", function() end), TypeError):expect()
		end)
		:expect()
end)

itFIXME("emit() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			emitter:emit("string")
			emitter:emit(Symbol("symbol"))
			emitter:emit(42)
			t:throwsAsync(emitter:emit(true), TypeError):expect()
		end)
		:expect()
end)

itFIXME("emit() - userland cannot emit the meta events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			t:throwsAsync(emitter:emit(Emittery.listenerRemoved), TypeError):expect()
			t:throwsAsync(emitter:emit(Emittery.listenerAdded), TypeError):expect()
		end)
		:expect()
end)

it("emit() - awaits async listeners", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local unicorn = false

			emitter:on("🦄", function()
				return Promise.resolve():andThen(function()
					Promise.resolve():expect()
					unicorn = true
				end)
			end)

			local promise = emitter:emit("🦄")
			t:false_(unicorn)
			promise:expect()
			t:true_(unicorn)
		end)
		:expect()
end)

it("emit() - calls listeners subscribed when emit() was invoked", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local off1 = emitter:on("🦄", function()
				table.insert(calls, 1)
			end)
			local p = emitter:emit("🦄")
			emitter:on("🦄", function()
				table.insert(calls, 2)
			end)
			p:expect()
			t:deepEqual(calls, { 1 })
			local off3 = emitter:on("🦄", function()
				table.insert(calls, 3)
				off1()
				emitter:on("🦄", function()
					table.insert(calls, 4)
				end)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3 })
			off3()

			local off5 = emitter:on("🦄", function()
				table.insert(calls, 5)
				emitter:onAny(function()
					table.insert(calls, 6)
				end)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5 })
			off5()

			local off8 = nil
			emitter:on("🦄", function()
				table.insert(calls, 7)
				off8()
			end)
			off8 = emitter:on("🦄", function()
				table.insert(calls, 8)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6 })

			local off10 = nil
			emitter:onAny(function()
				table.insert(calls, 9)
				off10()
			end)
			off10 = emitter:onAny(function()
				table.insert(calls, 10)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9 })

			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })

			local p2 = emitter:emit("🦄")
			emitter:clearListeners()
			p2:expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })
		end)
		:expect()
end)

it("emit() - isDebug logs output", function()
	return Promise.resolve()
		:andThen(function()
			local eventStore = {}

			local emitter = Emittery.new({
				debug = {
					name = "testEmitter",
					enabled = true,
					logger = function(_self, type_, debugName, eventName, eventData)
						table.insert(eventStore, {
							type = type_,
							debugName = debugName,
							eventName = eventName,
							eventData = eventData,
						})
					end,
				},
			})

			emitter:on("test", function() end)
			emitter:emit("test", "data"):expect()
			t:true_(#eventStore > 0)
			t:is(eventStore[3].type, "emit")
			t:is(eventStore[3].eventName, "test")
			t:is(eventStore[3].debugName, "testEmitter")
			t:is(eventStore[3].eventData, "data")
		end)
		:expect()
end)

it("emit() - returns undefined", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:on("🦄", function()
				return "🌈"
			end)
			t:is(emitter:emit("🦄"):expect(), nil)

			emitter:on("🦄🦄", function()
				return Promise.resolve():andThen(function()
					return "🌈"
				end)
			end)
			t:is(emitter:emit("🦄🦄"):expect(), nil)
		end)
		:expect()
end)

itFIXME("emit() - throws an error if any listener throws", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:on("🦄", function()
				error(Error.new("🌈"))
			end)
			t:throwsAsync(emitter:emit("🦄"), { instanceOf = Error }):expect()

			emitter:on("🦄🦄", function()
				return Promise.resolve():andThen(function()
					error(Error.new("🌈"))
				end)
			end)
			t:throwsAsync(emitter:emit("🦄🦄"), { instanceOf = Error }):expect()
		end)
		:expect()
end)

itFIXME("emitSerial() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:emitSerial("string")
			emitter:emitSerial(Symbol("symbol"))
			emitter:emitSerial(42)

			t:throwsAsync(emitter:emitSerial(true), TypeError):expect()
		end)
		:expect()
end)

itFIXME("emitSerial() - userland cannot emit the meta events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			t:throwsAsync(emitter:emitSerial(Emittery.listenerRemoved), TypeError):expect()
			t:throwsAsync(emitter:emitSerial(Emittery.listenerAdded), TypeError):expect()
		end)
		:expect()
end)

it("emitSerial() - calls listeners subscribed when emitSerial() was invoked", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local off1 = emitter:on("🦄", function()
				table.insert(calls, 1)
			end)
			local p = emitter:emitSerial("🦄")
			emitter:on("🦄", function()
				table.insert(calls, 2)
			end)
			p:expect()
			t:deepEqual(calls, { 1 })

			local off3 = emitter:on("🦄", function()
				table.insert(calls, 3)
				off1()
				emitter:on("🦄", function()
					table.insert(calls, 4)
				end)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3 })
			off3()

			local off5 = emitter:on("🦄", function()
				table.insert(calls, 5)
				emitter:onAny(function()
					table.insert(calls, 6)
				end)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5 })
			off5()

			local off8 = nil
			emitter:on("🦄", function()
				table.insert(calls, 7)
				off8()
			end)
			off8 = emitter:on("🦄", function()
				table.insert(calls, 8)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6 })

			local off10 = nil
			emitter:onAny(function()
				table.insert(calls, 9)
				off10()
			end)
			off10 = emitter:onAny(function()
				table.insert(calls, 10)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9 })

			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })

			local p2 = emitter:emitSerial("🦄")
			emitter:clearListeners()
			p2:expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })
		end)
		:expect()
end)

it("emitSerial() - isDebug logs output", function()
	return Promise.resolve()
		:andThen(function()
			local eventStore = {}

			local emitter = Emittery.new({
				debug = {
					name = "testEmitter",
					enabled = true,
					logger = function(_self, type_, debugName, eventName, eventData)
						table.insert(eventStore, {
							type = type_,
							debugName = debugName,
							eventName = eventName,
							eventData = eventData,
						})
					end,
				},
			})

			emitter:on("test", function() end)
			emitter:emitSerial("test", "data"):expect()
			t:true_(#eventStore > 0)
			t:is(eventStore[3].type, "emitSerial")
			t:is(eventStore[3].eventName, "test")
			t:is(eventStore[3].debugName, "testEmitter")
			t:is(eventStore[3].eventData, "data")
		end)
		:expect()
end)

it("onAny()", function()
	return Promise.resolve()
		:andThen(function()
			local assertCount = 0
			local emitter = Emittery.new()
			local eventFixture = { foo = true }
			emitter:onAny(function(eventName, data)
				t:is(eventName, "🦄")
				t:deepEqual(data, eventFixture)
				assertCount += 2
			end)
			emitter:emit("🦄", eventFixture):expect()
			emitter:emitSerial("🦄", eventFixture):expect()
			expect(assertCount).toBe(4)
		end)
		:expect()
end)

it("onAny() - must have a listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:onAny()
	end, TypeError)
end)

it("anyEvent() - return() called during emit", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = nil
			emitter:onAny(function()
				iterator["return"](iterator)
			end)
			iterator = emitter:anyEvent()
			emitter:emit("🦄", "🌈")
			t:deepEqual(iterator:next():expect(), { done = false, value = { "🦄", "🌈" } })
			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("anyEvents() - discarded iterators should stop receiving events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:anyEvent()

			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { value = { "🦄", "🌈" }, done = false })
			iterator["return"](iterator):expect()
			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { done = true })

			setTimeout(function()
				emitter:emit("🦄", "🌟")
			end, 10)

			Promise.new(function(resolve)
				setTimeout(resolve, 20)
			end):expect()

			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("offAny()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:onAny(listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
			emitter:offAny(listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("offAny() - no listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:offAny()
	end, TypeError)
end)

it("clearListeners()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:onAny(function()
				table.insert(calls, "any2")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
			emitter:clearListeners()
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
		end)
		:expect()
end)

it("clearListeners() - also clears iterators", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			local anyIterator = emitter:anyEvent()
			emitter:emit("🦄", "🌟"):expect()
			emitter:emit("🌈", "🌟"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌟" })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "🌟" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "🌟" } })
			emitter:emit("🦄", "💫"):expect()
			emitter:clearListeners()
			emitter:emit("🌈", "💫"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "💫" })
			t:deepEqual(iterator:next():expect(), { done = true })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "💫" } })
			t:deepEqual(anyIterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("clearListeners() - with event name", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:onAny(function()
				table.insert(calls, "any2")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
			emitter:clearListeners("🦄")
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, {
				"🦄1",
				"🦄2",
				"any1",
				"any2",
				"🌈",
				"any1",
				"any2",
				"any1",
				"any2",
				"🌈",
				"any1",
				"any2",
			})
		end)
		:expect()
end)

it("clearListeners() - with multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "🌈", "any1" })
			emitter:clearListeners({ "🦄", "🌈" })
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "🌈", "any1", "any1", "any1" })
		end)
		:expect()
end)

it("clearListeners() - with event name - clears iterators for that event", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			local anyIterator = emitter:anyEvent()
			emitter:emit("🦄", "🌟"):expect()
			emitter:emit("🌈", "🌟"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌟" })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "🌟" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "🌟" } })
			emitter:emit("🦄", "💫"):expect()
			emitter:clearListeners("🦄")
			emitter:emit("🌈", "💫"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "💫" })
			t:deepEqual(iterator:next():expect(), { done = true })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "💫" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "💫" } })
		end)
		:expect()
end)

it("clearListeners() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function() end)
	emitter:clearListeners("test")
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "clear")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("onAny() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:onAny(function() end)
	t:true_(#eventStore > 0)
	t:is(eventStore[1].type, "subscribeAny")
	t:is(eventStore[1].eventName, nil)
	t:is(eventStore[1].debugName, "testEmitter")
end)

it("offAny() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	local off = emitter:onAny(function() end)
	off()
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "unsubscribeAny")
	t:is(eventStore[3].eventName, nil)
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("listenerCount()", function()
	local emitter = Emittery.new()
	emitter:on("🦄", function() end)
	emitter:on("🌈", function() end)
	emitter:on("🦄", function() end)
	emitter:onAny(function() end)
	emitter:onAny(function() end)
	t:is(emitter:listenerCount("🦄"), 4)
	t:is(emitter:listenerCount("🌈"), 3)
	t:is(emitter:listenerCount(), 5)
end)

it("listenerCount() - multiple event names", function()
	local emitter = Emittery.new()
	emitter:on("🦄", function() end)
	emitter:on("🌈", function() end)
	emitter:on("🦄", function() end)
	emitter:onAny(function() end)
	emitter:onAny(function() end)
	t:is(emitter:listenerCount({ "🦄", "🌈" }), 7)
	t:is(emitter:listenerCount(), 5)
end)

it("listenerCount() - works with empty eventName strings", function()
	local emitter = Emittery.new()
	emitter:on("", function() end)
	t:is(emitter:listenerCount(""), 1)
end)

it("listenerCount() - eventName must be undefined if not a string, symbol, or number", function()
	local emitter = Emittery.new()
	emitter:listenerCount("string")
	emitter:listenerCount(Symbol("symbol"))
	emitter:listenerCount(42)
	emitter:listenerCount()
	t:throws(function()
		emitter:listenerCount(true)
	end, TypeError)
end)

itFIXME("isDebug default logger handles symbol event names and object for event data", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new({ debug = { name = "testEmitter", enabled = true } })
			local eventName = Symbol("test")
			emitter:on(eventName, function() end)
			t:notThrowsAsync(emitter:emit(eventName, { complex = { "data", "structure", 1 } })):expect()
		end)
		:expect()
end)

it("isDebug can be turned on globally during runtime", function()
	Emittery.setIsDebugEnabled(true)
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = false,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function() end)
	emitter:emit("test", "test data")
	Emittery.setIsDebugEnabled(false)
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "emit")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
	t:is(eventStore[3].eventData, "test data")
end)

it("isDebug can be turned on for and instance without using the constructor", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = false,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})
	emitter.debug.enabled = true

	emitter:on("test", function() end)
	emitter:emit("test", "test data")
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "emit")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
	t:is(eventStore[3].eventData, "test data")
end)

itFIXME("debug mode - handles circular references in event data", function()
	return Promise.resolve():andThen(function()
		local emitter = Emittery.new({ debug = { name = "testEmitter", enabled = true } })

		local data = {}
		data.circular = data

		t:notThrowsAsync(emitter:emit("test", data)):expect()
	end)
end)
