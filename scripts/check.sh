#!/bin/bash
# check.sh — Runs ShellCheck on all shell scripts.

set -e

failed=0
cd "$(dirname "$0")/.."

if ! command -v shellcheck &> /dev/null; then
  echo "ShellCheck not installed (brew install shellcheck). Skipping."
  exit 0
fi

while IFS= read -r -d '' f; do
  shellcheck "$f" || failed=1
done < <(find . -name "*.sh" -not -path "./node_modules/*" -not -path "./.git/*" -print0)

exit $failed
