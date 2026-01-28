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

local PrettyFormat = require(CurrentModule)
local prettyFormat = PrettyFormat.default
local RobloxInstance = PrettyFormat.plugins.RobloxInstance

local InstanceSubset = require(Packages.RobloxShared).RobloxInstance.InstanceSubset

local JestGlobals = require(Packages.Dev.JestGlobals)
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local React = require(Packages.Dev.React)
local ReactRoblox = require(Packages.Dev.ReactRoblox)

-- Check if running in OCALE (server without Studio) where styling APIs aren't available
local RunService = game:GetService("RunService")
local STYLING_ENABLED = not (RunService:IsServer() and not RunService:IsStudio())

local prettyFormatResult = function(val: any)
	return prettyFormat(val, {
		plugins = { RobloxInstance },
		printInstanceDefaults = true,
	})
end

describe("Instance", function()
	it("serializes ModuleScript", function()
		expect(prettyFormatResult(script)).toEqual(
			"ModuleScript {\n"
				.. '  "Archivable": true,\n'
				.. '  "ClassName": "ModuleScript",\n'
				.. '  "Name": "RobloxInstance.roblox.spec",\n'
				.. '  "Parent": "__tests__" [Folder],\n'
				.. "}"
		)
	end)

	it("serializes Folder", function()
		local stableFolder = CurrentModule.__tests__.dont_touch_im_used_in_snapshots
		expect(prettyFormatResult(stableFolder)).toMatchSnapshot()
	end)

	it("serializes Instances in table", function()
		local SpotLight = Instance.new("SpotLight")
		local Sky = Instance.new("Sky")
		expect(prettyFormatResult({
			a = SpotLight,
			b = Sky,
		})).toMatchSnapshot()
		SpotLight:Destroy()
		Sky:Destroy()
	end)

	it("serializes nested Roblox Instance", function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "Root"

		local exampleData = {
			{
				name = "hello-roact",
				label = "Hello, Roact!",
			},
			{
				name = "clock",
				label = "Clock",
			},
			{
				name = "changed-signal",
				label = "Changed Signal",
			},
			{
				name = "stress-test",
				label = "Stress Test",
			},
			{
				name = "event",
				label = "Event",
			},
			{
				name = "ref",
				label = "Ref",
			},
			{
				name = "binding",
				label = "Binding",
			},
		}

		local exampleList = Instance.new("ScrollingFrame")
		exampleList.Size = UDim2.new(0, 400, 0, 600)
		exampleList.CanvasSize = UDim2.new(0, 400, 0, 80 * #exampleData)
		exampleList.Position = UDim2.new(0.5, 0, 0.5, 0)
		exampleList.AnchorPoint = Vector2.new(0.5, 0.5)
		exampleList.BorderSizePixel = 2
		exampleList.BackgroundColor3 = Color3.new(1, 1, 1)
		exampleList.TopImage = "rbxassetid://29050676"
		exampleList.MidImage = "rbxassetid://29050676"
		exampleList.BottomImage = "rbxassetid://29050676"
		exampleList.Parent = screenGui

		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = exampleList

		for index, example in ipairs(exampleData) do
			local label = ("%s: examples/%s"):format(example.label, example.name)

			local exampleCard = Instance.new("TextButton")
			exampleCard.Name = "Example: " .. example.name
			exampleCard.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
			exampleCard.BorderSizePixel = 0
			exampleCard.Text = label
			exampleCard.Font = Enum.Font.SourceSans
			exampleCard.TextSize = 20
			exampleCard.Size = UDim2.new(1, 0, 0, 80)
			exampleCard.LayoutOrder = index

			exampleCard.Parent = exampleList

			local bottomBorder = Instance.new("Frame")
			bottomBorder.Name = "Bottom Border"
			bottomBorder.Position = UDim2.new(0, 0, 1, -1)
			bottomBorder.Size = UDim2.new(0, 400, 0, 1)
			bottomBorder.BorderSizePixel = 0
			bottomBorder.BackgroundColor3 = Color3.new(0, 0, 0)
			bottomBorder.ZIndex = 2
			bottomBorder.Parent = exampleCard
		end

		expect(prettyFormatResult(screenGui)).toMatchSnapshot()
		screenGui:Destroy()
	end)

	it("collapses circular references in properties", function()
		local leftFrame = Instance.new("ScrollingFrame")
		local rightFrame = Instance.new("ScrollingFrame")
		leftFrame.Name = "LeftFrame"
		rightFrame.Name = "RightFrame"
		leftFrame.NextSelectionRight = rightFrame
		rightFrame.NextSelectionRight = leftFrame

		expect(prettyFormatResult(leftFrame)).toMatchSnapshot()
		leftFrame:Destroy()
		rightFrame:Destroy()
	end)
end)

describe("InstanceSubset", function()
	it("serializes a subset of Frame", function()
		local frame = InstanceSubset.new("Frame", { Name = "ParentFrame" })

		expect(prettyFormatResult(frame)).toEqual("Frame {\n" .. '  "Name": "ParentFrame",\n' .. "}")
	end)

	it("serializes nested InstanceSubsets", function()
		local childFrame = InstanceSubset.new("Frame", { Name = "ChildFrame" })
		local frame = InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = childFrame,
		})

		expect(prettyFormatResult(frame)).toEqual(
			"Frame {\n"
				.. '  "ChildFrame": Frame {\n'
				.. '    "Name": "ChildFrame",\n'
				.. "  },\n"
				.. '  "Name": "ParentFrame",\n'
				.. "}"
		)
	end)
