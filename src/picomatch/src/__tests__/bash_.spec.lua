-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/bash.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	-- $echo a/{1..3}/b
	describe("from the Bash 4.3 spec/unit tests", function()
		itFIXME('should handle "regular globbing"', function()
			assert(not isMatch("*", "a*"))
			assert(not isMatch("**", "a*"))
			assert(not isMatch("\\*", "a*"))
			assert(not isMatch("a/*", "a*"))
			assert(not isMatch("b", "a*"))
			assert(not isMatch("bc", "a*"))
			assert(not isMatch("bcd", "a*"))
			assert(not isMatch("bdir/", "a*"))
			assert(not isMatch("Beware", "a*"))
			assert(isMatch("a", "a*"))
			assert(isMatch("ab", "a*"))
			assert(isMatch("abc", "a*"))
			assert(not isMatch("*", "\\a*"))
			assert(not isMatch("**", "\\a*"))
			assert(not isMatch("\\*", "\\a*"))
			assert(isMatch("a", "\\a*"))
			assert(not isMatch("a/*", "\\a*"))
			assert(isMatch("abc", "\\a*"))
			assert(isMatch("abd", "\\a*"))
			assert(isMatch("abe", "\\a*"))
			assert(not isMatch("b", "\\a*"))
			assert(not isMatch("bb", "\\a*"))
			assert(not isMatch("bcd", "\\a*"))
			assert(not isMatch("bdir/", "\\a*"))
			assert(not isMatch("Beware", "\\a*"))
			assert(not isMatch("c", "\\a*"))
			assert(not isMatch("ca", "\\a*"))
			assert(not isMatch("cb", "\\a*"))
			assert(not isMatch("d", "\\a*"))
			assert(not isMatch("dd", "\\a*"))
			assert(not isMatch("de", "\\a*"))
		end)

		it("should match directories", function()
			assert(not isMatch("*", "b*/"))
			assert(not isMatch("**", "b*/"))
			assert(not isMatch("\\*", "b*/"))
			assert(not isMatch("a", "b*/"))
			assert(not isMatch("a/*", "b*/"))
			assert(not isMatch("abc", "b*/"))
			assert(not isMatch("abd", "b*/"))
			assert(not isMatch("abe", "b*/"))
			assert(not isMatch("b", "b*/"))
			assert(not isMatch("bb", "b*/"))
			assert(not isMatch("bcd", "b*/"))
			assert(isMatch("bdir/", "b*/"))
			assert(not isMatch("Beware", "b*/"))
			assert(not isMatch("c", "b*/"))
			assert(not isMatch("ca", "b*/"))
			assert(not isMatch("cb", "b*/"))
			assert(not isMatch("d", "b*/"))
			assert(not isMatch("dd", "b*/"))
			assert(not isMatch("de", "b*/"))
		end)

		itFIXME("should use escaped characters as literals", function()
			assert(not isMatch("*", "\\^"))
			assert(not isMatch("**", "\\^"))
			assert(not isMatch("\\*", "\\^"))
			assert(not isMatch("a", "\\^"))
			assert(not isMatch("a/*", "\\^"))
			assert(not isMatch("abc", "\\^"))
			assert(not isMatch("abd", "\\^"))
			assert(not isMatch("abe", "\\^"))
			assert(not isMatch("b", "\\^"))
			assert(not isMatch("bb", "\\^"))
			assert(not isMatch("bcd", "\\^"))
			assert(not isMatch("bdir/", "\\^"))
			assert(not isMatch("Beware", "\\^"))
			assert(not isMatch("c", "\\^"))
			assert(not isMatch("ca", "\\^"))
			assert(not isMatch("cb", "\\^"))
			assert(not isMatch("d", "\\^"))
			assert(not isMatch("dd", "\\^"))
			assert(not isMatch("de", "\\^"))
			assert(isMatch("*", "\\*"))
			-- assert(isMatch("\\*", "\\*"))
			assert(not isMatch("**", "\\*"))
			assert(not isMatch("a", "\\*"))
			assert(not isMatch("a/*", "\\*"))
			assert(not isMatch("abc", "\\*"))
			assert(not isMatch("abd", "\\*"))
			assert(not isMatch("abe", "\\*"))
			assert(not isMatch("b", "\\*"))
			assert(not isMatch("bb", "\\*"))
			assert(not isMatch("bcd", "\\*"))
			assert(not isMatch("bdir/", "\\*"))
			assert(not isMatch("Beware", "\\*"))
			assert(not isMatch("c", "\\*"))
			assert(not isMatch("ca", "\\*"))
			assert(not isMatch("cb", "\\*"))
			assert(not isMatch("d", "\\*"))
			assert(not isMatch("dd", "\\*"))
			assert(not isMatch("de", "\\*"))
			assert(not isMatch("*", "a\\*"))
			assert(not isMatch("**", "a\\*"))
			assert(not isMatch("\\*", "a\\*"))
			assert(not isMatch("a", "a\\*"))
			assert(not isMatch("a/*", "a\\*"))
			assert(not isMatch("abc", "a\\*"))
			assert(not isMatch("abd", "a\\*"))
			assert(not isMatch("abe", "a\\*"))
			assert(not isMatch("b", "a\\*"))
			assert(not isMatch("bb", "a\\*"))
			assert(not isMatch("bcd", "a\\*"))
			assert(not isMatch("bdir/", "a\\*"))
			assert(not isMatch("Beware", "a\\*"))
			assert(not isMatch("c", "a\\*"))
			assert(not isMatch("ca", "a\\*"))
			assert(not isMatch("cb", "a\\*"))
			assert(not isMatch("d", "a\\*"))
			assert(not isMatch("dd", "a\\*"))
			assert(not isMatch("de", "a\\*"))
			assert(isMatch("aqa", "*q*"))
			assert(isMatch("aaqaa", "*q*"))
			assert(not isMatch("*", "*q*"))
			assert(not isMatch("**", "*q*"))
			assert(not isMatch("\\*", "*q*"))
			assert(not isMatch("a", "*q*"))
			assert(not isMatch("a/*", "*q*"))
			assert(not isMatch("abc", "*q*"))
			assert(not isMatch("abd", "*q*"))
			assert(not isMatch("abe", "*q*"))
			assert(not isMatch("b", "*q*"))
			assert(not isMatch("bb", "*q*"))
			assert(not isMatch("bcd", "*q*"))
			assert(not isMatch("bdir/", "*q*"))
			assert(not isMatch("Beware", "*q*"))
			assert(not isMatch("c", "*q*"))
			assert(not isMatch("ca", "*q*"))
			assert(not isMatch("cb", "*q*"))
			assert(not isMatch("d", "*q*"))
			assert(not isMatch("dd", "*q*"))
			assert(not isMatch("de", "*q*"))
			assert(isMatch("*", "\\**"))
			assert(isMatch("**", "\\**"))
			assert(not isMatch("\\*", "\\**"))
			assert(not isMatch("a", "\\**"))
			assert(not isMatch("a/*", "\\**"))
			assert(not isMatch("abc", "\\**"))
			assert(not isMatch("abd", "\\**"))
			assert(not isMatch("abe", "\\**"))
			assert(not isMatch("b", "\\**"))
			assert(not isMatch("bb", "\\**"))
			assert(not isMatch("bcd", "\\**"))
			assert(not isMatch("bdir/", "\\**"))
			assert(not isMatch("Beware", "\\**"))
			assert(not isMatch("c", "\\**"))
			assert(not isMatch("ca", "\\**"))
			assert(not isMatch("cb", "\\**"))
			assert(not isMatch("d", "\\**"))
			assert(not isMatch("dd", "\\**"))
			assert(not isMatch("de", "\\**"))
		end)

		itFIXME("should work for quoted characters", function()
			assert(not isMatch("*", '"***"'))
			assert(not isMatch("**", '"***"'))
			assert(not isMatch("\\*", '"***"'))
			assert(not isMatch("a", '"***"'))
			assert(not isMatch("a/*", '"***"'))
			assert(not isMatch("abc", '"***"'))
			assert(not isMatch("abd", '"***"'))
			assert(not isMatch("abe", '"***"'))
			assert(not isMatch("b", '"***"'))
			assert(not isMatch("bb", '"***"'))
			assert(not isMatch("bcd", '"***"'))
			assert(not isMatch("bdir/", '"***"'))
			assert(not isMatch("Beware", '"***"'))
			assert(not isMatch("c", '"***"'))
			assert(not isMatch("ca", '"***"'))
			assert(not isMatch("cb", '"***"'))
			assert(not isMatch("d", '"***"'))
			assert(not isMatch("dd", '"***"'))
			assert(not isMatch("de", '"***"'))
			assert(isMatch("***", '"***"'))
			assert(not isMatch("*", "'***'"))
			assert(not isMatch("**", "'***'"))
			assert(not isMatch("\\*", "'***'"))
			assert(not isMatch("a", "'***'"))
			assert(not isMatch("a/*", "'***'"))
			assert(not isMatch("abc", "'***'"))
			assert(not isMatch("abd", "'***'"))
			assert(not isMatch("abe", "'***'"))
			assert(not isMatch("b", "'***'"))
			assert(not isMatch("bb", "'***'"))
			assert(not isMatch("bcd", "'***'"))
			assert(not isMatch("bdir/", "'***'"))
			assert(not isMatch("Beware", "'***'"))
			assert(not isMatch("c", "'***'"))
			assert(not isMatch("ca", "'***'"))
			assert(not isMatch("cb", "'***'"))
			assert(not isMatch("d", "'***'"))
			assert(not isMatch("dd", "'***'"))
			assert(not isMatch("de", "'***'"))
			assert(isMatch("'***'", "'***'"))
			assert(not isMatch("*", '"***"'))
			assert(not isMatch("**", '"***"'))
			assert(not isMatch("\\*", '"***"'))
			assert(not isMatch("a", '"***"'))
			assert(not isMatch("a/*", '"***"'))
			assert(not isMatch("abc", '"***"'))
			assert(not isMatch("abd", '"***"'))
			assert(not isMatch("abe", '"***"'))
			assert(not isMatch("b", '"***"'))
			assert(not isMatch("bb", '"***"'))
			assert(not isMatch("bcd", '"***"'))
			assert(not isMatch("bdir/", '"***"'))
			assert(not isMatch("Beware", '"***"'))
			assert(not isMatch("c", '"***"'))
			assert(not isMatch("ca", '"***"'))
			assert(not isMatch("cb", '"***"'))
			assert(not isMatch("d", '"***"'))
			assert(not isMatch("dd", '"***"'))
			assert(not isMatch("de", '"***"'))
			assert(isMatch("*", '"*"*'))
			assert(isMatch("**", '"*"*'))
			assert(not isMatch("\\*", '"*"*'))
			assert(not isMatch("a", '"*"*'))
			assert(not isMatch("a/*", '"*"*'))
			assert(not isMatch("abc", '"*"*'))
			assert(not isMatch("abd", '"*"*'))
			assert(not isMatch("abe", '"*"*'))
			assert(not isMatch("b", '"*"*'))
			assert(not isMatch("bb", '"*"*'))
			assert(not isMatch("bcd", '"*"*'))
			assert(not isMatch("bdir/", '"*"*'))
			assert(not isMatch("Beware", '"*"*'))
			assert(not isMatch("c", '"*"*'))
			assert(not isMatch("ca", '"*"*'))
			assert(not isMatch("cb", '"*"*'))
			assert(not isMatch("d", '"*"*'))
			assert(not isMatch("dd", '"*"*'))
			assert(not isMatch("de", '"*"*'))
		end)

		itFIXME("should match escaped quotes", function()
			assert(not isMatch("*", '\\"**\\"'))
			assert(not isMatch("**", '\\"**\\"'))
			assert(not isMatch("\\*", '\\"**\\"'))
			assert(not isMatch("a", '\\"**\\"'))
			assert(not isMatch("a/*", '\\"**\\"'))
			assert(not isMatch("abc", '\\"**\\"'))
			assert(not isMatch("abd", '\\"**\\"'))
			assert(not isMatch("abe", '\\"**\\"'))
			assert(not isMatch("b", '\\"**\\"'))
			assert(not isMatch("bb", '\\"**\\"'))
			assert(not isMatch("bcd", '\\"**\\"'))
			assert(not isMatch("bdir/", '\\"**\\"'))
			assert(not isMatch("Beware", '\\"**\\"'))
			assert(not isMatch("c", '\\"**\\"'))
			assert(not isMatch("ca", '\\"**\\"'))
			assert(not isMatch("cb", '\\"**\\"'))
			assert(not isMatch("d", '\\"**\\"'))
			assert(not isMatch("dd", '\\"**\\"'))
			assert(not isMatch("de", '\\"**\\"'))
			assert(isMatch('"**"', '\\"**\\"'))
			assert(not isMatch("*", 'foo/\\"**\\"/bar'))
			assert(not isMatch("**", 'foo/\\"**\\"/bar'))
			assert(not isMatch("\\*", 'foo/\\"**\\"/bar'))
			assert(not isMatch("a", 'foo/\\"**\\"/bar'))
			assert(not isMatch("a/*", 'foo/\\"**\\"/bar'))
			assert(not isMatch("abc", 'foo/\\"**\\"/bar'))
			assert(not isMatch("abd", 'foo/\\"**\\"/bar'))
			assert(not isMatch("abe", 'foo/\\"**\\"/bar'))
			assert(not isMatch("b", 'foo/\\"**\\"/bar'))
			assert(not isMatch("bb", 'foo/\\"**\\"/bar'))
			assert(not isMatch("bcd", 'foo/\\"**\\"/bar'))
			assert(not isMatch("bdir/", 'foo/\\"**\\"/bar'))
			assert(not isMatch("Beware", 'foo/\\"**\\"/bar'))
			assert(not isMatch("c", 'foo/\\"**\\"/bar'))
			assert(not isMatch("ca", 'foo/\\"**\\"/bar'))
			assert(not isMatch("cb", 'foo/\\"**\\"/bar'))
			assert(not isMatch("d", 'foo/\\"**\\"/bar'))
			assert(not isMatch("dd", 'foo/\\"**\\"/bar'))
			assert(not isMatch("de", 'foo/\\"**\\"/bar'))
			assert(isMatch('foo/"**"/bar', 'foo/\\"**\\"/bar'))
			assert(not isMatch("*", 'foo/\\"*\\"/bar'))
			assert(not isMatch("**", 'foo/\\"*\\"/bar'))
			assert(not isMatch("\\*", 'foo/\\"*\\"/bar'))
			assert(not isMatch("a", 'foo/\\"*\\"/bar'))
			assert(not isMatch("a/*", 'foo/\\"*\\"/bar'))
			assert(not isMatch("abc", 'foo/\\"*\\"/bar'))
			assert(not isMatch("abd", 'foo/\\"*\\"/bar'))
			assert(not isMatch("abe", 'foo/\\"*\\"/bar'))
			assert(not isMatch("b", 'foo/\\"*\\"/bar'))
			assert(not isMatch("bb", 'foo/\\"*\\"/bar'))
			assert(not isMatch("bcd", 'foo/\\"*\\"/bar'))
			assert(not isMatch("bdir/", 'foo/\\"*\\"/bar'))
			assert(not isMatch("Beware", 'foo/\\"*\\"/bar'))
			assert(not isMatch("c", 'foo/\\"*\\"/bar'))
			assert(not isMatch("ca", 'foo/\\"*\\"/bar'))
			assert(not isMatch("cb", 'foo/\\"*\\"/bar'))
			assert(not isMatch("d", 'foo/\\"*\\"/bar'))
			assert(not isMatch("dd", 'foo/\\"*\\"/bar'))
			assert(not isMatch("de", 'foo/\\"*\\"/bar'))
			assert(isMatch('foo/"*"/bar', 'foo/\\"*\\"/bar'))
			assert(isMatch('foo/"a"/bar', 'foo/\\"*\\"/bar'))
			assert(isMatch('foo/"b"/bar', 'foo/\\"*\\"/bar'))
			assert(isMatch('foo/"c"/bar', 'foo/\\"*\\"/bar'))
			assert(not isMatch("foo/'*'/bar", 'foo/\\"*\\"/bar'))
			assert(not isMatch("foo/'a'/bar", 'foo/\\"*\\"/bar'))
			assert(not isMatch("foo/'b'/bar", 'foo/\\"*\\"/bar'))
			assert(not isMatch("foo/'c'/bar", 'foo/\\"*\\"/bar'))
			assert(not isMatch("*", 'foo/"*"/bar'))
			assert(not isMatch("**", 'foo/"*"/bar'))
			assert(not isMatch("\\*", 'foo/"*"/bar'))
			assert(not isMatch("a", 'foo/"*"/bar'))
			assert(not isMatch("a/*", 'foo/"*"/bar'))
			assert(not isMatch("abc", 'foo/"*"/bar'))
			assert(not isMatch("abd", 'foo/"*"/bar'))
			assert(not isMatch("abe", 'foo/"*"/bar'))
			assert(not isMatch("b", 'foo/"*"/bar'))
			assert(not isMatch("bb", 'foo/"*"/bar'))
			assert(not isMatch("bcd", 'foo/"*"/bar'))
			assert(not isMatch("bdir/", 'foo/"*"/bar'))
			assert(not isMatch("Beware", 'foo/"*"/bar'))
			assert(not isMatch("c", 'foo/"*"/bar'))
			assert(not isMatch("ca", 'foo/"*"/bar'))
			assert(not isMatch("cb", 'foo/"*"/bar'))
			assert(not isMatch("d", 'foo/"*"/bar'))
			assert(not isMatch("dd", 'foo/"*"/bar'))
			assert(not isMatch("de", 'foo/"*"/bar'))
			assert(isMatch("foo/*/bar", 'foo/"*"/bar'))
			assert(isMatch('foo/"*"/bar', 'foo/"*"/bar'))
			assert(not isMatch('foo/"a"/bar', 'foo/"*"/bar'))
			assert(not isMatch('foo/"b"/bar', 'foo/"*"/bar'))
			assert(not isMatch('foo/"c"/bar', 'foo/"*"/bar'))
			assert(not isMatch("foo/'*'/bar", 'foo/"*"/bar'))
			assert(not isMatch("foo/'a'/bar", 'foo/"*"/bar'))
			assert(not isMatch("foo/'b'/bar", 'foo/"*"/bar'))
			assert(not isMatch("foo/'c'/bar", 'foo/"*"/bar'))
			assert(not isMatch("*", "\\'**\\'"))
			assert(not isMatch("**", "\\'**\\'"))
			assert(not isMatch("\\*", "\\'**\\'"))
			assert(not isMatch("a", "\\'**\\'"))
			assert(not isMatch("a/*", "\\'**\\'"))
			assert(not isMatch("abc", "\\'**\\'"))
			assert(not isMatch("abd", "\\'**\\'"))
			assert(not isMatch("abe", "\\'**\\'"))
			assert(not isMatch("b", "\\'**\\'"))
			assert(not isMatch("bb", "\\'**\\'"))
			assert(not isMatch("bcd", "\\'**\\'"))
			assert(not isMatch("bdir/", "\\'**\\'"))
			assert(not isMatch("Beware", "\\'**\\'"))
			assert(not isMatch("c", "\\'**\\'"))
			assert(not isMatch("ca", "\\'**\\'"))
			assert(not isMatch("cb", "\\'**\\'"))
			assert(not isMatch("d", "\\'**\\'"))
			assert(not isMatch("dd", "\\'**\\'"))
			assert(not isMatch("de", "\\'**\\'"))
			assert(isMatch("'**'", "\\'**\\'"))
		end)

		itFIXME("Pattern from Larry Wall's Configure that caused bash to blow up:", function()
			assert(not isMatch("*", "[a-c]b*"))
			assert(not isMatch("**", "[a-c]b*"))
			assert(not isMatch("\\*", "[a-c]b*"))
			assert(not isMatch("a", "[a-c]b*"))
			assert(not isMatch("a/*", "[a-c]b*"))
			assert(isMatch("abc", "[a-c]b*"))
			assert(isMatch("abd", "[a-c]b*"))
			assert(isMatch("abe", "[a-c]b*"))
			assert(not isMatch("b", "[a-c]b*"))
			assert(isMatch("bb", "[a-c]b*"))
			assert(not isMatch("bcd", "[a-c]b*"))
			assert(not isMatch("bdir/", "[a-c]b*"))
			assert(not isMatch("Beware", "[a-c]b*"))
			assert(not isMatch("c", "[a-c]b*"))
			assert(not isMatch("ca", "[a-c]b*"))
			assert(isMatch("cb", "[a-c]b*"))
			assert(not isMatch("d", "[a-c]b*"))
			assert(not isMatch("dd", "[a-c]b*"))
			assert(not isMatch("de", "[a-c]b*"))
		end)

		itFIXME("should support character classes", function()
			assert(not isMatch("*", "a*[^c]"))
			assert(not isMatch("**", "a*[^c]"))
			assert(not isMatch("\\*", "a*[^c]"))
			assert(not isMatch("a", "a*[^c]"))
			assert(not isMatch("a/*", "a*[^c]"))
			assert(not isMatch("abc", "a*[^c]"))
			assert(isMatch("abd", "a*[^c]"))
			assert(isMatch("abe", "a*[^c]"))
			assert(not isMatch("b", "a*[^c]"))
			assert(not isMatch("bb", "a*[^c]"))
			assert(not isMatch("bcd", "a*[^c]"))
			assert(not isMatch("bdir/", "a*[^c]"))
			assert(not isMatch("Beware", "a*[^c]"))
			assert(not isMatch("c", "a*[^c]"))
			assert(not isMatch("ca", "a*[^c]"))
			assert(not isMatch("cb", "a*[^c]"))
			assert(not isMatch("d", "a*[^c]"))
			assert(not isMatch("dd", "a*[^c]"))
			assert(not isMatch("de", "a*[^c]"))
			assert(not isMatch("baz", "a*[^c]"))
			assert(not isMatch("bzz", "a*[^c]"))
			assert(not isMatch("BZZ", "a*[^c]"))
			assert(not isMatch("beware", "a*[^c]"))
			assert(not isMatch("BewAre", "a*[^c]"))
			assert(isMatch("a-b", "a[X-]b"))
			assert(isMatch("aXb", "a[X-]b"))
			assert(not isMatch("*", "[a-y]*[^c]"))
			assert(isMatch("a*", "[a-y]*[^c]", { bash = true }))
			assert(not isMatch("**", "[a-y]*[^c]"))
			assert(not isMatch("\\*", "[a-y]*[^c]"))
			assert(not isMatch("a", "[a-y]*[^c]"))
			assert(isMatch("a123b", "[a-y]*[^c]", { bash = true }))
			assert(not isMatch("a123c", "[a-y]*[^c]", { bash = true }))
			assert(isMatch("ab", "[a-y]*[^c]", { bash = true }))
			assert(not isMatch("a/*", "[a-y]*[^c]"))
			assert(not isMatch("abc", "[a-y]*[^c]"))
			assert(isMatch("abd", "[a-y]*[^c]"))
			assert(isMatch("abe", "[a-y]*[^c]"))
			assert(not isMatch("b", "[a-y]*[^c]"))
			assert(isMatch("bd", "[a-y]*[^c]", { bash = true }))
			assert(isMatch("bb", "[a-y]*[^c]"))
			assert(isMatch("bcd", "[a-y]*[^c]"))
			assert(isMatch("bdir/", "[a-y]*[^c]"))
			assert(not isMatch("Beware", "[a-y]*[^c]"))
			assert(not isMatch("c", "[a-y]*[^c]"))
			assert(isMatch("ca", "[a-y]*[^c]"))
			assert(isMatch("cb", "[a-y]*[^c]"))
			assert(not isMatch("d", "[a-y]*[^c]"))
			assert(isMatch("dd", "[a-y]*[^c]"))
			assert(isMatch("dd", "[a-y]*[^c]", { regex = true }))
			assert(isMatch("dd", "[a-y]*[^c]"))
			assert(isMatch("de", "[a-y]*[^c]"))
			assert(isMatch("baz", "[a-y]*[^c]"))
			assert(isMatch("bzz", "[a-y]*[^c]"))
			assert(isMatch("bzz", "[a-y]*[^c]"))
			assert(not isMatch("bzz", "[a-y]*[^c]", { regex = true }))
			assert(not isMatch("BZZ", "[a-y]*[^c]"))
			assert(isMatch("beware", "[a-y]*[^c]"))
			assert(not isMatch("BewAre", "[a-y]*[^c]"))
			assert(isMatch("a*b/ooo", "a\\*b/*"))
			assert(isMatch("a*b/ooo", "a\\*?/*"))
			assert(not isMatch("*", "a[b]c"))
			assert(not isMatch("**", "a[b]c"))
			assert(not isMatch("\\*", "a[b]c"))
			assert(not isMatch("a", "a[b]c"))
			assert(not isMatch("a/*", "a[b]c"))
			assert(isMatch("abc", "a[b]c"))
			assert(not isMatch("abd", "a[b]c"))
			assert(not isMatch("abe", "a[b]c"))
			assert(not isMatch("b", "a[b]c"))
			assert(not isMatch("bb", "a[b]c"))
			assert(not isMatch("bcd", "a[b]c"))
			assert(not isMatch("bdir/", "a[b]c"))
			assert(not isMatch("Beware", "a[b]c"))
			assert(not isMatch("c", "a[b]c"))
			assert(not isMatch("ca", "a[b]c"))
			assert(not isMatch("cb", "a[b]c"))
			assert(not isMatch("d", "a[b]c"))
			assert(not isMatch("dd", "a[b]c"))
			assert(not isMatch("de", "a[b]c"))
			assert(not isMatch("baz", "a[b]c"))
			assert(not isMatch("bzz", "a[b]c"))
			assert(not isMatch("BZZ", "a[b]c"))
			assert(not isMatch("beware", "a[b]c"))
			assert(not isMatch("BewAre", "a[b]c"))
			assert(not isMatch("*", 'a["b"]c'))
			assert(not isMatch("**", 'a["b"]c'))
			assert(not isMatch("\\*", 'a["b"]c'))
			assert(not isMatch("a", 'a["b"]c'))
			assert(not isMatch("a/*", 'a["b"]c'))
			assert(isMatch("abc", 'a["b"]c'))
			assert(not isMatch("abd", 'a["b"]c'))
			assert(not isMatch("abe", 'a["b"]c'))
			assert(not isMatch("b", 'a["b"]c'))
			assert(not isMatch("bb", 'a["b"]c'))
			assert(not isMatch("bcd", 'a["b"]c'))
			assert(not isMatch("bdir/", 'a["b"]c'))
			assert(not isMatch("Beware", 'a["b"]c'))
			assert(not isMatch("c", 'a["b"]c'))
			assert(not isMatch("ca", 'a["b"]c'))
			assert(not isMatch("cb", 'a["b"]c'))
			assert(not isMatch("d", 'a["b"]c'))
			assert(not isMatch("dd", 'a["b"]c'))
			assert(not isMatch("de", 'a["b"]c'))
			assert(not isMatch("baz", 'a["b"]c'))
			assert(not isMatch("bzz", 'a["b"]c'))
			assert(not isMatch("BZZ", 'a["b"]c'))
			assert(not isMatch("beware", 'a["b"]c'))
			assert(not isMatch("BewAre", 'a["b"]c'))
			assert(not isMatch("*", "a[\\\\b]c"))
			assert(not isMatch("**", "a[\\\\b]c"))
			assert(not isMatch("\\*", "a[\\\\b]c"))
			assert(not isMatch("a", "a[\\\\b]c"))
			assert(not isMatch("a/*", "a[\\\\b]c"))
			assert(isMatch("abc", "a[\\\\b]c"))
			assert(not isMatch("abd", "a[\\\\b]c"))
			assert(not isMatch("abe", "a[\\\\b]c"))
			assert(not isMatch("b", "a[\\\\b]c"))
			assert(not isMatch("bb", "a[\\\\b]c"))
			assert(not isMatch("bcd", "a[\\\\b]c"))
			assert(not isMatch("bdir/", "a[\\\\b]c"))
			assert(not isMatch("Beware", "a[\\\\b]c"))
			assert(not isMatch("c", "a[\\\\b]c"))
			assert(not isMatch("ca", "a[\\\\b]c"))
			assert(not isMatch("cb", "a[\\\\b]c"))
			assert(not isMatch("d", "a[\\\\b]c"))
			assert(not isMatch("dd", "a[\\\\b]c"))
			assert(not isMatch("de", "a[\\\\b]c"))
			assert(not isMatch("baz", "a[\\\\b]c"))
			assert(not isMatch("bzz", "a[\\\\b]c"))
			assert(not isMatch("BZZ", "a[\\\\b]c"))
			assert(not isMatch("beware", "a[\\\\b]c"))
			assert(not isMatch("BewAre", "a[\\\\b]c"))
			assert(not isMatch("*", "a[\\b]c"))
			assert(not isMatch("**", "a[\\b]c"))
			assert(not isMatch("\\*", "a[\\b]c"))
			assert(not isMatch("a", "a[\\b]c"))
			assert(not isMatch("a/*", "a[\\b]c"))
			assert(not isMatch("abc", "a[\\b]c"))
			assert(not isMatch("abd", "a[\\b]c"))
			assert(not isMatch("abe", "a[\\b]c"))
			assert(not isMatch("b", "a[\\b]c"))
			assert(not isMatch("bb", "a[\\b]c"))
			assert(not isMatch("bcd", "a[\\b]c"))
			assert(not isMatch("bdir/", "a[\\b]c"))
			assert(not isMatch("Beware", "a[\\b]c"))
			assert(not isMatch("c", "a[\\b]c"))
			assert(not isMatch("ca", "a[\\b]c"))
			assert(not isMatch("cb", "a[\\b]c"))
			assert(not isMatch("d", "a[\\b]c"))
			assert(not isMatch("dd", "a[\\b]c"))
			assert(not isMatch("de", "a[\\b]c"))
			assert(not isMatch("baz", "a[\\b]c"))
			assert(not isMatch("bzz", "a[\\b]c"))
			assert(not isMatch("BZZ", "a[\\b]c"))
			assert(not isMatch("beware", "a[\\b]c"))
			assert(not isMatch("BewAre", "a[\\b]c"))
			assert(not isMatch("*", "a[b-d]c"))
			assert(not isMatch("**", "a[b-d]c"))
			assert(not isMatch("\\*", "a[b-d]c"))
			assert(not isMatch("a", "a[b-d]c"))
			assert(not isMatch("a/*", "a[b-d]c"))
			assert(isMatch("abc", "a[b-d]c"))
			assert(not isMatch("abd", "a[b-d]c"))
			assert(not isMatch("abe", "a[b-d]c"))
			assert(not isMatch("b", "a[b-d]c"))
			assert(not isMatch("bb", "a[b-d]c"))
			assert(not isMatch("bcd", "a[b-d]c"))
			assert(not isMatch("bdir/", "a[b-d]c"))
			assert(not isMatch("Beware", "a[b-d]c"))
			assert(not isMatch("c", "a[b-d]c"))
			assert(not isMatch("ca", "a[b-d]c"))
			assert(not isMatch("cb", "a[b-d]c"))
			assert(not isMatch("d", "a[b-d]c"))
			assert(not isMatch("dd", "a[b-d]c"))
			assert(not isMatch("de", "a[b-d]c"))
			assert(not isMatch("baz", "a[b-d]c"))
			assert(not isMatch("bzz", "a[b-d]c"))
			assert(not isMatch("BZZ", "a[b-d]c"))
			assert(not isMatch("beware", "a[b-d]c"))
			assert(not isMatch("BewAre", "a[b-d]c"))
			assert(not isMatch("*", "a?c"))
			assert(not isMatch("**", "a?c"))
			assert(not isMatch("\\*", "a?c"))
			assert(not isMatch("a", "a?c"))
			assert(not isMatch("a/*", "a?c"))
			assert(isMatch("abc", "a?c"))
			assert(not isMatch("abd", "a?c"))
			assert(not isMatch("abe", "a?c"))
			assert(not isMatch("b", "a?c"))
			assert(not isMatch("bb", "a?c"))
			assert(not isMatch("bcd", "a?c"))
			assert(not isMatch("bdir/", "a?c"))
			assert(not isMatch("Beware", "a?c"))
			assert(not isMatch("c", "a?c"))
			assert(not isMatch("ca", "a?c"))
			assert(not isMatch("cb", "a?c"))
			assert(not isMatch("d", "a?c"))
			assert(not isMatch("dd", "a?c"))
			assert(not isMatch("de", "a?c"))
			assert(not isMatch("baz", "a?c"))
			assert(not isMatch("bzz", "a?c"))
			assert(not isMatch("BZZ", "a?c"))
			assert(not isMatch("beware", "a?c"))
			assert(not isMatch("BewAre", "a?c"))
			assert(isMatch("man/man1/bash.1", "*/man*/bash.*"))
			assert(isMatch("*", "[^a-c]*"))
			assert(isMatch("**", "[^a-c]*"))
			assert(not isMatch("a", "[^a-c]*"))
			assert(not isMatch("a/*", "[^a-c]*"))
			assert(not isMatch("abc", "[^a-c]*"))
			assert(not isMatch("abd", "[^a-c]*"))
			assert(not isMatch("abe", "[^a-c]*"))
			assert(not isMatch("b", "[^a-c]*"))
			assert(not isMatch("bb", "[^a-c]*"))
			assert(not isMatch("bcd", "[^a-c]*"))
			assert(not isMatch("bdir/", "[^a-c]*"))
			assert(isMatch("Beware", "[^a-c]*"))
			assert(isMatch("Beware", "[^a-c]*", { bash = true }))
			assert(not isMatch("c", "[^a-c]*"))
			assert(not isMatch("ca", "[^a-c]*"))
			assert(not isMatch("cb", "[^a-c]*"))
			assert(isMatch("d", "[^a-c]*"))
			assert(isMatch("dd", "[^a-c]*"))
			assert(isMatch("de", "[^a-c]*"))
			assert(not isMatch("baz", "[^a-c]*"))
			assert(not isMatch("bzz", "[^a-c]*"))
			assert(isMatch("BZZ", "[^a-c]*"))
			assert(not isMatch("beware", "[^a-c]*"))
			assert(isMatch("BewAre", "[^a-c]*"))
		end)

		itFIXME("should support basic wildmatch (brackets) features", function()
			assert(not isMatch("aab", "a[]-]b"))
			assert(not isMatch("ten", "[ten]"))
			assert(isMatch("]", "]"))
			assert(isMatch("a-b", "a[]-]b"))
			assert(isMatch("a]b", "a[]-]b"))
			assert(isMatch("a]b", "a[]]b"))
			assert(isMatch("aab", "a[\\]a\\-]b"))
			assert(isMatch("ten", "t[a-g]n"))
			assert(isMatch("ton", "t[^a-g]n"))
		end)

		itFIXME("should support extended slash-matching features", function()
			assert(not isMatch("foo/bar", "f[^eiu][^eiu][^eiu][^eiu][^eiu]r"))
			assert(isMatch("foo/bar", "foo[/]bar"))
			assert(isMatch("foo-bar", "f[^eiu][^eiu][^eiu][^eiu][^eiu]r"))
		end)

		itFIXME("should match escaped characters", function()
			-- ROBLOX FIXME: need a test for platform
			local isWindows = false
			if isWindows then
				assert(isMatch("\\*", "\\*"))
				assert(isMatch("XXX/\\", "[A-Z]+/\\\\"))
			end
			assert(isMatch("[ab]", "\\[ab]"))
			assert(isMatch("[ab]", "[\\[:]ab]"))
		end)

		it("should consolidate extra stars", function()
			assert(not isMatch("bbc", "a**c"))
			assert(isMatch("abc", "a**c"))
			assert(not isMatch("bbd", "a**c"))
			assert(not isMatch("bbc", "a***c"))
			assert(isMatch("abc", "a***c"))
			assert(not isMatch("bbd", "a***c"))
			assert(not isMatch("bbc", "a*****?c"))
			assert(isMatch("abc", "a*****?c"))
			assert(not isMatch("bbc", "a*****?c"))
			assert(isMatch("bbc", "?*****??"))
			assert(isMatch("abc", "?*****??"))
			assert(isMatch("bbc", "*****??"))
			assert(isMatch("abc", "*****??"))
			assert(isMatch("bbc", "?*****?c"))
			assert(isMatch("abc", "?*****?c"))
			assert(isMatch("bbc", "?***?****c"))
			assert(isMatch("abc", "?***?****c"))
			assert(not isMatch("bbd", "?***?****c"))
			assert(isMatch("bbc", "?***?****?"))
			assert(isMatch("abc", "?***?****?"))
			assert(isMatch("bbc", "?***?****"))
			assert(isMatch("abc", "?***?****"))
			assert(isMatch("bbc", "*******c"))
			assert(isMatch("abc", "*******c"))
			assert(isMatch("bbc", "*******?"))
			assert(isMatch("abc", "*******?"))
			assert(isMatch("abcdecdhjk", "a*cd**?**??k"))
			assert(isMatch("abcdecdhjk", "a**?**cd**?**??k"))
			assert(isMatch("abcdecdhjk", "a**?**cd**?**??k***"))
			assert(isMatch("abcdecdhjk", "a**?**cd**?**??***k"))
			assert(isMatch("abcdecdhjk", "a**?**cd**?**??***k**"))
			assert(isMatch("abcdecdhjk", "a****c**?**??*****"))
		end)

		it("none of these should output anything", function()
			assert(not isMatch("abc", "??**********?****?"))
			assert(not isMatch("abc", "??**********?****c"))
			assert(not isMatch("abc", "?************c****?****"))
			assert(not isMatch("abc", "*c*?**"))
			assert(not isMatch("abc", "a*****c*?**"))
			assert(not isMatch("abc", "a********???*******"))
			assert(not isMatch("a", "[]"))
			assert(not isMatch("[", "[abc"))
		end)
	end)
end