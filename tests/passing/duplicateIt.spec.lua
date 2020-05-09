-- luacheck: globals describe it

return function()
	describe("multiple it blocks with the same description", function()
		it("only the last runs", function()
			error("first")
		end)
		it("only the last runs", function()
			error("second")
		end)
		it("only the last runs", function()
			error("third")
		end)
		it("only the last runs", function()
			-- This is the only one that will run
		end)
	end)
end