#!/usr/bin/env bash
# Prototype. A much better solution would be to implement these checks in treefmt itself
# (e.g. `treefmt --check-spec <formatter>`): it already has the formatter configuration
# (command, options, working directory, stdin mode), so it could run the formatter exactly
# as it does when formatting, report violations from any treefmt setup rather than only
# treefmt-nix
#
# Usage: formatter-spec.sh <fixture-dir> <command> [options...]
# See https://treefmt.com/latest/reference/formatter-spec/
set -euo pipefail

fixtures=$1
shift
fmt=("$@")

spec=https://treefmt.com/latest/reference/formatter-spec
fail() {
  echo "FAIL: $1 ($spec/#$2)" >&2
  exit 1
}

mkdir -p shallow deep/x/y decoy invalid

for f in "$fixtures"/unformatted/*; do
  cp "$f" shallow/
  cp "$f" deep/x/y/
  cp "$f" decoy/
done
chmod -R u+w shallow deep decoy

"${fmt[@]}" shallow/* deep/x/y/* ||
  fail "exited nonzero on valid input" 3-exit-nonzero-on-error

for f in "$fixtures"/unformatted/*; do
  name=$(basename "$f")
  cmp -s "$f" "shallow/$name" &&
    fail "$name was not modified" 2-write-to-changed-files
  cmp -s "$f" "decoy/$name" ||
    fail "$name was modified although not passed as argument" 1-files-passed-as-arguments
  diff -u "shallow/$name" "deep/x/y/$name" ||
    fail "$name formatted differently depending on its path; fine only if the formatter implements the stdin spec" 6-path-agnostic
done

cp -r shallow formatted
touch -d @0 shallow/*
"${fmt[@]}" shallow/* ||
  fail "exited nonzero on formatted input" 3-exit-nonzero-on-error
diff -ru formatted shallow ||
  fail "second run changed the output" 4-idempotent
for f in shallow/*; do
  [[ $(stat -c %Y "$f") == 0 ]] ||
    fail "$(basename "$f") was rewritten although unchanged" 2-write-to-changed-files
done

if [[ -d $fixtures/invalid ]]; then
  valid=(shallow/*)
  for f in "$fixtures"/invalid/*; do
    name=$(basename "$f")
    cp "$f" "invalid/$name"
    chmod u+w "invalid/$name"
    if "${fmt[@]}" "invalid/$name"; then
      fail "exited zero on invalid input $name" 3-exit-nonzero-on-error
    fi
    if "${fmt[@]}" "invalid/$name" "${valid[@]}"; then
      fail "exited zero on invalid input $name followed by valid files" 3-exit-nonzero-on-error
    fi
  done
fi
