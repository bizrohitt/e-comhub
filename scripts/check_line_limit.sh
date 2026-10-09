#!/usr/bin/env bash
# Enforces the project file-size rule: no source file over HARD lines, warn at SOFT.
# Usage: scripts/check_line_limit.sh [path ...]      Env: HARD_LIMIT=600 SOFT_LIMIT=400
set -uo pipefail

HARD="${HARD_LIMIT:-600}"
SOFT="${SOFT_LIMIT:-400}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

# Files we never author by hand (vendored, generated, or minified).
EXCLUDE_RE='(^|/)(\.git|node_modules|\.venv|venv|staticfiles|migrations|static/vendor)/|\.min\.|(^|/)package-lock\.json$|\.lock$'
INCLUDE_RE='\.(py|html|js|mjs|css|md|sh|toml|yml|yaml|cfg)$'

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  mapfile -t FILES < <(git ls-files --cached --others --exclude-standard "$@" 2>/dev/null)
else
  mapfile -t FILES < <(find "${@:-.}" -type f 2>/dev/null)
fi

fail=0; warn=0; checked=0
for f in "${FILES[@]}"; do
  [[ -f "$f" ]] || continue
  [[ "$f" =~ $INCLUDE_RE ]] || continue
  [[ "$f" =~ $EXCLUDE_RE ]] && continue
  n=$(wc -l < "$f" | tr -d ' ')
  checked=$((checked + 1))
  if (( n > HARD )); then
    printf 'FAIL  %5d  %s\n' "$n" "$f"; fail=$((fail + 1))
  elif (( n > SOFT )); then
    printf 'WARN  %5d  %s  (split before it reaches %d)\n' "$n" "$f" "$HARD"; warn=$((warn + 1))
  fi
done

printf '\nchecked %d files | hard limit %d | soft limit %d | %d warnings | %d failures\n' \
  "$checked" "$HARD" "$SOFT" "$warn" "$fail"
(( fail == 0 )) || { echo "Split the files above before committing. See .agent/skills/line-limit-refactor.md"; exit 1; }
echo "OK"
