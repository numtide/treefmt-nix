#!/usr/bin/env bash
# shellcheck disable=SC2010 disable=SC2012
set -euo pipefail

# reproducibility
export LC_ALL=C

cd "$(dirname "$0")"

programs=(programs/*.nix)

echo "\`treefmt-nix\` currently supports ${#programs[@]} formatters:"
echo

for program in "${programs[@]}"; do
  name=$(basename "$program" .nix)
  echo "* [$name]($program)"
done
