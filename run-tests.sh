#!/usr/bin/env bash
set -euo pipefail

echo
echo Running tests...
nix flake check ./tests --recreate-lock-file --show-trace

echo
echo Checking that the flake.parts docs build...
nix build github:hercules-ci/flake.parts-website --override-input treefmt-nix . --show-trace --log-lines 1000 || {
  echo
  echo "Looks like the docs aren't quite ok yet."
  echo "If there's a long stack trace, look for the keyword: option"
  echo "Ping flake-parts / module system maintainer @roberth if the error is unclear."
  # TODO After https://github.com/NixOS/nix/issues/7553 is resolved, review
  #      --show-trace option and error elobaration.
  exit 1
}
