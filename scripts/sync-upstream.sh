#!/usr/bin/env bash
set -euo pipefail

# Copies the latest upstream release of a vendored plugin into vendored/<name>/,
# using the repo and path map in vendored/<name>/.upstream.json, and sets the
# plugin's version to the release. For a referenced plugin (referenced/<name>.json,
# whose source is another GitHub repo), points its sha at the release commit
# instead. Prints the release tag, or nothing when the plugin is
# already up to date. Also does the first import of a new plugin.
# Requires gh and jq.

name="$1"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
dir="$REPO/vendored/$name"
ref="$REPO/referenced/$name.json"
if [[ -e "$dir/.upstream.json" ]]; then
  upstream="$(jq -r .repo "$dir/.upstream.json")"
elif [[ -e "$ref" ]]; then
  upstream="$(jq -r .source.repo "$ref")"
else
  echo "$name is neither vendored nor referenced" >&2; exit 1
fi

tag="$(gh api "repos/$upstream/releases/latest" --jq .tag_name)"
# The tag ends up in branch names and shell commands.
[[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "unexpected tag: $tag" >&2; exit 1; }

if [[ -e "$ref" ]]; then
  sha="$(gh api "repos/$upstream/commits/$tag" --jq .sha)"
  [[ "$(jq -r .source.sha "$ref")" == "$sha" ]] && exit 0
  jq --arg sha "$sha" '.source.sha = $sha' "$ref" > "$ref.tmp"
  mv "$ref.tmp" "$ref"
  echo "$tag"
  exit 0
fi
current="$(jq -r .version "$dir/.claude-plugin/plugin.json" 2>/dev/null || echo 0.0.0)"
[[ "$(printf '%s\n' "$current" "${tag#v}" | sort -V | tail -1)" == "$current" ]] && exit 0

src="$(mktemp -d)"
trap 'rm -rf "$src"' EXIT
gh api "repos/$upstream/tarball/$tag" | tar -xz -C "$src" --strip-components=1

while IFS=$'\t' read -r from to; do
  # Guards the rm below: an empty or escaping path would delete outside the target.
  [[ -n "$to" && "$to" != *..* && "$to" != /* ]] || { echo "bad path: $to" >&2; exit 1; }
  rm -rf "${dir:?}/$to"
  mkdir -p "$(dirname "$dir/$to")"
  cp -r "$src/$from" "$dir/$to"
done < <(jq -r '.paths | to_entries[] | [.key, .value] | @tsv' "$dir/.upstream.json")

jq --arg v "${tag#v}" '.version = $v' "$dir/.claude-plugin/plugin.json" > "$dir/plugin.json.tmp"
mv "$dir/plugin.json.tmp" "$dir/.claude-plugin/plugin.json"
echo "$tag"
