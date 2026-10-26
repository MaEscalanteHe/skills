#!/usr/bin/env bash
set -euo pipefail

# Regenerates the plugin list in .claude-plugin/marketplace.json and the
# Skills/MCPs tables in README.md from plugins/*/ and vendored/*/
# .claude-plugin/plugin.json, so deprecated/ is left out.
# Referenced plugins (entries whose source is another GitHub repo) are written
# by hand in marketplace.json and kept. Plugins that ship a .mcp.json go in the
# MCPs table. Requires jq.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE="$REPO/.claude-plugin/marketplace.json"
README="$REPO/README.md"

cd "$REPO"

plugins="$(
  for manifest in plugins/*/.claude-plugin/plugin.json vendored/*/.claude-plugin/plugin.json; do
    jq --arg source "./${manifest%/.claude-plugin/plugin.json}" \
      '{name, description, source: $source}' "$manifest"
  done | jq -s .
)"

jq --argjson plugins "$plugins" \
  '.plugins = ($plugins + [.plugins[] | select(.source | type == "object")] | sort_by(.name))' \
  "$MARKETPLACE" > "$MARKETPLACE.tmp"
mv "$MARKETPLACE.tmp" "$MARKETPLACE"
echo "wrote $(jq '.plugins | length' "$MARKETPLACE") plugins to $MARKETPLACE"

# Prints a markdown table of the plugins with (mcp=true) or without a .mcp.json.
table() {
  local header="$1" mcp="$2"
  printf '| %s | Description |\n| --- | --- |\n' "$header"
  jq -r '.plugins[] | [.name, .description, (.source |
      if type == "string" then ltrimstr("./") + "/"
      elif .source == "github" then "https://github.com/\(.repo)"
      else error("unsupported source: \(.source)") end)] | @tsv' "$MARKETPLACE" |
    while IFS=$'\t' read -r name description link; do
      if [[ -e "$link/.mcp.json" ]]; then has_mcp=true; else has_mcp=false; fi
      [[ "$has_mcp" == "$mcp" ]] || continue
      echo "| [**$name**]($link) | $description |"
    done
}

# Replaces the lines between <!-- $1:start --> and <!-- $1:end --> in README.md.
replace_block() {
  local marker="$1"
  grep -qx "<!-- $marker:start -->" "$README" && grep -qx "<!-- $marker:end -->" "$README" ||
    { echo "error: missing <!-- $marker:start/end --> markers in $README" >&2; exit 1; }
  BLOCK="$2" awk -v start="<!-- $marker:start -->" -v end="<!-- $marker:end -->" '
    $0 == end { skip = 0 }
    !skip
    $0 == start { print ENVIRON["BLOCK"]; skip = 1 }
  ' "$README" > "$README.tmp"
  mv "$README.tmp" "$README"
}

replace_block skills "$(table Skill false)"
replace_block mcps "$(table MCP true)"
echo "updated Skills and MCPs tables in $README"
