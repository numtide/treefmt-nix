#!/usr/bin/env bash
set -euo pipefail

FILE="programs/biome.nix"

# ---- cross-platform sed in-place helper ----
sedi() {
  local sed_expr="$1"
  local file="$2"
  if sed --version >/dev/null 2>&1; then
    # GNU sed
    sed -i "$sed_expr" "$file"
  else
    # BSD/macOS sed
    sed -i '' "$sed_expr" "$file"
  fi
}

# ---- get stable and unstable Biome versions from nixpkgs ----
get_biome_version() {
  local ref=$1
  nix eval --raw "github:NixOS/nixpkgs/$ref#biome.version"
}

get_nixos_stable_tag() {
  git ls-remote --tags https://github.com/NixOS/nixpkgs.git |
    awk '{print $2}' |
    grep -E 'refs/tags/[0-9]+\.[0-9]+$' |
    sed 's|refs/tags/||' |
    sort -V |
    tail -n1
}

STABLE_VERSION=$(get_biome_version "$(get_nixos_stable_tag)")
UNSTABLE_VERSION=$(get_biome_version "nixos-unstable")

# ---- deduplicate version list ----
mapfile -t VERSION_LIST < <(printf "%s\n" "$STABLE_VERSION" "$UNSTABLE_VERSION" | sort -u)
echo "Versions to check: ${VERSION_LIST[*]}"

# ---- extract existing schemaSha256s block into TMP_ENTRIES ----
TMP_ENTRIES="$(mktemp)"
awk '
/^[[:space:]]*schemaSha256s = {/{flag=1; next}
/^[[:space:]]*};/{flag=0; next}
flag && /^[[:space:]]*"/ {print}
' "$FILE" | sed 's/["=;]//g' | awk '{print $1, $2}' >"$TMP_ENTRIES" || true

# ---- helper functions ----
version_known() {
  local v="$1"
  grep -q "^$v " "$TMP_ENTRIES"
}

schema_exists() {
  local v="$1"
  local url="https://biomejs.dev/schemas/${v}/schema.json"
  curl -fsL -o /dev/null "$url"
}

# ---- add missing versions to TMP_ENTRIES ----
for v in "${VERSION_LIST[@]}"; do
  if version_known "$v"; then
    echo "⚡ already recorded: $v"
    continue
  fi

  if schema_exists "$v"; then
    echo "✅ found: $v — prefetching hash..."
    sha=$(nix-prefetch-url --quiet --type sha256 "https://biomejs.dev/schemas/${v}/schema.json")
    echo "$v sha256:$sha" >>"$TMP_ENTRIES"
  else
    echo "❌ schema not found for $v"
  fi
done

# ---- sort all entries ----
sort -V "$TMP_ENTRIES" -o "$TMP_ENTRIES"

# ---- rebuild schemaSha256s block in the file ----
TMP_FILE="$(mktemp)"
awk -v entries="$TMP_ENTRIES" '
  BEGIN { while ((getline < entries) > 0) { e[++n] = $0 } }
  /^[[:space:]]*schemaSha256s = {/,/^[[:space:]]*};/ {
      if ($0 ~ /^[[:space:]]*schemaSha256s = {/) {
          print $0
          for (i=1;i<=n;i++) {
              split(e[i], a, " ")
              printf "    \"%s\" = \"%s\";\n", a[1], a[2]
          }
          next
      }
      if ($0 ~ /^[[:space:]]*};/) { print $0; next }
      next
  }
  { print }
' "$FILE" >"$TMP_FILE"

mv "$TMP_FILE" "$FILE"
rm "$TMP_ENTRIES"

echo "✨ Updated schemaSha256s in $FILE"
