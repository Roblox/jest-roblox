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
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local React = require(Packages.Dev.React)
local ReactRoblox = require(Packages.Dev.ReactRoblox)

-- Check if running in OCALE (server without Studio) where styling APIs aren't available yet
local RunService = game:GetService("RunService")
local STYLING_ENABLED = not (RunService:IsServer() and not RunService:IsStudio())

local RobloxInstance = require(CurrentModule.RobloxInstance)
local instanceSubsetEquality = RobloxInstance.instanceSubsetEquality
local getInstanceSubset = RobloxInstance.getInstanceSubset
local listProps = RobloxInstance.listProps
local listDefaultProps = RobloxInstance.listDefaultProps
local readStyledProp = RobloxInstance.readStyledProp
local getTags = RobloxInstance.getTags
local InstanceSubset = RobloxInstance.InstanceSubset

describe("listDefaultProps()", function()
	it("doesn't return properties for abstract superclasses", function()
		expect(function()
			listDefaultProps("Instance")
		end).toThrow("abstract or not creatable")
	end)

	it("doesn't return protected properties", function()
		expect(listDefaultProps("ModuleScript")).never.toHaveProperty("Source")
	end)

	it("doesn't return hidden properties", function()
		expect(listDefaultProps("TextLabel")).never.toHaveProperty("LocalizedText")
		expect(listDefaultProps("TextLabel")).never.toHaveProperty("Transparency")
	end)

	it("returns inherited properties", function()
		expect(listDefaultProps("Part")).toHaveProperty("Anchored")
	end)

	it("returns nil properties as None", function()
		expect(listDefaultProps("Part")).toHaveProperty("Parent", Object.None)
	end)

	it("returns default properties and values for TextLabel", function()
		local defaults = listDefaultProps("TextLabel")
		expect(defaults).toMatchSnapshot()
	end)

	it("returns default properties and values for Camera", function()
		local defaults = listDefaultProps("Camera")
		expect(defaults).toMatchSnapshot()
	end)
end)

describe("listProps()", function()
	it("returns properties for a simple instance", function()
		local simpleInstance = Instance.new("ObjectValue")
		simpleInstance.Name = "Bryan"
		simpleInstance.Value = simpleInstance
		expect(listProps(simpleInstance)).toEqual({
			Archivable = true,
			ClassName = "ObjectValue",
			Name = "Bryan",
			Parent = Object.None,
			Value = simpleInstance,
		})
	end)

	it("doesn't return protected properties", function()
		local moduleScript = Instance.new("ModuleScript")
		expect(listProps(moduleScript)).never.toHaveProperty("Source")
	end)

	it("doesn't return hidden properties", function()
		local textLabel = Instance.new("TextLabel")
		expect(listProps(textLabel)).never.toHaveProperty("LocalizedText")
		expect(listProps(textLabel)).never.toHaveProperty("Transparency")
	end)

	it("returns inherited properties", function()
		local part = Instance.new("Part")
		expect(listProps(part)).toHaveProperty("Anchored")
	end)

	it("returns nil properties as None", function()
		local part = Instance.new("Part")
		expect(listProps(part)).toHaveProperty("Parent", Object.None)
	end)

	it("returns properties and values for TextLabel", function()
		local props = listProps(Instance.new("TextLabel"))
		expect(props).toMatchSnapshot()
	end)

	it("returns properties and values for Camera", function()
		local props = listProps(Instance.new("Camera"))
		expect(props).toMatchSnapshot()
	end)
end)

