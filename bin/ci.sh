#!/bin/bash

set -x

echo "Run static analysis"
selene src
stylua -c src
robloxdev-cli analyze default.project.json --fastFlags.allOnLuau

echo "Run tests"
robloxdev-cli run --load.model default.project.json \
  --run bin/spec.lua --testService.errorExitCode=1 \
  --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true \
  EnableSignalBehavior=true DebugForceDeferredSignalBehavior=true MaxDeferReentrancyDepth=15 \
  --lua.globals=UPDATESNAPSHOT=false --lua.globals=CI=false --load.asRobloxScript --fs.readwrite="$(pwd)" \
  --lua.globals=TESTPATHPATTERN=$1

echo "Running low privilege tests"
robloxdev-cli run --load.model default.project.json \
  --run bin/spec.lua --testService.errorExitCode=1 \
  --fastFlags.overrides EnableLoadModule=false --load.asRobloxScript \
  --lua.globals=TESTPATHPATTERN=$1

# Uncomment this to update snapshots
# robloxdev-cli run --load.model default.project.json \
#   --run bin/spec.lua --testService.errorExitCode=1 \
#   --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true \
#   --lua.globals=UPDATESNAPSHOT=true --lua.globals=CI=true --load.asRobloxScript --fs.readwrite="$(pwd)"