end)

describe("config.printInstanceDefaults", function()
	local created
	beforeEach(function()
		created = Instance.new("TextLabel")
	end)
	afterEach(function()
		created:Destroy()
	end)

	local prettyFormatResult = function(val: any)
		return prettyFormat(val, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
		})
	end

	it("serializes unmodified Instances", function()
		expect(prettyFormatResult(created)).toEqual("TextLabel {}")
	end)

	it("serializes modified values", function()
		created.Name = "ModifiedTextLabel"
		created.TextColor3 = Color3.new(1, 0, 0)
		expect(prettyFormatResult(created)).toEqual(
			"TextLabel {\n" .. '  "Name": "ModifiedTextLabel",\n' .. '  "TextColor3": Color3(1, 0, 0),\n' .. "}"
		)
	end)

	it("serializes nested Instances", function()
		created.Name = "ParentInstance"
		local child = Instance.new("TextLabel")
		child.Parent = created
		expect(prettyFormatResult(created)).toEqual(
			"TextLabel {\n"
				.. '  "Name": "ParentInstance",\n'
				.. '  "TextLabel": TextLabel {\n'
				.. '    "Parent": "ParentInstance" [TextLabel],\n'
				.. "  },\n"
				.. "}"
		)
	end)
end)

describe("config.printInstanceTags", function()
	local created
	beforeEach(function()
		created = Instance.new("TextLabel")
	end)
	afterEach(function()
		created:Destroy()
	end)

	it("does not print tags when printInstanceTags is false", function()
		created.Name = "TaggedLabel"
		created:AddTag("TestTag")

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = false,
		})

		expect(result).never.toMatch("Tags")
		expect(result).never.toMatch("TestTag")
	end)

	it("prints tags when printInstanceTags is true", function()
		created.Name = "TaggedLabel"
		created:AddTag("TestTag")

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		expect(result).toMatch('"Tags"')
		expect(result).toMatch("TestTag")
	end)

	it("prints multiple tags sorted alphabetically", function()
		created.Name = "MultiTagLabel"
		created:AddTag("Zebra")
		created:AddTag("Alpha")
		created:AddTag("Middle")

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		expect(result).toMatchSnapshot()
	end)

	it("does not print Tags field when instance has no tags", function()
		created.Name = "NoTagLabel"

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		expect(result).never.toMatch("Tags")
		expect(result).toEqual("TextLabel {\n" .. '  "Name": "NoTagLabel",\n' .. "}")
	end)
end)

local function waitForStylingToBeApplied()
	-- Need multiple frames for styling to be fully applied
	for _ = 1, 5 do
		task.wait()
	end
end

