#!/usr/bin/env bash
# One command to validate a task before marking it done.
# Gates: file-size rule -> ruff lint -> ruff format -> django checks -> pytest -> node --test.
# Each gate is skipped (loudly) if that part of the project does not exist yet.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2

status=0
run()  { echo; echo "── $1 ──"; shift; "$@" || status=1; }
skip() { echo; echo "── $1: skipped ($2) ──"; }

# Prefer the project venv so CI and a local shell behave identically.
if [ -x .venv/bin/python ]; then BIN=".venv/bin/"; else BIN=""; fi
have() { [ -x "${BIN}$1" ] || command -v "$1" >/dev/null 2>&1; }
tool() { if [ -x "${BIN}$1" ]; then echo "${BIN}$1"; else echo "$1"; fi; }

run "line limit" bash scripts/check_line_limit.sh

if have ruff; then
  run "ruff lint"   "$(tool ruff)" check .
  run "ruff format" "$(tool ruff)" format --check .
else
  skip "ruff" "not installed — pip install -r requirements/dev.txt"
fi

if [ -f manage.py ] && have python; then
  run "django checks" "$(tool python)" manage.py check
else
  skip "django checks" "no manage.py yet (P0-T03)"
fi

if have pytest && [ -d config ]; then
  run "pytest" "$(tool pytest)"
else
  skip "pytest" "no Django project yet (P0-T03)"
fi

if command -v node >/dev/null 2>&1 && compgen -G "tests/js/*.test.mjs" >/dev/null; then
  run "node --test" node --test tests/js
else
  skip "node --test" "no JS formula tests yet (P3-T01)"
fi

echo
if [ "$status" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "CHECKS FAILED"; fi
exit "$status"