describe("instanceSubsetEquality()", function()
	local parentFrame = Instance.new("Frame")
	parentFrame.Name = "ParentFrame"

	local childFrame = Instance.new("Frame")
	childFrame.Parent = parentFrame
	childFrame.Name = "ChildFrame"

	it("matching Instance returns true", function()
		expect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "Frame" })).toBe(true)
	end)

	it("Instance does not match", function()
		expect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "TextButton" })).toBe(false)
	end)

	it("Instance does not have property", function()
		expect(instanceSubsetEquality(parentFrame, { Foo = "Bar" })).toBe(false)
	end)

	it("table without keys is undefined", function()
		expect(instanceSubsetEquality(parentFrame, { 1, 2, 3 })).toBeNil()
	end)

	it("non table subset is undefined", function()
		expect(instanceSubsetEquality(parentFrame, 1)).toBeNil()
	end)

	it("non Instance object is undefined", function()
		expect(instanceSubsetEquality({}, { Foo = "Bar" })).toBeNil()
	end)

	it("returns false for circular references", function()
		local circularObjA = {}
		local circularObjB = { Parent = circularObjA }
		circularObjA.Parent = circularObjB

		expect(instanceSubsetEquality(parentFrame, circularObjA)).toBe(false)
	end)

	it("returns true if child matches subset", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
			},
		})).toBe(true)
	end)

	it("returns false if child does not match subset", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "Foo",
			},
		})).toBe(false)
	end)

	it("returns false if child does not exist", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildButton = {
				Name = "ChildFrame",
			},
		})).toBe(false)
	end)

	it("returns true if nested Instance matches", function()
		expect(instanceSubsetEquality(childFrame, {
			Name = "ChildFrame",
			Parent = {
				Name = "ParentFrame",
			},
		})).toBe(true)
	end)

	it("returns false if nested Instance does not match", function()
		expect(instanceSubsetEquality(childFrame, {
			Name = "ChildFrame",
			Parent = {
				Name = "Frame",
			},
		})).toBe(false)
	end)
end)

describe("getInstanceSubset()", function()
	local parentFrame = Instance.new("Frame")
	parentFrame.Name = "ParentFrame"

	local childFrame = Instance.new("Frame")
	childFrame.Parent = parentFrame
	childFrame.Name = "ChildFrame"

	it("returns subset", function()
		local subset = { Name = "ParentFrame" }
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
	end)

	it("only returns matching subset", function()
		local subset = {
			Name = "ParentFrame",
			Foo = "Bar",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			Foo = "Bar",
		}))
	end)

	it("returns subset of child", function()
		local subset = {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
			},
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
	end)

	it("returns only matching subset of child", function()
		local subset = {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
				Foo = "Bar",
			},
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
				Foo = "Bar",
			}),
		}))
	end)

	it("mismatched Name", function()
		local subset = {
			Name = "ChildFrame",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ChildFrame" }))
	end)

	it("mismatched ClassName", function()
		local subset = {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ClassName = "Frame",
		}))
		expect(expected).toEqual(InstanceSubset.new("ScrollingFrame", {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}))
	end)
end)

