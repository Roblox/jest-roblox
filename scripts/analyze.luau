local run = require("./utils/run")

print("Running static analysis...")

local seleneCmd = { "selene", "src" }
local styluaCmd = { "stylua", "-c", "src" }
local analyzeCmd = { "robloxdev-cli", "analyze", "default.project.json", "--fastFlags.allOnLuau" }

run(seleneCmd)
run(styluaCmd)
run(analyzeCmd)
