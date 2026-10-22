# Skills

Personal Claude Code plugin marketplace and agent skills for infrastructure and development workflows.

## Skills

<!-- skills:start -->
| Skill | Description |
| --- | --- |
| [**agents-md-auditor**](plugins/agents-md-auditor/) | Audit and improve CLAUDE.md files with quality scoring, targeted updates, and modern Claude Code feature recommendations |
| [**dockerfile-builder**](plugins/dockerfile-builder/) | Generate optimized, secure multi-stage Dockerfiles with modern BuildKit features, language-specific patterns, and container security best practices |
| [**humanizer**](plugins/humanizer/) | Rewrite AI-sounding text so it reads like the writer without changing what it says |
| [**ponytail**](plugins/ponytail/) | Lazy senior dev mode. Forces the simplest, shortest solution that actually works: YAGNI, stdlib first, no unrequested abstractions. |
| [**terraform-conventions**](plugins/terraform-conventions/) | Write and review Terraform HCL following HashiCorp's official style conventions, with file organization, naming, security, and module best practices |
<!-- skills:end -->

## MCPs

Plugins that bundle an MCP server. Installing one auto-configures the server in Claude Code (you'll be prompted to approve it on first use).

<!-- mcps:start -->
| MCP | Description |
| --- | --- |
| [**playwright**](plugins/playwright/) | Browser automation and end-to-end testing via the Playwright MCP server: navigate, click, fill forms, take snapshots and screenshots, and drive a real browser |
<!-- mcps:end -->

## Installation

### Claude Code Marketplace

```bash
# Add the marketplace
/plugin marketplace add maescalantehe/skills

# Install a plugin from the tables above
/plugin install <plugin>@skala-agent-skills
```

### Skills.sh

```bash
# Pick from all available skills
npx skills add maescalantehe/skills

# Install a specific skill
npx skills add https://github.com/maescalantehe/skills --skill <skill>
```

MCP plugins such as `playwright` are only available through the Claude Code marketplace.

## References

Some plugins are adaptations of existing skills, tailored to my own use case, or unmodified copies kept here so they sync to claude.ai:

| Plugin                    | Based on                                                                                                                                                             |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **terraform-conventions** | [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills)                                                                                                  |
| **agents-md-auditor**     | [anthropics/claude-plugins-official: claude-md-improver](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-md-management/skills/claude-md-improver/SKILL.md) |
| **humanizer**             | [blader/humanizer](https://github.com/blader/humanizer) (unmodified copy)                                                                                            |
| **ponytail**              | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) (unmodified copy)                                                                              |

## Development

`.claude-plugin/marketplace.json` and the Skills and MCPs tables above are generated from each plugin's `plugin.json`, so edit descriptions there. After adding, removing or editing a plugin under `plugins/`, run `scripts/build-marketplace.sh` (requires `jq`). Retired plugins live in [`deprecated/`](deprecated/).

## License

MIT License, see [LICENSE](LICENSE) for details.
