#!/usr/bin/env bash
# Remove generated / transient files. Never touches anything Git tracks.
#
#   scripts/clean.sh          caches and build junk only (safe, instant)
#   scripts/clean.sh --all    also removes .venv, the dev database and collected static files
#   scripts/clean.sh --dry    show what would go, delete nothing
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2

# Refuse to run anywhere that isn't this repo — a cleaner in the wrong directory is a disaster.
[ -f AGENTS.md ] && [ -d .git ] || { echo "Not the e-comhub repo root. Aborting."; exit 2; }

DRY=0; ALL=0
for arg in "$@"; do
  case "$arg" in
    --dry|-n) DRY=1 ;;
    --all|-a) ALL=1 ;;
    *) echo "Unknown option: $arg"; exit 2 ;;
  esac
done

# Caches and byte-code: always safe to delete, always regenerated.
PATTERNS_DIR=(__pycache__ .pytest_cache .ruff_cache .mypy_cache htmlcov node_modules)
PATTERNS_FILE=('*.py[co]' '*.orig' '*.rej' '.DS_Store' 'Thumbs.db' 'lighthouse-report.*')
# Heavier, rebuildable from one command: only with --all.
PATHS_ALL=(.venv venv staticfiles db.sqlite3 db.sqlite3-journal .coverage dist build)

removed=0
kill_path() {
  local p="$1"
  # Absolute guard: never delete something Git tracks.
  if git ls-files --error-unmatch "$p" >/dev/null 2>&1; then
    echo "  SKIP (tracked by git): $p"; return
  fi
  local size; size=$(du -sh "$p" 2>/dev/null | cut -f1)
  if [ "$DRY" -eq 1 ]; then
    echo "  would remove: $p  (${size:-?})"
  else
    rm -rf -- "$p" && echo "  removed: $p  (${size:-?})"
  fi
  removed=$((removed + 1))
}

echo "Cleaning $ROOT"

# Remove the big rebuildable trees first and as a whole, so the scan below never
# descends into them (otherwise a .venv alone prints 300 lines of __pycache__).
if [ "$ALL" -eq 1 ]; then
  for p in "${PATHS_ALL[@]}"; do [ -e "$p" ] && kill_path "$p"; done
fi

# Never descend into these: .git is sacred, the rest are vendor trees we don't audit.
PRUNE=(-path ./.git -o -path ./.venv -o -path ./venv -o -path ./node_modules -o -path ./staticfiles)

for d in "${PATTERNS_DIR[@]}"; do
  while IFS= read -r p; do kill_path "$p"; done \
    < <(find . \( "${PRUNE[@]}" \) -prune -o -type d -name "$d" -print 2>/dev/null)
done

for f in "${PATTERNS_FILE[@]}"; do
  while IFS= read -r p; do kill_path "$p"; done \
    < <(find . \( "${PRUNE[@]}" \) -prune -o -type f -name "$f" -print 2>/dev/null)
done

echo
if [ "$removed" -eq 0 ]; then
  echo "Already clean — nothing to remove."
else
  [ "$DRY" -eq 1 ] && echo "$removed item(s) would be removed (dry run)." \
                   || echo "$removed item(s) removed."
fi

# Prove we broke nothing. The only failure mode that matters is a tracked file being deleted —
# unstaged *edits* are the user's own work and must not trigger a false alarm.
missing="$(git ls-files --deleted 2>/dev/null)"
if [ -n "$missing" ]; then
  echo "WARNING: these tracked files are missing from disk — restore with 'git checkout -- .':"
  echo "$missing" | sed 's/^/  /'
  exit 1
fi
echo "All tracked files intact."
