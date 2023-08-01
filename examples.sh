#!/usr/bin/env bash
# Used to generate the examples/ folder
set -euo pipefail

cd "$(dirname "$0")"

# Get the system tuple for later
system=$(nix eval --raw --impure --expr 'builtins.currentSystem')

# Generate the examples from the config
nix build ".#checks.$system.examples.passthru.examples"

# Copy
rm -f ./examples/* || true
cp ./result/* ./examples
