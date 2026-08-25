# kalecky-semantics

A plain Stack project (lts-23.28 / GHC 9.8.4). No EVM, no hevm, no Lean.

- Library: `src/Kalecky/**` — one concept per file; the tree layout is design, keep it.
- Tests: `test/**` mirror the src tree; `test/should-fail/*.hs` are compile-fail boundary files (never built).
- Specification source of truth: `notes/INCOME_DISTRIBUTION.md`.
- Loop: `stack test` (runtime laws + examples) and `scripts/check-compile-fail.sh` (type-level rejections).
- Process: every type increment is co-designed with the user — laws + a concrete example approved before implementation; RED→GREEN commit pairs.
