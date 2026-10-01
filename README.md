# Skills

Personal Claude Code plugin marketplace and agent skills for infrastructure and development workflows.

## Skills

| Skill                                                       | Description                                                                                                                                                                       |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [**terraform-conventions**](plugins/terraform-conventions/) | Terraform HCL style guide following HashiCorp conventions, with file organization, naming, security, and module best practices                                                    |
| [**dockerfile-builder**](plugins/dockerfile-builder/)       | Multi-stage Dockerfiles with modern BuildKit features, language-specific patterns (Go, Node, Python, Java), and container security                                                |
| [**github-issue-tracker**](plugins/github-issue-tracker/)   | Track edge cases and TODOs as GitHub issues with duplicate detection, TODO file processing, and proactive suggestions                                                             |
| [**claude-md-auditor**](plugins/claude-md-auditor/)         | Audit and improve CLAUDE.md files with quality scoring, targeted updates, and modern Claude Code feature recommendations                                                          |
| [**caveman**](plugins/caveman/)                             | Ultra-compressed communication mode that cuts token usage while keeping full technical accuracy, with lite, full, and ultra levels. Includes a hook that exposes the active level to the statusline (requires `jq`) |
| [**context7**](plugins/context7/)                           | Retrieve up-to-date, version-specific library/framework/API docs and code examples via the Context7 REST API (curl, no key needed)                                                |

## MCPs

Plugins that bundle an MCP server. Installing one auto-configures the server in Claude Code (you'll be prompted to approve it on first use).

| MCP                                   | Description                                                                                                                   |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| [**playwright**](plugins/playwright/) | Browser automation and end-to-end testing: navigate, click, fill forms, take snapshots and screenshots, drive a real browser |

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

Some plugins are adaptations of existing skills, tailored to my own use case:

| Plugin                    | Based on                                                                                                                                                             |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **terraform-conventions** | [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills)                                                                                                  |
| **claude-md-auditor**     | [anthropics/claude-plugins-official: claude-md-improver](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/claude-md-management/skills/claude-md-improver/SKILL.md) |
| **caveman**               | [juliusbrussee/caveman](https://github.com/juliusbrussee/caveman)                                                                                                    |
| **context7**              | [intellectronica/agent-skills: context7](https://github.com/intellectronica/agent-skills/blob/main/skills/context7/SKILL.md)                                          |

## License

MIT License, see [LICENSE](LICENSE) for details.
