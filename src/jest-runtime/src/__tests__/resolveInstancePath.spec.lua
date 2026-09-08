local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local afterEach = JestGlobals.afterEach
local beforeEach = JestGlobals.beforeEach
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

-- ScriptService is not reachable from every test environment, and where it is,
-- ResolveModulePath may be absent or disabled. Probe it with a known-good path
-- so the suite below only runs against a working engine resolver.
local isResolveModulePathEnabled = (function(): boolean
	local ok, service = pcall(game.GetService, game, "ScriptService")
	if not ok then
		return false
	end

	local probeRoot = Instance.new("Folder")
	probeRoot.Name = "RipResolveModulePathProbe"
	probeRoot.Parent = ReplicatedStorage

	local probeScript = Instance.new("ModuleScript")
	probeScript.Name = "Probe"
	probeScript.Parent = probeRoot

	local probeTarget = Instance.new("ModuleScript")
	probeTarget.Name = "ProbeTarget"
	probeTarget.Parent = probeRoot

	local resolvedOk, resolved = pcall(function()
		return (service :: any):ResolveModulePath(probeScript, "./ProbeTarget")
	end)
	probeRoot:Destroy()

	return resolvedOk and resolved == probeTarget
end)()

describe("resolveInstancePath", function()
	describe("ScriptService", function()
		it("uses ResolveModulePath before the fallback resolver", function()
			local module = Instance.new("ModuleScript")
			track(module)

			local receivedRelativeTo
			local receivedPath
			local scriptService = {
				ResolveModulePath = function(_, relativeTo, instancePath)
					receivedRelativeTo = relativeTo
					receivedPath = instancePath
					return module
				end,
			}

			local result = resolveInstancePath(script, "./not-resolvable-by-fallback", scriptService)

			expect(result).toBe(module)
			expect(receivedRelativeTo).toBe(script)
			expect(receivedPath).toBe("./not-resolvable-by-fallback")
		end)

		it("uses the existing resolver when ResolveModulePath fails", function()
			local module = Instance.new("ModuleScript")
			module.Name = "FallbackModule"
			module.Parent = script.Parent
			track(module)

			local scriptService = {
				ResolveModulePath = function()
					error("ResolveModulePath unavailable")
				end,
			}

			local result = resolveInstancePath(script, "./FallbackModule", scriptService)

			expect(result).toBe(module)
		end)

		it("uses the existing resolver when ResolveModulePath is unavailable", function()
			local module = Instance.new("ModuleScript")
			module.Name = "UnavailableFallbackModule"
			module.Parent = script.Parent
			track(module)

			local result = resolveInstancePath(script, "./UnavailableFallbackModule", {})

			expect(result).toBe(module)
		end)
	end)

	if isResolveModulePathEnabled then
		describe("ScriptService end-to-end", function()
			--[[
				Tree structure (parented to ReplicatedStorage):

				RipSsE2eTree (Folder)
				├── Consumer (ModuleScript)
				├── Sibling (ModuleScript)
				├── Folder
				│   ├── NestedSibling (ModuleScript)
				│   └── Folder
				│       └── Nested (ModuleScript)
				└── SelfRoot (ModuleScript)
				    ├── SelfChild (ModuleScript)
				    └── Sub
				        └── Deep (ModuleScript)
			]]
			local consumer: ModuleScript
			local sibling: ModuleScript
			local nestedSibling: ModuleScript
			local nested: ModuleScript
			local selfRoot: ModuleScript
			local selfChild: ModuleScript
			local selfDeep: ModuleScript

			beforeEach(function()
				local tree = Instance.new("Folder")
				tree.Name = "RipSsE2eTree"
				tree.Parent = ReplicatedStorage
				track(tree)

				consumer = Instance.new("ModuleScript")
				consumer.Name = "Consumer"
				consumer.Parent = tree

				sibling = Instance.new("ModuleScript")
				sibling.Name = "Sibling"
				sibling.Parent = tree

				local outerFolder = Instance.new("Folder")
				outerFolder.Name = "Folder"
				outerFolder.Parent = tree

				nestedSibling = Instance.new("ModuleScript")
				nestedSibling.Name = "NestedSibling"
				nestedSibling.Parent = outerFolder

				local innerFolder = Instance.new("Folder")
				innerFolder.Name = "Folder"
				innerFolder.Parent = outerFolder

				nested = Instance.new("ModuleScript")
				nested.Name = "Nested"
				nested.Parent = innerFolder

				selfRoot = Instance.new("ModuleScript")
				selfRoot.Name = "SelfRoot"
				selfRoot.Parent = tree

				selfChild = Instance.new("ModuleScript")
				selfChild.Name = "SelfChild"
				selfChild.Parent = selfRoot

				local selfFolder = Instance.new("Folder")
				selfFolder.Name = "Sub"
				selfFolder.Parent = selfRoot

				selfDeep = Instance.new("ModuleScript")
				selfDeep.Name = "Deep"
				selfDeep.Parent = selfFolder
			end)

			it("resolves a sibling via ./", function()
				expect(resolveInstancePath(consumer, "./Sibling")).toBe(sibling)
			end)

			it("resolves a nested child via multi-part path", function()
				expect(resolveInstancePath(consumer, "./Folder/Folder/Nested")).toBe(nested)
			end)

			it("resolves ascending via ../", function()
				expect(resolveInstancePath(nested, "../NestedSibling")).toBe(nestedSibling)
			end)

			it("resolves a child of the calling script via @self", function()
				expect(resolveInstancePath(selfRoot, "@self/SelfChild")).toBe(selfChild)
			end)

			it("resolves a nested child under @self", function()
				expect(resolveInstancePath(selfRoot, "@self/Sub/Deep")).toBe(selfDeep)
			end)

			it("resolves a module under a game service via @game", function()
				expect(resolveInstancePath(script, "@game/ReplicatedStorage/RipSsE2eTree/Sibling")).toBe(sibling)
			end)

			it("returns nil for passthrough paths", function()
				expect(resolveInstancePath(consumer, "@std/task")).toBeNil()
			end)
		end)
	end

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
