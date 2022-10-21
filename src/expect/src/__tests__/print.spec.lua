--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local Print = require(CurrentModule.print)

local JestMatcherUtils = require(Packages.JestMatcherUtils)
local EXPECTED_COLOR = JestMatcherUtils.EXPECTED_COLOR

local expect = require(CurrentModule)

describe("printing constructor", function()
	local Dog

	beforeEach(function()
		Dog = {}
		Dog.__index = Dog

		setmetatable(Dog, {
			__tostring = function(self)
				return "Dog"
			end,
		})
	end)

	it("prints constructor name", function()
		expect(Print.printExpectedConstructorName("Expected", Dog)).toEqual(
			string.format("Expected: %s\n", EXPECTED_COLOR("Dog"))
		)
	end)

	it("prints constructor name (not)", function()
		expect(Print.printExpectedConstructorNameNot("Expected", Dog)).toEqual(
			string.format("Expected: never %s\n", EXPECTED_COLOR("Dog"))
		)
	end)

	it("reports that tostring returns empty", function()
		setmetatable(Dog, {
			__tostring = function(self)
				return ""
			end,
		})

		expect(Print.printReceivedConstructorName("Received", Dog)).toEqual("Received name is an empty string\n")
	end)

	it("prints some entries of non-tostring class", function()
		setmetatable(Dog, {})
		Dog.fur = "brown"
		Dog.goodboy = true

		local result = Print.printReceivedConstructorName("Received", Dog)
		expect(result).toContain("Received: [31m{")
		expect(result).toContain('"fur": "brown"')
		expect(result).toContain('"goodboy": true')
		expect(result).toContain(" }")
	end)

	it("prints ... for excessive key value", function()
		setmetatable(Dog, {})
		Dog.leash = "blue"
		Dog.weight = 80
		Dog.height = 48
		Dog.charisma = "friendly"

		local result = Print.printReceivedConstructorName("Received", Dog)
		expect(result).toContain("Received: [31m{")
		expect(result).toContain('"leash": "blue"')
		expect(result).toContain('"weight": 80')
		expect(result).toContain('"height": 48')
		expect(result).toContain(" ... ")
		expect(result).toContain(" }")
	end)

	it("defaults to printing table address for massive key value pair", function()
		setmetatable(Dog, {})
		Dog.furotherwiseknownasapersonallyidentifyingattributeofamammal = "brown"

		local result = Print.printExpectedConstructorName("Expected", Dog)
		expect(result).toContain("Expected: [32mtable: 0x")
	end)

	it("prints function names only", function()
		setmetatable(Dog, {})
		Dog.walk = function() end
		Dog.talk = function() end
		Dog.wagTail = function() end

		local result = Print.printExpectedConstructorName("Received", Dog)
		expect(result).toContain("Received: [32m{")
		expect(result).toContain('"walk"')
		expect(result).toContain('"wagTail"')
		expect(result).toContain('"talk')
		expect(result).toContain(" }")
	end)

	describe("printReceivedConstructorNameNot", function()
		it("prints name for class with tostring", function()
			setmetatable(Dog, {
				__tostring = function(self)
					return "Doge"
				end,
			})
			local result = Print.printExpectedConstructorNameNot("Received", Dog)
			expect(result).toContain("Received: never [32mDoge")
		end)

		it('does not print name or "never" for class with empty tostring', function()
			setmetatable(Dog, {
				__tostring = function(self)
					return ""
				end,
			})

			local result = Print.printExpectedConstructorNameNot("Received", Dog)
			expect(result).toContain("Received name is an empty string")
		end)

		it('does not print "never" for class with default table address as tostring', function()
			setmetatable(Dog, {})

			local result = Print.printExpectedConstructorNameNot("Received", Dog)
			expect(result).toContain("Received: never [32mtable: 0x")
		end)

		it("prints table contents", function()
			setmetatable(Dog, {})
			-- Sanity check that once we give Dog some properties, it
			-- prints out the contents not the table address
			Dog.height = 50
			Dog.goodboy = true
			local result = Print.printExpectedConstructorNameNot("Received", Dog)
			expect(result).toContain("Received: never [32m{")
			expect(result).toContain('"height": 50')
			expect(result).toContain('"goodboy": true')
			expect(result).toContain(" }")
		end)
	end)
end)
