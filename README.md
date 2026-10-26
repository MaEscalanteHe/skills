# Skills

Personal Claude Code plugin marketplace and agent skills for infrastructure and development workflows.

## Skills

<!-- skills:start -->
| Skill | Description |
| --- | --- |
| [**agents-md-auditor**](plugins/agents-md-auditor/) | Audit and improve CLAUDE.md files with quality scoring, targeted updates, and modern Claude Code feature recommendations |
| [**dockerfile-builder**](plugins/dockerfile-builder/) | Generate optimized, secure multi-stage Dockerfiles with modern BuildKit features, language-specific patterns, and container security best practices |
| [**humanizer**](vendored/humanizer/) | Rewrite AI-sounding text so it reads like the writer without changing what it says |
| [**mattpocock-skills**](https://github.com/mattpocock/skills) | Matt Pocock's agent skills for real engineering: grilling, spec/ticket flows, TDD, code review, domain modelling and more |
| [**ponytail**](vendored/ponytail/) | Lazy senior dev mode. Forces the simplest, shortest solution that actually works: YAGNI, stdlib first, no unrequested abstractions. |
| [**prompt-engineer**](plugins/prompt-engineer/) | Create, improve and optimize prompts and system prompts for Claude, with a diagnosis of what works and the reasoning behind each change |
| [**split-bill**](plugins/split-bill/) | Split a restaurant bill between several people from a photo of the receipt, matching every line to who ordered it and reconciling against the printed total |
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
/plugin install <plugin>@maescalantehe
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

Some plugins are adaptations of existing skills, tailored to my own use case, built on official documentation, unmodified copies kept here so they sync to claude.ai, or references to another repo:

| Plugin                    | Based on                                                                                                                                                             |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **terraform-conventions** | [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills), [HashiCorp Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style) |
| **agents-md-auditor**     | [anthropics/claude-plugins-official: claude-md-improver](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-md-management/skills/claude-md-improver/SKILL.md) |
| **humanizer**             | [blader/humanizer](https://github.com/blader/humanizer) (unmodified copy)                                                                                            |
| **mattpocock-skills**     | [mattpocock/skills](https://github.com/mattpocock/skills) (referenced)                                                                                               |
| **ponytail**              | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) (unmodified copy)                                                                              |
| **prompt-engineer**       | [Anthropic: Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) |

## Development

`.claude-plugin/marketplace.json` and the Skills and MCPs tables above are generated from each plugin's `plugin.json`, so edit descriptions there. After adding, removing or editing a plugin under `plugins/` or `vendored/` (unmodified copies of other repos), run `scripts/build-marketplace.sh` (requires `jq`). Referenced plugins point at another repo instead of a folder here, and their marketplace entries live in `referenced/`. Retired plugins live in [`deprecated/`](deprecated/).

## License

MIT License, see [LICENSE](LICENSE) for details.
