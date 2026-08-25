#!/usr/bin/env bash
# Negative type-level boundary: every file under test/should-fail/ MUST
# fail to type-check against the kalecky-semantics library. Exits 0 only
# if all files are rejected. (Excluded-source convention: these files
# are in no cabal stanza and are never built.)
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
for f in test/should-fail/*.hs; do
  out=$(printf ':load %s\n' "$f" | stack ghci kalecky-semantics:lib --ghci-options=-fno-code --silent 2>&1)
  if printf '%s' "$out" | grep -q "error:"; then
    echo "ok:   $f rejected by the type checker"
  else
    echo "FAIL: $f type-checked — the boundary is broken"
    fail=1
  fi
done
exit $fail
