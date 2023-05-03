-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/pretty-format/src/__tests__/ReactElement.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local React = require(Packages.Dev.React)

type ReactElement = React.ReactElement
local PrettyFormat = require(CurrentModule)
local plugins = PrettyFormat.plugins
local setPrettyPrint = require(script.Parent.setPrettyPrint).default
local ReactElement = plugins.ReactElement
local JestGlobals = require(Packages.Dev.JestGlobals)
-- ROBLOX deviation START: importing expectExtended to avoid analyze errors for additional matchers
local expect = JestGlobals.expectExtended
-- ROBLOX deviation END
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- ROBLOX deviation: define `ReturnType` type until Luau starts to support it
type ReturnType<T> = any

setPrettyPrint({ ReactElement })

describe("ReactElement Plugin", function()
	--[[
			ROBLOX deviation START: use callable table instead of TSCallSignatureDeclaration
			original code:
			let forwardRefComponent: {
			  (_props: unknown, _ref: unknown): React.ReactElement | null;
			  displayName?: string;
			};
		]]
	local forwardRefComponent: typeof(setmetatable({} :: {
		displayName: string?,
	}, {
		__call = (function() end :: any) :: (_self: any, _props: unknown, _ref: unknown) -> ReactElement | nil,
	}))
	-- ROBLOX deviation END

	local forwardRefExample: ReturnType<typeof(React.forwardRef)>

	beforeEach(function()
		forwardRefComponent = setmetatable({}, {
			__call = function(_self: any, _props: unknown, _ref: unknown)
				return nil
			end,
		})

		-- ROBLOX FIXME roact-alignment: forwardRef doesn't accept callable table: https://github.com/Roblox/roact-alignment/issues/283
		forwardRefExample =
			React.forwardRef((forwardRefComponent :: any) :: (_props: unknown, _ref: unknown) -> ReactElement | nil)

		forwardRefExample.displayName = nil
	end)

	it("serializes forwardRef without displayName", function()
		forwardRefExample = React.forwardRef(function(_props, _ref)
			return nil
		end)
		expect(React.createElement(forwardRefExample)).toPrettyPrintTo("<ForwardRef />")
	end)

	it("serializes forwardRef with displayName", function()
		forwardRefExample.displayName = "Display"
		expect(React.createElement(forwardRefExample)).toPrettyPrintTo("<Display />")
	end)

	it("serializes forwardRef component with displayName", function()
		forwardRefComponent.displayName = "Display"
		expect(React.createElement(forwardRefExample)).toPrettyPrintTo("<ForwardRef(Display) />")
	end)
end)
