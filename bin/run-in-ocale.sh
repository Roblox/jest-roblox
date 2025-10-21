bin/patch_error_polyfill.sh
rojo build ocale.project.json --output tests.rbxl
python3 bin/upload_and_run_task.py tests.rbxl bin/spec.lua
