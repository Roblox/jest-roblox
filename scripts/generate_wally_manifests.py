#!/usr/bin/env python3
"""
Generate per-package wally.toml manifests from rotriever.toml metadata.

This keeps package source unchanged and only adds Wally publish metadata under src/*.
"""

from __future__ import annotations

import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
WORKSPACE_TOML = ROOT / "rotriever.toml"
SRC_DIR = ROOT / "src"

NAMESPACE = "eyycheev"
REGISTRY = "https://github.com/UpliftGames/wally-index"
PUBLISH_REVISION = 2
PACKAGE_NAME_OVERRIDES = {
    "jest": "stronk-jest",
    "jest-globals": "stronk-jest-globals",
}

# Workspace deps in Roblox/jest-roblox mapped to Wally packages.
WORKSPACE_DEP_MAP = {
    "LuauPolyfill": "jsdotlua/luau-polyfill@1.2.7",
    "RegExp": "jsdotlua/luau-regexp@0.2.1",
    "Promise": "jsdotlua/promise@3.5.2",
    "React": "jsdotlua/react@17.2.1",
    "ReactIs": "jsdotlua/react-is@17.2.1",
    "ReactRoblox": "jsdotlua/react-roblox@17.2.1",
    "ReactTestRenderer": "jsdotlua/react-test-renderer@17.2.1",
    "Picomatch": "jsdotlua/picomatch@0.4.0",
}


def load_toml(path: Path) -> dict:
    return tomllib.loads(path.read_text())


def package_publish_name(package_dir_name: str) -> str:
    return PACKAGE_NAME_OVERRIDES.get(package_dir_name, package_dir_name)


def main() -> None:
    workspace = load_toml(WORKSPACE_TOML)
    workspace_version = str(workspace["workspace"]["version"])
    workspace_license = workspace["workspace"].get("license", "MIT")

    # Separate from upstream semantic version to avoid collision in public index.
    publish_version = f"{workspace_version}-rbx.{PUBLISH_REVISION}"
    workspace_dep_map = dict(WORKSPACE_DEP_MAP)
    workspace_dep_map["ChalkLua"] = f"{NAMESPACE}/chalk-lua@{publish_version}"

    rotriever_files = sorted(SRC_DIR.glob("*/rotriever.toml"))
    generated = 0

    for rt_file in rotriever_files:
        pkg_dir = rt_file.parent
        rotriever = load_toml(rt_file)
        dependencies = rotriever.get("dependencies", {})

        lines = [
            "[package]",
            f'name = "{NAMESPACE}/{package_publish_name(pkg_dir.name)}"',
            f'version = "{publish_version}"',
            f'registry = "{REGISTRY}"',
            'realm = "shared"',
            f'license = "{workspace_license}"',
            "",
        ]

        dep_lines: list[str] = []
        for dep_alias, dep_spec in dependencies.items():
            target: str | None = None

            if isinstance(dep_spec, dict) and "path" in dep_spec:
                dep_dir = (pkg_dir / dep_spec["path"]).resolve().name
                target = f"{NAMESPACE}/{package_publish_name(dep_dir)}@{publish_version}"
            elif isinstance(dep_spec, dict) and dep_spec.get("workspace") is True:
                target = workspace_dep_map.get(dep_alias)
            elif isinstance(dep_spec, str):
                target = dep_spec

            if target is None:
                raise ValueError(
                    f"Unhandled dependency in {rt_file}: {dep_alias} -> {dep_spec!r}"
                )

            dep_lines.append(f'"{dep_alias}" = "{target}"')

        if dep_lines:
            lines += ["[dependencies]"] + dep_lines + [""]

        wally_toml = pkg_dir / "wally.toml"
        wally_toml.write_text("\n".join(lines).rstrip() + "\n")
        generated += 1

    print(f"Generated {generated} wally.toml files with version {publish_version}")


if __name__ == "__main__":
    main()