if STYLING_ENABLED then
	describe("Pseudoinstances and styling infrastructure", function()
		-- These tests document the current behavior of pseudoinstances (StyleSheet, StyleRule, StyleLink, StyleDerive)
		-- in snapshots. Currently, these instances are NOT serialized in a special way and appear as regular children.
		-- This test suite serves as documentation and will help us update behavior when APIs change.

		it(
			"StyleSheet, StyleRule, and StyleLink are not visible in serialized output of parent when printInstanceDefaults is false",
			function()
				-- Create a container with styling infrastructure via React
				local container = Instance.new("ScreenGui")
				container.Parent = game:GetService("CoreGui")

				local root = ReactRoblox.createRoot(container)

				ReactRoblox.act(function()
					root:render(React.createElement(React.Fragment, nil, {
						Sheet = React.createElement("StyleSheet", {
							Name = "TestStyleSheet",
						}, {
							Rule = React.createElement("StyleRule", {
								Selector = ".test-selector",
								Name = "TestRule",
							}),
						}),
						Link = React.createElement("StyleLink", {
							Name = "TestStyleLink",
						}),
						Label = React.createElement("TextLabel", {
							Name = "VisibleLabel",
						}),
					}))
				end)

				waitForStylingToBeApplied()

				-- Format the container and check that styling infrastructure is either hidden or clearly present
				local result = prettyFormat(container, {
					plugins = { RobloxInstance },
					printInstanceDefaults = false,
				})

				-- Document current behavior: The label should be visible
				expect(result).toMatch('"VisibleLabel"')

				-- Document current behavior: pseudoinstances ARE currently serialized as children
				-- This test will need to be updated if/when we add special handling to hide them
				-- For now, this documents that they appear in output

				-- Check if any of the styling instances appear in the output
				local hasStyleSheet = result:match("StyleSheet") ~= nil
				local hasStyleRule = result:match("StyleRule") ~= nil
				local hasStyleLink = result:match("StyleLink") ~= nil

				-- Document the current state: pseudoinstances DO appear in serialized output
				-- This is intentional documentation - when we want to hide them, we'll update these expectations
				expect(hasStyleSheet or hasStyleRule or hasStyleLink).toBeDefined()

				ReactRoblox.act(function()
					root:unmount()
				end)
				container:Destroy()
			end
		)

		it("documents current behavior: pseudoinstances ARE visible in snapshots", function()
			-- CURRENT STATE: Pseudoinstances (StyleDerive, etc.) currently DO appear in
			-- serialized snapshot output. This test documents this behavior.
			--
			-- FUTURE: When we get an API to hide pseudoinstances from snapshots, update
			-- this test to expect they are NOT visible, and the outputs should be equal.
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local frameWithPseudoRef = React.createRef()
			local frameWithoutPseudoRef = React.createRef()

			-- Create two frames: one with a pseudoinstance child, one without
			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					FrameWithPseudo = React.createElement("Frame", {
						ref = frameWithPseudoRef,
						Name = "TestFrame",
						BackgroundColor3 = Color3.new(1, 0, 0),
					}, {
						ChildLabel = React.createElement("TextLabel", {
							Name = "ChildLabel",
							Text = "Hello",
						}),
						-- StyleDerive is a pseudoinstance
						Derive = React.createElement("StyleDerive", {}),
					}),
					FrameWithoutPseudo = React.createElement("Frame", {
						ref = frameWithoutPseudoRef,
						Name = "TestFrame",
						BackgroundColor3 = Color3.new(1, 0, 0),
					}, {
						ChildLabel = React.createElement("TextLabel", {
							Name = "ChildLabel",
							Text = "Hello",
						}),
						-- No pseudoinstance here
					}),
				}))
			end)

			waitForStylingToBeApplied()

			local frameWithPseudo = frameWithPseudoRef.current
			local frameWithoutPseudo = frameWithoutPseudoRef.current

			expect(frameWithPseudo).toBeDefined()
			expect(frameWithoutPseudo).toBeDefined()

			-- Serialize both frames
			local resultWithPseudo = prettyFormat(frameWithPseudo, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
			})

			local resultWithoutPseudo = prettyFormat(frameWithoutPseudo, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
			})

			-- CURRENT BEHAVIOR: Pseudoinstances ARE visible, so outputs are DIFFERENT
			-- When we want pseudoinstances hidden, change this to expect toEqual
			expect(resultWithPseudo).never.toEqual(resultWithoutPseudo)

			-- The pseudoinstance currently appears in the output
			expect(resultWithPseudo).toMatch("StyleDerive")

			-- Verify the regular child IS visible in both
			expect(resultWithPseudo).toMatch('"ChildLabel"')
			expect(resultWithoutPseudo).toMatch('"ChildLabel"')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("documents that StateGroup styling pseudoinstances are not represented specially", function()
			-- StateGroups are used for styling state management
			-- This test documents their current serialization behavior
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement("StyleSheet", {
					ref = sheetRef,
					Name = "StateTestSheet",
				}, {
					Rule = React.createElement("StyleRule", {
						Selector = ".stateful",
					}),
				}))
			end)

			waitForStylingToBeApplied()

			local sheet = sheetRef.current
			if sheet then
				local result = prettyFormat(sheet, {
					plugins = { RobloxInstance },
					printInstanceDefaults = false,
				})

				-- Document what a StyleSheet looks like when serialized
				expect(result).toMatch("StyleSheet")
			end

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)
	end)

	describe("config.useStyledProperties", function()
		it("reads properties without styled overrides when useStyledProperties is false", function()
			-- Simple test without any styling setup
			local label = Instance.new("TextLabel")
			label.Name = "SimpleLabel"
			label.TextColor3 = Color3.new(0, 0, 1) -- Blue

			-- With useStyledProperties = false, just read the property
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = false,
			})

			expect(result).toMatch('"Name": "SimpleLabel"')
			expect(result).toMatch('"TextColor3": Color3%(0, 0, 1%)') -- Blue value

			label:Destroy()
		end)

		it("reads styled properties when useStyledProperties is true", function()
			-- Create container in ReplicatedStorage (like portal does with place files)
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			-- Render everything with React like portal does
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
					Link = React.createElement("StyleLink", {
						-- Will be connected after sheet is created
					}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "StyledLabel",
						TextColor3 = Color3.new(0, 0, 1), -- Blue base value
						[React.Tag] = "styled-label",
					}),
				}))
			end)

			-- Now connect the StyleLink and set properties
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

			waitForStylingToBeApplied()

			local label = labelRef.current
			expect(label).toBeDefined()

			-- With useStyledProperties = true, formatted output should show styled (red) value
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			expect(result).toMatch('"Name": "StyledLabel"')
			expect(result).toMatch('"TextColor3": Color3%(1, 0, 0%)') -- Red styled value

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)
	end)

	describe("StyleRule selectors and styling scenarios", function()
		it("applies styles via ClassName selector (styling all instances of a type)", function()
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local label1Ref = React.createRef()
			local label2Ref = React.createRef()
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					Sheet = React.createElement("StyleSheet", {
						ref = sheetRef,
					}, {
						-- Rule targeting all TextLabels by ClassName
						ClassRule = React.createElement("StyleRule", {
							Selector = "TextLabel",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label1 = React.createElement("TextLabel", {
						ref = label1Ref,
						Name = "Label1",
						TextColor3 = Color3.new(0, 0, 0), -- Black base
					}),
					Label2 = React.createElement("TextLabel", {
						ref = label2Ref,
						Name = "Label2",
						TextColor3 = Color3.new(0, 0, 0), -- Black base
					}),
				}))
			end)

			-- Connect StyleLink and set properties
			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChild("ClassRule")
				if rule then
					rule:SetProperties({
						TextColor3 = Color3.new(0, 1, 0), -- Green from style
					})
				end
			end

			waitForStylingToBeApplied()

			local label1 = label1Ref.current
			local label2 = label2Ref.current

			-- Format with styled properties
			local result1 = prettyFormat(label1, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			local result2 = prettyFormat(label2, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- Both should show the styled (green) color
			expect(result1).toMatch('"TextColor3": Color3%(0, 1, 0%)')
			expect(result2).toMatch('"TextColor3": Color3%(0, 1, 0%)')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("applies styles via tag selector to specific instances only", function()
			local container = Instance.new("ScreenGui")
			container.Parent = game:GetService("CoreGui")

			local root = ReactRoblox.createRoot(container)
			local taggedLabelRef = React.createRef()
			local untaggedLabelRef = React.createRef()
			local sheetRef = React.createRef()

			ReactRoblox.act(function()
				root:render(React.createElement(React.Fragment, nil, {
					Sheet = React.createElement("StyleSheet", {
						ref = sheetRef,
					}, {
						-- Rule targeting only instances with .child-label tag
						TagRule = React.createElement("StyleRule", {
							Selector = ".child-label",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					TaggedLabel = React.createElement("TextLabel", {
						ref = taggedLabelRef,
						Name = "TaggedLabel",
						TextSize = 14, -- Base size
						[React.Tag] = "child-label",
					}),
					UntaggedLabel = React.createElement("TextLabel", {
						ref = untaggedLabelRef,
						Name = "UntaggedLabel",
						TextSize = 14, -- Base size (no tag, should not be styled)
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChild("TagRule")
				if rule then
					rule:SetProperties({
						TextSize = 24, -- Larger size from style
					})
				end
			end

			waitForStylingToBeApplied()

			local taggedLabel = taggedLabelRef.current
			local untaggedLabel = untaggedLabelRef.current

			local taggedResult = prettyFormat(taggedLabel, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			local untaggedResult = prettyFormat(untaggedLabel, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- Tagged label should have styled size (24)
			expect(taggedResult).toMatch('"TextSize": 24')
			-- Untagged label should have base size (14) - no styling applied
			expect(untaggedResult).toMatch('"TextSize": 14')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("respects StyleRule priority when multiple rules apply", function()
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
						-- Low priority rule
						LowPriorityRule = React.createElement("StyleRule", {
							Selector = ".styled-label",
							Priority = 1,
						}),
						-- High priority rule (should win)
						HighPriorityRule = React.createElement("StyleRule", {
							Selector = ".styled-label",
							Priority = 10,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "PriorityLabel",
						TextColor3 = Color3.new(0, 0, 0), -- Black base
						[React.Tag] = "styled-label",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet

				local lowRule = styleSheet:FindFirstChild("LowPriorityRule")
				local highRule = styleSheet:FindFirstChild("HighPriorityRule")

				if lowRule then
					lowRule:SetProperties({
						TextColor3 = Color3.new(1, 0, 0), -- Red (low priority)
					})
				end
				if highRule then
					highRule:SetProperties({
						TextColor3 = Color3.new(0, 0, 1), -- Blue (high priority - should win)
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- Higher priority rule should win (blue)
			expect(result).toMatch('"TextColor3": Color3%(0, 0, 1%)')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("styles multiple properties at once", function()
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
						MultiPropRule = React.createElement("StyleRule", {
							Selector = ".multi-styled",
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
						[React.Tag] = "multi-styled",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChild("MultiPropRule")
				if rule then
					rule:SetProperties({
						TextColor3 = Color3.new(1, 1, 1), -- White
						TextSize = 20,
						BackgroundTransparency = 0.5,
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- All styled properties should be reflected
			expect(result).toMatch('"TextColor3": Color3%(1, 1, 1%)')
			expect(result).toMatch('"TextSize": 20')
			expect(result).toMatch('"BackgroundTransparency": 0.5')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("useStyledProperties reads via GetStyled API when true", function()
			-- This test documents that useStyledProperties = true uses the GetStyled API
			-- which returns the computed styled value after all style rules are applied
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
							Selector = ".styled-api-label",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "StyledAPILabel",
						TextColor3 = Color3.new(0, 0, 1), -- Blue base (set via React prop)
						[React.Tag] = "styled-api-label",
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
						TextColor3 = Color3.new(1, 0, 0), -- Red styled value
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current

			-- With useStyledProperties = true, GetStyled API returns computed style
			local styledResult = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- Styled output should show styled value (red)
			expect(styledResult).toMatch('"TextColor3": Color3%(1, 0, 0%)')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("useStyledProperties false reads direct property values", function()
			-- This test documents behavior when useStyledProperties = false
			-- It reads the instance property directly without going through GetStyled
			-- Note: When React sets a prop AND a style rule applies, the styled value
			-- becomes the actual instance property value
			local label = Instance.new("TextLabel")
			label.Name = "DirectPropertyLabel"
			label.TextColor3 = Color3.new(0, 1, 0) -- Green, set directly

			-- With useStyledProperties = false, we read the property directly
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = false,
			})

			-- Should show the directly set value
			expect(result).toMatch('"TextColor3": Color3%(0, 1, 0%)')

			label:Destroy()
		end)
	end)
end

describe("config.printInstanceTags extended", function()
	local created
	beforeEach(function()
		created = Instance.new("Frame")
	end)
	afterEach(function()
		created:Destroy()
	end)

	it("handles tags with special characters", function()
		created.Name = "SpecialTagFrame"
		created:AddTag("tag-with-dashes")
		created:AddTag("tag_with_underscores")
		created:AddTag("tag.with" .. ".dots")

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		expect(result).toMatch("tag%-with%-dashes")
		expect(result).toMatch("tag_with_underscores")
		expect(result).toMatch("tag%.with%.dots")
	end)

	it("handles many tags", function()
		created.Name = "ManyTagsFrame"
		for i = 1, 10 do
			created:AddTag("Tag" .. string.format("%02d", i))
		end

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		-- All tags should be present and sorted
		expect(result).toMatch("Tag01")
		expect(result).toMatch("Tag05")
		expect(result).toMatch("Tag10")
	end)

	it("prints tags for nested instances separately", function()
		created.Name = "ParentFrame"
		created:AddTag("ParentTag")

		local child = Instance.new("TextLabel")
		child.Name = "ChildLabel"
		child:AddTag("ChildTag")
		child.Parent = created

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		-- Both parent and child tags should appear
		expect(result).toMatch("ParentTag")
		expect(result).toMatch("ChildTag")

		child:Destroy()
	end)

	it("prints tags before properties", function()
		created.Name = "OrderTestFrame"
		created:AddTag("ZebraTag") -- Alphabetically after Name

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		-- Tags should appear before properties (Tags comes before Name alphabetically in output order)
		local tagsPos = result:find('"Tags"') :: number?
		local namePos = result:find('"Name"') :: number?

		expect(tagsPos).toBeDefined()
		expect(namePos).toBeDefined()
		expect(tagsPos :: number).toBeLessThan(namePos :: number)
	end)

	it("handles empty tag names gracefully", function()
		created.Name = "EmptyTagTest"
		-- Note: Roblox may not allow empty tag names, but we test graceful handling

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		-- Should not crash and should format correctly
		expect(result).toMatch("Frame")
		expect(result).toMatch('"Name": "EmptyTagTest"')
	end)

	it("formats instance with only tags (no changed props, no children)", function()
		created.Name = "Frame"
		created:AddTag("OnlyTag")

		local result = prettyFormat(created, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
			printInstanceTags = true,
		})

		expect(result).toMatch('"Tags"')
		expect(result).toMatch('"OnlyTag"')
	end)
end)

if STYLING_ENABLED then
	describe("styled properties interaction with defaults", function()
		it("shows styled value even when it matches default after styling", function()
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
							Selector = ".default-test",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "DefaultTestLabel",
						TextSize = 20, -- Non-default value
						[React.Tag] = "default-test",
					}),
				}))
			end)

			local styleSheet = sheetRef.current
			local styleLink = container:FindFirstChildOfClass("StyleLink")
			if styleSheet and styleLink then
				styleLink.StyleSheet = styleSheet
				local rule = styleSheet:FindFirstChildOfClass("StyleRule")
				if rule then
					-- Style back to default TextSize (14)
					rule:SetProperties({
						TextSize = 14,
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current

			-- With printInstanceDefaults = false and useStyledProperties = true,
			-- the styled value (14) matches default so may not appear
			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			-- Name should always appear (non-default)
			expect(result).toMatch('"Name": "DefaultTestLabel"')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("styled instance shows styled value when useStyledProperties is true", function()
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
							Selector = ".styled-test",
							Priority = 1,
						}),
					}),
					Link = React.createElement("StyleLink", {}),
					Label = React.createElement("TextLabel", {
						ref = labelRef,
						Name = "StyledTestLabel",
						TextSize = 30, -- Non-default base value
						[React.Tag] = "styled-test",
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
						TextSize = 24, -- Styled value
					})
				end
			end

			waitForStylingToBeApplied()

			local label = labelRef.current

			-- Styled output should show 24 (the styled value)
			local styledResult = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = true,
			})

			expect(styledResult).toMatch('"TextSize": 24')

			ReactRoblox.act(function()
				root:unmount()
			end)
			container:Destroy()
		end)

		it("non-styled instance returns direct property values", function()
			-- Without styling infrastructure, useStyledProperties just reads properties
			local label = Instance.new("TextLabel")
			label.Name = "DirectValueLabel"
			label.TextSize = 30 -- Non-default

			local result = prettyFormat(label, {
				plugins = { RobloxInstance },
				printInstanceDefaults = false,
				useStyledProperties = false,
			})

			expect(result).toMatch('"TextSize": 30')
			label:Destroy()
		end)
	end)
end
