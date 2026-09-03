# Internal-API audit (docs)

This pass was scoped to Docusaurus markdown under `docs/`, not the Luau implementation. The goal is to flag APIs a public creator would not reasonably know about.

## Summary

- Dump fetched-at timestamp: `2026-09-03T20:48:54Z`
- Files scanned: 18 (`docs/docs/*.md`)
- Candidate occurrences considered: 47 (GetService / Instance.new / PascalCase method calls / Enum refs / explicit service names)
- Findings included (rank ≥ 8): **12**, all rank **10**
- Breakdown by rank: 8: 0, 9: 0, 10: 12
- Breakdown by category:

| Category | Count |
|---|---|
| service | 5 |
| class | 0 |
| member (function) | 7 |
| member (property) | 0 |
| member (event) | 0 |
| enum | 0 |

## Findings by file

### docs/docs/CLI.md

- **L11** `ProcessService` — rank **10/10** — class not in public dump
  - gated on: n/a (absent from dump)
  - receiver: prose, not a call site
  ```markdown
  which exposes command-line arguments made available by `ProcessService`
  ```

- **L21** `ProcessService` — rank **10/10** — class not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `game:GetService("ProcessService")`
  ```lua
  return game:GetService("ProcessService")
  ```

- **L35** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(0)
  ```

- **L40** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(1)
  ```

### docs/docs/GettingStarted.md

- **L44** `ProcessService` — rank **10/10** — class not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `game:GetService("ProcessService")`
  ```lua
  return game:GetService("ProcessService")
  ```

- **L58** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(0)
  ```

- **L63** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(1)
  ```

### docs/docs/UpgradingToJest3.md

- **L26** `ProcessService` — rank **10/10** — class not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `game:GetService("ProcessService")`
  ```lua
  return game:GetService("ProcessService")
  ```

- **L40** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(0)
  ```

- **L45** `ExitAsync` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `ProcessService`
  ```lua
  ProcessService:ExitAsync(1)
  ```

### docs/docs/JestBenchmarkAPI.md

- **L196** `FileSystemService` — rank **10/10** — class not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `FileSystemService` (undeclared global in the sample)
  ```lua
  FileSystemService:WriteFile(benchmarkFile, benchmarks)
  ```

- **L196** `WriteFile` — rank **10/10** — Function not in public dump
  - gated on: n/a (absent from dump)
  - receiver: `FileSystemService`
  ```lua
  FileSystemService:WriteFile(benchmarkFile, benchmarks)
  ```
