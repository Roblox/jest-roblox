#!/usr/bin/env python3
"""
Publish src/* Wally packages in dependency order.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import tomllib
from collections import defaultdict, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
INTERNAL_SCOPE = "eyycheev/"


def load_manifest(path: Path) -> dict:
    return tomllib.loads(path.read_text())


def find_packages() -> dict[str, Path]:
    out: dict[str, Path] = {}
    for w in sorted(SRC.glob("*/wally.toml")):
        name = load_manifest(w)["package"]["name"]
        out[name] = w.parent
    return out


def topo_order(packages: dict[str, Path]) -> list[str]:
    deps: dict[str, set[str]] = {}
    reverse: dict[str, set[str]] = defaultdict(set)
    indegree: dict[str, int] = {}

    for name, pkg_dir in packages.items():
        manifest = load_manifest(pkg_dir / "wally.toml")
        internal = set()
        for dep in manifest.get("dependencies", {}).values():
            if isinstance(dep, str) and dep.startswith(INTERNAL_SCOPE):
                dep_name = dep.split("@", 1)[0]
                if dep_name in packages:
                    internal.add(dep_name)
        deps[name] = internal
        indegree[name] = len(internal)
        for d in internal:
            reverse[d].add(name)

    q = deque(sorted([name for name, deg in indegree.items() if deg == 0]))
    order: list[str] = []
    while q:
        name = q.popleft()
        order.append(name)
        for nxt in sorted(reverse[name]):
            indegree[nxt] -= 1
            if indegree[nxt] == 0:
                q.append(nxt)

    if len(order) != len(packages):
        unresolved = sorted(set(packages) - set(order))
        raise RuntimeError(f"Dependency cycle or unresolved graph: {unresolved}")
    return order


def run_publish(order: list[str], packages: dict[str, Path], only: set[str] | None) -> int:
    failures: list[str] = []
    for name in order:
        if only and name not in only:
            continue
        pkg_dir = packages[name]
        print(f"\n== Publishing {name} ({pkg_dir}) ==")
        cmd = ["wally", "publish", "--project-path", str(pkg_dir)]
        res = subprocess.run(cmd, cwd=ROOT)
        if res.returncode != 0:
            failures.append(name)
    if failures:
        print("\nPublish failures:")
        for name in failures:
            print(f"- {name}")
        return 1
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--print-order", action="store_true")
    parser.add_argument(
        "--only",
        nargs="*",
        default=None,
        help="Optional exact package names to publish (e.g. eyycheev/jest eyycheev/jest-globals).",
    )
    args = parser.parse_args()

    packages = find_packages()
    order = topo_order(packages)

    if args.print_order:
        for name in order:
            print(name)
        return 0

    only = set(args.only) if args.only else None
    return run_publish(order, packages, only)


if __name__ == "__main__":
    sys.exit(main())
