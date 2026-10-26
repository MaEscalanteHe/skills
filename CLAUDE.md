# Skills

Claude Code plugin marketplace. Published plugins live in `plugins/<name>/`, retired ones in `deprecated/<name>/`.

## Generated files

`.claude-plugin/marketplace.json` and the README tables between the `<!-- skills:start/end -->` and `<!-- mcps:start/end -->` markers are generated from `plugins/*/.claude-plugin/plugin.json`. Change a description or name in the plugin's `plugin.json`, then run `scripts/build-marketplace.sh`. Plugins that ship a `.mcp.json` land in the MCPs table.

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` with `name` set to `<name>`, plus `description` and `author`. The marketplace entry name and the manifest name must match for installs to resolve.
2. Put skills in `plugins/<name>/skills/<skill>/SKILL.md`, with longer material in a `references/` folder beside it. Give each `SKILL.md` frontmatter `license: MIT`, and keep to the fields other agents accept: `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`.
3. If the plugin adapts another project or is built on official documentation, add a row to the README References table (maintained by hand).
4. Run `scripts/build-marketplace.sh`, then `claude plugin validate .`.

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
