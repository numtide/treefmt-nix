#!/usr/bin/env bash
set -euo pipefail

cd tests
nix flake check --recreate-lock-file --show-trace
