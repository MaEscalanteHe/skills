# Skills

Claude Code plugin marketplace. Published plugins live in `plugins/<name>/`, retired ones in `deprecated/<name>/`.

## Generated files

`.claude-plugin/marketplace.json` and the README tables between the `<!-- skills:start/end -->` and `<!-- mcps:start/end -->` markers are generated from `plugins/*/.claude-plugin/plugin.json`, plus the referenced plugins below. Change a description or name in the plugin's `plugin.json`, then run `scripts/build-marketplace.sh`. Plugins that ship a `.mcp.json` land in the MCPs table.

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` with `name` set to `<name>`, plus `description` and `author`. The marketplace entry name and the manifest name must match for installs to resolve.
2. Put skills in `plugins/<name>/skills/<skill>/SKILL.md`, with longer material in a `references/` folder beside it. Give each `SKILL.md` frontmatter `license: MIT`, and keep to the fields other agents accept: `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`.
3. If the plugin adapts another project or is built on official documentation, add a row to the README References table (maintained by hand).
4. Run `scripts/build-marketplace.sh`, then `claude plugin validate .`.

## Vendoring or referencing an upstream plugin

A marketplace entry can point at another repo instead of a copy (`"source": {"source": "github", "repo": "<owner>/<repo>", "sha": "<commit>"}`), and claude.ai installs it like a local plugin.

- Reference an upstream that is already a valid plugin at its repo root and whose whole repo you accept (`mattpocock-skills`). claude.ai lists every `SKILL.md` in a referenced repo and ignores the manifest's `skills` list, so upstream drafts ship too.
- Vendor when the upstream needs its paths remapped into plugin layout (humanizer keeps `SKILL.md` at its root) or when only some of its folders should ship (ponytail).
- Vendoring also puts each upstream release up for review as a diff in the sync PR. A reference's sync PR only changes its `sha`, so review the upstream release notes it links.

## Referenced plugins

A marketplace entry whose `source` is an object is written by hand in `.claude-plugin/marketplace.json`, and `scripts/build-marketplace.sh` keeps it. Its `sha` is the commit of the upstream's latest `vX.Y.Z` release.

- Its `sha` changes only through `scripts/sync-upstream.sh <name>`, which `.github/workflows/sync-upstream.yml` runs weekly, opening a PR per new release.
- To add one, the upstream must publish GitHub Releases tagged `vX.Y.Z`. Write its entry with `name`, `description` and a `github` source without `sha`, run `scripts/sync-upstream.sh <name>` to pin it, add a References row marked "(referenced)", then do step 4.

## Vendored plugins

A plugin with a `.upstream.json` is an unmodified copy of another repo's release, kept here so it can be installed from claude.ai. The file names the upstream `repo` and maps upstream `paths` to paths inside the plugin.

- Its files change only through `scripts/sync-upstream.sh <name>`. `.github/workflows/sync-upstream.yml` runs it weekly and opens a PR per new release, which overwrites any hand edit. To customize a vendored plugin, delete its `.upstream.json` so it becomes an adaptation.
- Its `SKILL.md` frontmatter stays as upstream wrote it, exempt from step 2 above.
- To add one, the upstream must publish GitHub Releases tagged `vX.Y.Z`. Write `plugins/<name>/.upstream.json`. If `paths` leaves out the upstream `.claude-plugin/plugin.json`, write one per step 1. Run `scripts/sync-upstream.sh <name>` for the first import, add a References row marked "(unmodified copy)", then do step 4.

## Deprecating a plugin

1. `git mv plugins/<name> deprecated/<name>`.
2. Add `metadata:` / `internal: true` to the frontmatter of each of its `SKILL.md` files. skills.sh scans the whole repo, and this flag hides them.
3. Move its README References row to `deprecated/README.md`, adding the reason.
4. Run `scripts/build-marketplace.sh`.

Restoring a plugin is the same steps in reverse.

## Writing

Write all repo content in English. Punctuate with commas, colons and parentheses, never em dashes.