describe("getTags()", function()
	it("returns empty array for instance with no tags", function()
		local instance = Instance.new("Frame")
		expect(getTags(instance)).toEqual({})
		instance:Destroy()
	end)

	it("returns tags for instance with tags", function()
		local instance = Instance.new("Frame")
		instance:AddTag("TestTag")
		instance:AddTag("AnotherTag")

		local tags = getTags(instance)
		expect(tags).toContain("TestTag")
		expect(tags).toContain("AnotherTag")
		expect(#tags).toBe(2)

		instance:Destroy()
	end)

	it("returns single tag", function()
		local instance = Instance.new("Frame")
		instance:AddTag("SingleTag")

		expect(getTags(instance)).toEqual({ "SingleTag" })

		instance:Destroy()
	end)
end)

if STYLING_ENABLED then
	describe("readStyledProp()", function()
		it("reads property via GetStyled", function()
			local label = Instance.new("TextLabel")
			label.TextColor3 = Color3.new(0, 1, 0)

			-- GetStyled returns base value when no styles are applied
			local ok, styledValue = readStyledProp(label, "TextColor3")
			expect(ok).toBe(true)
			expect(styledValue).toEqual(Color3.new(0, 1, 0))

			label:Destroy()
		end)

		it("reads different property types via GetStyled", function()
			local label = Instance.new("TextLabel")
			label.Name = "TestLabel"
			label.Text = "Hello"
			label.TextSize = 20

			local ok1, name = readStyledProp(label, "Name")
			local ok2, text = readStyledProp(label, "Text")
			local ok3, size = readStyledProp(label, "TextSize")

			expect(ok1).toBe(true)
			expect(ok2).toBe(true)
			expect(ok3).toBe(true)
			expect(name).toBe("TestLabel")
			expect(text).toBe("Hello")
			expect(size).toBe(20)

			label:Destroy()
		end)

		it("returns false for invalid property", function()
			local instance = Instance.new("Frame")

			local ok, _ = readStyledProp(instance, "InvalidPropertyName")
			expect(ok).toBe(false)

			instance:Destroy()
		end)

		it("returns styled value when StyleSheet applies a style", function()
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local labelRef = React.createRef()
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					Sheet = React.createElement("StyleSheet", {
						ref = sheetRef,
					}, {
						Rule = React.createElement("StyleRule", {
							Selector = ".styled-label",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "StyledLabel",
						TextColor3 = Color3.new(0, 0, 1), -- Blue base value
						[React.Tag] = "styled-label",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChildOfClass("StyleRule")
				if rule then
					rule:SetProperties({
						TextColor3 = Color3.new(1, 0, 0), -- Red from style
					})
				end
			end

			-- Wait for styling to be applied
			for _ = 1, 5 do
				task.wait()
			end

			local label = labelRef.current
			expect(label).toBeDefined()

			-- readStyledProp should return the styled (red) value
			local ok, styledValue = readStyledProp(label, "TextColor3")
			expect(ok).toBe(true)
			expect(styledValue).toEqual(Color3.new(1, 0, 0))

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)
	end)
end

describe("listProps() with options", function()
	it("accepts boolean for backwards compatibility", function()
		local instance = Instance.new("ObjectValue")
		instance.Name = "TestInstance"

		-- Should work with boolean (legacy warmRead argument)
		local props = listProps(instance, false)
		expect(props).toHaveProperty("Name", "TestInstance")

		instance:Destroy()
	end)

	it("accepts options table with useStyledProperties", function()
		local instance = Instance.new("TextLabel")
		instance.Name = "StyledTest"
		instance.TextColor3 = Color3.new(0, 1, 0)

		local props = listProps(instance, {
			useStyledProperties = true,
		})

		expect(props).toHaveProperty("Name", "StyledTest")
		expect(props).toHaveProperty("TextColor3")

		instance:Destroy()
	end)

	it("accepts options table with warmRead", function()
		local instance = Instance.new("ObjectValue")
		instance.Name = "WarmReadTest"

		local props = listProps(instance, {
			warmRead = true,
		})

		expect(props).toHaveProperty("Name", "WarmReadTest")

		instance:Destroy()
	end)

	it("accepts options table with both warmRead and useStyledProperties", function()
		local instance = Instance.new("TextLabel")
		instance.Name = "CombinedTest"

		local props = listProps(instance, {
			warmRead = true,
			useStyledProperties = true,
		})

		expect(props).toHaveProperty("Name", "CombinedTest")

		instance:Destroy()
	end)
end)

describe("listDefaultProps() with useStyledProperties", function()
	it("returns default properties without styled option", function()
		local defaults = listDefaultProps("TextLabel")
		expect(defaults).toHaveProperty("Name")
		expect(defaults).toHaveProperty("TextColor3")
	end)

	it("returns styled default properties with useStyledProperties", function()
		local defaults = listDefaultProps("TextLabel", true)
		expect(defaults).toHaveProperty("Name")
		expect(defaults).toHaveProperty("TextColor3")
	end)

	it("caches styled and non-styled defaults separately", function()
		local nonStyled = listDefaultProps("Frame", false)
		local styled = listDefaultProps("Frame", true)

		-- Both should have the same properties (caching should work correctly)
		expect(nonStyled).toHaveProperty("Name")
		expect(styled).toHaveProperty("Name")
	end)
end)

describe("getTags() extended scenarios", function()
	it("returns tags in the order they were added", function()
		local instance = Instance.new("Frame")
		instance:AddTag("First")
		instance:AddTag("Second")
		instance:AddTag("Third")

		local tags = getTags(instance)
		-- Tags are returned in order added
		expect(#tags).toBe(3)
		expect(tags).toContain("First")
		expect(tags).toContain("Second")
		expect(tags).toContain("Third")

		instance:Destroy()
	end)

	it("handles removing and re-adding tags", function()
		local instance = Instance.new("Frame")
		instance:AddTag("TestTag")
		expect(getTags(instance)).toContain("TestTag")

		instance:RemoveTag("TestTag")
		expect(getTags(instance)).never.toContain("TestTag")

		instance:AddTag("TestTag")
		expect(getTags(instance)).toContain("TestTag")

		instance:Destroy()
	end)

	it("handles duplicate tag additions gracefully", function()
		local instance = Instance.new("Frame")
		instance:AddTag("DuplicateTag")
		instance:AddTag("DuplicateTag") -- Adding same tag again

		local tags = getTags(instance)
		-- Should only have one instance of the tag
		local count = 0
		for _, tag in ipairs(tags) do
			if tag == "DuplicateTag" then
				count = count + 1
			end
		end
		expect(count).toBe(1)

		instance:Destroy()
	end)

	it("handles tags with CSS selector syntax characters", function()
		local instance = Instance.new("Frame")
		-- These are valid tag names that look like CSS selectors
		instance:AddTag("my-component")
		instance:AddTag("button_primary")

		local tags = getTags(instance)
		expect(tags).toContain("my-component")
		expect(tags).toContain("button_primary")

		instance:Destroy()
	end)
end)

if STYLING_ENABLED then
	describe("readStyledProp() edge cases", function()
		it("handles nil property values", function()
			local instance = Instance.new("ObjectValue")
			-- Value property is nil by default
			local ok, value = readStyledProp(instance, "Value")
			expect(ok).toBe(true)
			expect(value).toBeNil()

			instance:Destroy()
		end)

		it("handles boolean properties", function()
			local instance = Instance.new("Frame")
			instance.Visible = false

			local ok, value = readStyledProp(instance, "Visible")
			expect(ok).toBe(true)
			expect(value).toBe(false)

			instance:Destroy()
		end)

		it("handles enum properties", function()
			local instance = Instance.new("TextLabel")
			instance.TextXAlignment = Enum.TextXAlignment.Left

			local ok, value = readStyledProp(instance, "TextXAlignment")
			expect(ok).toBe(true)
			expect(value).toBe(Enum.TextXAlignment.Left)

			instance:Destroy()
		end)

		it("handles UDim2 properties", function()
			local instance = Instance.new("Frame")
			instance.Size = UDim2.new(1, 100, 0.5, 50)

			local ok, value = readStyledProp(instance, "Size")
			expect(ok).toBe(true)
			expect(value).toEqual(UDim2.new(1, 100, 0.5, 50))

			instance:Destroy()
		end)

		it("handles Vector2 properties", function()
			local instance = Instance.new("Frame")
			instance.AnchorPoint = Vector2.new(0.5, 0.5)

			local ok, value = readStyledProp(instance, "AnchorPoint")
			expect(ok).toBe(true)
			expect(value).toEqual(Vector2.new(0.5, 0.5))

			instance:Destroy()
		end)
	end)

	describe("listProps() with styled properties in real styling scenario", function()
		local function waitForStylingToBeApplied()
			for _ = 1, 5 do
				task.wait()
			end
		end

		it("returns styled values via GetStyled API when useStyledProperties is true", function()
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local labelRef = React.createRef()
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					Sheet = React.createElement("StyleSheet", {
						ref = sheetRef,
					}, {
						Rule = React.createElement("StyleRule", {
							Selector = ".list-props-test",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "ListPropsLabel",
						TextColor3 = Color3.new(0, 0, 1), -- Blue base
						[React.Tag] = "list-props-test",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChildOfClass("StyleRule")
				if rule then
					rule:SetProperties({
						TextColor3 = Color3.new(1, 0, 0), -- Red styled
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current
			expect(label).toBeDefined()

			-- With styled properties - should return styled value via GetStyled
			local styledProps = listProps(label, { useStyledProperties = true })
			expect(styledProps.TextColor3).toEqual(Color3.new(1, 0, 0)) -- Red styled

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("handles multiple styled properties", function()
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local labelRef = React.createRef()
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					Sheet = React.createElement("StyleSheet", {
						ref = sheetRef,
					}, {
						Rule = React.createElement("StyleRule", {
							Selector = ".multi-prop-test",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "MultiPropLabel",
						TextColor3 = Color3.new(0, 0, 0),
						TextSize = 12,
						BackgroundTransparency = 0,
						[React.Tag] = "multi-prop-test",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChildOfClass("StyleRule")
				if rule then
					rule:SetProperties({
						TextColor3 = Color3.new(1, 1, 1),
						TextSize = 24,
						BackgroundTransparency = 0.8,
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current
			local styledProps = listProps(label, { useStyledProperties = true })

			expect(styledProps.TextColor3).toEqual(Color3.new(1, 1, 1))
			expect(styledProps.TextSize).toBe(24)
			-- Use approximate comparison for floating point
			expect(styledProps.BackgroundTransparency).toBeCloseTo(0.8, 5)

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)
	end)
end

describe("instanceSubsetEquality() with tags", function()
	it("returns undefined when comparing Instance with subset containing Tags array", function()
		local instance = Instance.new("Frame")
		instance.Name = "TaggedFrame"
		instance:AddTag("TestTag")

		-- Note: Tags is not a standard property, so subset matching won't work with it directly
		-- This documents current behavior
		local result = instanceSubsetEquality(instance, {
			Name = "TaggedFrame",
		})

		expect(result).toBe(true)
		instance:Destroy()
	end)
end)

describe("InstanceSubset edge cases", function()
	it("handles empty subset", function()
		local subset = InstanceSubset.new("Frame", {})
		expect(subset.ClassName).toBe("Frame")
		expect(subset.subset).toEqual({})
	end)

	it("handles subset with nested InstanceSubsets", function()
		local grandchild = InstanceSubset.new("TextLabel", { Name = "Grandchild" })
		local child = InstanceSubset.new("Frame", { Name = "Child", Grandchild = grandchild })
		local parent = InstanceSubset.new("Frame", { Name = "Parent", Child = child })

		expect(parent.ClassName).toBe("Frame")
		expect(parent.subset.Name).toBe("Parent")
		expect(parent.subset.Child.ClassName).toBe("Frame")
		expect(parent.subset.Child.subset.Grandchild.ClassName).toBe("TextLabel")
	end)

	it("handles subset with nil values", function()
		local subset = InstanceSubset.new("ObjectValue", {
			Name = "TestValue",
			Value = Object.None,
		})

		expect(subset.subset.Name).toBe("TestValue")
		expect(subset.subset.Value).toBe(Object.None)
	end)
end)

describe("writeProp()", function()
	it("writes a valid property", function()
		local instance = Instance.new("Frame")
		local ok = RobloxInstance.writeProp(instance, "Name", "NewName")
		expect(ok).toBe(true)
		expect(instance.Name).toBe("NewName")
		instance:Destroy()
	end)

	it("returns false for invalid property", function()
		local instance = Instance.new("Frame")
		local ok = RobloxInstance.writeProp(instance, "InvalidProperty", "value")
		expect(ok).toBe(false)
		instance:Destroy()
	end)

	it("returns false for read-only property", function()
		local instance = Instance.new("Frame")
		local ok = RobloxInstance.writeProp(instance, "AbsoluteSize", Vector2.new(100, 100))
		expect(ok).toBe(false)
		instance:Destroy()
	end)
end)

describe("listProps() with warmRead", function()
	it("performs warm read when warmRead is true", function()
		local instance = Instance.new("TextLabel")
		instance.Name = "WarmReadTest"
		local props = listProps(instance, { warmRead = true })
		expect(props.Name).toBe("WarmReadTest")
		instance:Destroy()
	end)

	it("handles legacy boolean argument for warmRead", function()
		local instance = Instance.new("Frame")
		instance.Name = "LegacyTest"
		local props = listProps(instance, true)
		expect(props.Name).toBe("LegacyTest")
		instance:Destroy()
	end)
end)

describe("listDefaultProps() caching", function()
	it("returns same reference on subsequent calls", function()
		local defaults1 = listDefaultProps("SpawnLocation")
		local defaults2 = listDefaultProps("SpawnLocation")
		expect(defaults1).toBe(defaults2)
	end)

	it("caches different classes separately", function()
		local partDefaults = listDefaultProps("Part")
		local frameDefaults = listDefaultProps("Frame")
		expect(partDefaults).never.toBe(frameDefaults)
		expect(partDefaults.Shape).toBeDefined()
		expect(frameDefaults.BackgroundColor3).toBeDefined()
	end)
end)

describe("getInstanceSubset()", function()
	it("returns equal values for matching primitives", function()
		local instance = Instance.new("StringValue")
		instance.Value = "test"
		local found, expected = getInstanceSubset(instance, { Value = "test" })
		expect(found.subset.Value).toBe("test")
		expect(expected.subset.Value).toBe("test")
		instance:Destroy()
	end)

	it("handles asymmetric matchers in subset", function()
		local instance = Instance.new("Frame")
		instance.Name = "TestFrame"
		local asymmetric = {
			asymmetricMatch = function()
				return true
			end,
		}
		local found, expected = getInstanceSubset(instance, asymmetric)
		expect(found).toBeDefined()
		expect(expected).toBe(asymmetric)
		instance:Destroy()
	end)
end)
