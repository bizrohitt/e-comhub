#!/usr/bin/env bash
# One command to validate a task before marking it done. Skips tools that aren't installed yet.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2
status=0
run() { echo; echo "── $1 ──"; shift; "$@" || status=1; }
have() { command -v "$1" >/dev/null 2>&1; }

run "line limit" bash scripts/check_line_limit.sh
if have ruff; then run "ruff lint"   ruff check .; run "ruff format" ruff format --check .; else echo; echo "── ruff: not installed, skipped ──"; fi
if have pytest && [ -d config ]; then run "pytest" pytest -q; else echo "── pytest: no Django project yet, skipped ──"; fi
if have node && [ -d tests/js ]; then run "node --test" node --test tests/js; else echo "── node --test: no JS tests yet, skipped ──"; fi
echo; [ "$status" -eq 0 ] && echo "ALL CHECKS PASSED" || echo "CHECKS FAILED"
exit "$status"
