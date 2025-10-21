#!/bin/bash

set -x

bin/patch_error_polyfill.sh

echo "Run static analysis"
selene src
stylua -c src
robloxdev-cli analyze default.project.json --fastFlags.allOnLuau

echo "Run tests"
robloxdev-cli run --load.model default.project.json \
  --run bin/spec.lua --testService.errorExitCode=1 \
  --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true \
  EnableSignalBehavior=true DebugForceDeferredSignalBehavior=true MaxDeferReentrancyDepth=15 \
  --load.asRobloxScript --fs.readwrite="$(pwd)" -- "$@"

echo "Running low privilege tests"
robloxdev-cli run --load.model default.project.json \
  --run bin/spec.lua --testService.errorExitCode=1 \
  --fastFlags.overrides EnableLoadModule=false --load.asRobloxScript -- "$@"
