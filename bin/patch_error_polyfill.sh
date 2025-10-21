#!/bin/bash

# Hack to add a --!optimize 1 to the top of Error.global.lua to capture stacktraces correctly in OCALE
FILE_PATH="Packages/_Index/LuauPolyfill/LuauPolyfill/Error/Error.global.lua"

if ! head -n 1 "$FILE_PATH" | grep -q "^--!optimize"; then
    sed -i '' '1i\
--!optimize 1\
' "$FILE_PATH"
fi
