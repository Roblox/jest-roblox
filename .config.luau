return {
	luau = {
		languagemode = "strict",

		lint = {
			["*"] = true,

			-- Luau has no first-class type-narrowing syntax. The idiomatic
			-- workaround is to shadow the outer name with a narrower
			-- binding inside a runtime-checked branch, as in
			-- src/jest-mock/src/init.lua:
			--
			--     local object: GlobalEnvLibrary = object :: any
			--
			-- LocalShadow can't distinguish this intentional pattern from
			-- accidental collisions, so we disable it project-wide.
			LocalShadow = false,
		},
	},
}
