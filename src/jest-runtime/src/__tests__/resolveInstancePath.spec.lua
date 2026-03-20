local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local afterEach = JestGlobals.afterEach
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local resolveInstancePath = require(CurrentModule.resolveInstancePath)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cleanup: { Instance }

local function track(instance: Instance): Instance
	table.insert(cleanup, instance)
	return instance
end

afterEach(function()
	for _, instance in cleanup do
		instance:Destroy()
	end
	cleanup = {}
end)

cleanup = {}

describe("resolveInstancePath", function()
	describe("@game", function()
		it("resolves a module under a game service", function()
			local module = Instance.new("ModuleScript")
			module.Name = "GameTestModule"
			module.Parent = ReplicatedStorage
			track(module)

			local result = resolveInstancePath(script, "@game/ReplicatedStorage/GameTestModule")
			expect(result).toBe(module)
		end)

		it("resolves a deeply nested path from game root", function()
			local folder = Instance.new("Folder")
			folder.Name = "RipTestFolder"
			folder.Parent = ReplicatedStorage
			track(folder)

			local module = Instance.new("ModuleScript")
			module.Name = "DeepModule"
			module.Parent = folder

			local result = resolveInstancePath(script, "@game/ReplicatedStorage/RipTestFolder/DeepModule")
			expect(result).toBe(module)
		end)
	end)

	describe("@self", function()
		it("resolves a child of the calling script", function()
			local root = Instance.new("ModuleScript")
			root.Parent = game
			track(root)

			local child = Instance.new("ModuleScript")
			child.Name = "Child"
			child.Parent = root

			local result = resolveInstancePath(root, "@self/Child")
			expect(result).toBe(child)
		end)

		it("resolves a nested child under @self", function()
			local root = Instance.new("ModuleScript")
			root.Parent = game
			track(root)

			local folder = Instance.new("Folder")
			folder.Name = "Sub"
			folder.Parent = root

			local deep = Instance.new("ModuleScript")
			deep.Name = "Deep"
			deep.Parent = folder

			local result = resolveInstancePath(root, "@self/Sub/Deep")
			expect(result).toBe(deep)
		end)
	end)

	describe("relative paths", function()
		--[[
			Tree structure (parented to game):

			Root (Folder)
			├── Consumer (ModuleScript)
			├── Module1 (ModuleScript)
			└── Folder
			    ├── Module3 (ModuleScript)
			    └── Folder
			        └── Module2 (ModuleScript)
		]]
		local tree: Folder
		local consumer: ModuleScript
		local module1: ModuleScript
		local module2: ModuleScript
		local module3: ModuleScript

		afterEach(function()
			-- tree is tracked by the top-level cleanup
		end)

		local function buildTree()
			tree = Instance.new("Folder") :: any
			tree.Name = "RipTestTree"
			tree.Parent = game
			track(tree)

			consumer = Instance.new("ModuleScript")
			consumer.Name = "Consumer"
			consumer.Parent = tree

			module1 = Instance.new("ModuleScript")
			module1.Name = "Module1"
			module1.Parent = tree

			local outerFolder = Instance.new("Folder")
			outerFolder.Name = "Folder"
			outerFolder.Parent = tree

			module3 = Instance.new("ModuleScript")
			module3.Name = "Module3"
			module3.Parent = outerFolder

			local innerFolder = Instance.new("Folder")
			innerFolder.Name = "Folder"
			innerFolder.Parent = outerFolder

			module2 = Instance.new("ModuleScript")
			module2.Name = "Module2"
			module2.Parent = innerFolder
		end

		it("resolves a sibling via ./", function()
			buildTree()
			local result = resolveInstancePath(consumer, "./Module1")
			expect(result).toBe(module1)
		end)

		it("resolves a nested child via multi-part path", function()
			buildTree()
			local result = resolveInstancePath(consumer, "./Folder/Folder/Module2")
			expect(result).toBe(module2)
		end)

		it("resolves ascending via ../", function()
			buildTree()
			local result = resolveInstancePath(module2, "../Module3")
			expect(result).toBe(module3)
		end)
	end)

	describe("passthrough paths", function()
		it("returns nil for @std paths", function()
			local result = resolveInstancePath(script, "@std/task")
			expect(result).toBeNil()
		end)

		it("returns nil for @rbx paths", function()
			local result = resolveInstancePath(script, "@rbx/SomeLib")
			expect(result).toBeNil()
		end)

		it("returns nil for @std paths with nested segments", function()
			local result = resolveInstancePath(script, "@std/some/nested/path")
			expect(result).toBeNil()
		end)
	end)

	describe("error cases", function()
		it("throws for nonexistent child names", function()
			expect(function()
				resolveInstancePath(script, "./nonExistentModule")
			end).toThrow("could not resolve")
		end)

		it("throws for absolute paths starting with /", function()
			expect(function()
				resolveInstancePath(script, "/absolute/path")
			end).toThrow("paths beginning with '/' are not supported")
		end)

		it("throws for .. after the beginning of a path", function()
			local folder = Instance.new("Folder")
			folder.Name = "RipErrFolder"
			folder.Parent = script.Parent
			track(folder)

			expect(function()
				resolveInstancePath(script, "./RipErrFolder/../bar")
			end).toThrow("paths including '..' after the beginning are not supported")
		end)
	end)
end)
