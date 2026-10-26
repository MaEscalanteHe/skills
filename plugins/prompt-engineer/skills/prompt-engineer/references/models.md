# Model notes

Prompt-level differences for current models, as of October 2026. Each guide also covers API and harness changes (history handling, thinking display, `max_tokens`, refusal fallback) that are out of scope here. For a model not listed, use the reference's "Model-specific guidance" table.

On all four, `effort` is the main control for thinking, and re-running an effort sweep beats carrying a level over from the previous model: level names don't map to the same amount of thinking across models.

## Claude Fable 5.1

[Guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1). Default effort `high`; test `medium` and `low` too, `low` often competes with smaller models on cost. Thinking always on.

- **Fewer progress updates** during long tool chains: ask for them (see [agentic.md](agentic.md#progress-updates)).
- **Formats less** than earlier models: remove anti-formatting rules and say when lists help instead: "Use lists and bullet points when asked to, or when the content is multifaceted enough that they help with clarity."
- **Dense prose**: "Please remove all mannered prose." usually works; the guide has a longer version.
- **Unmarked quotes** when summarizing sources: add one complete example with a rationale (see [anatomy.md](anatomy.md#4-examples-few-shot)).
- **Stops before finishing** on long asynchronous work, or asks permission for work already requested: the guide's "Finish the whole task" blocks, starting with "You are operating autonomously. The user is not watching in real time…".
- **Unrequested fixes and extra test files**: the guide's "Keep changes and tests to what the task asks for" instruction.
- **Searches less at `low` effort**: raise effort for those turns, or nudge it to verify names it does not confidently recognize.
- **Rewrites whole files** for small changes: "When it will not affect the end result, try to surgically edit a file rather than rewrite the entire thing."
- **Long deliverables at `xhigh`/`max`** get drafted twice (in thinking, then in the reply): run them at `high`, or use the guide's note on not composing the full output as reasoning.

## Claude Opus 5.5

[Guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5). Default effort `medium`, which matches or beats Opus 5 at `high` on coding and knowledge work. Thinking always on, and it thinks more per turn than Opus 5 at the same level.

- **Thinking-disabled prompts from Opus 5**: remove instructions that had the model write reasoning in the response, and rules telling it not to think.
- **Chat**: remove "think carefully" lines; add the settled-answers line if follow-ups re-think earlier answers (see [techniques.md](techniques.md#reasoning)).
- **Unattended agents stop after reporting progress**: name the early stops to avoid in the system prompt (the guide has a full paragraph), and have the harness send a continuation naming the open items.
- **Multi-app workflows**: "Before taking any action, explore broadly with tool calls: list and open the emails, documents, spreadsheet tabs and records across the available apps that could be relevant to this task, including ones the task does not explicitly mention, and use what you find."
- **Multi-agent teams**: give a time budget the harness reports after each message (`elapsed 340s / 1200s`), or "Time matters here: do not spend time that can be avoided, and the earlier a correct result is obtained, the better."
- **Pasted text**: responds well to `<pasted_content>` marking (see [anatomy.md](anatomy.md#pasted-content)).
- **Frontend**: "avoid a generic AI look" swaps one default for another; name the specific patterns to avoid (cream backgrounds, numbered section labels, pill buttons…) and extend the list after each round.

## Claude Sonnet 5.5

[Guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5). Default effort `high`; start at `medium` for agentic coding and `medium` or `low` for chat. Lowest thinking setting is `thinking: {type: "between_tools"}`, which skips thinking entirely on requests without tools.

- **Prompts to think less don't reliably reduce thinking**: from `medium` up it thinks before almost every reply; lower effort instead.
- **Checks in early at `low`/`medium`**: first paragraph of the finishing block (see [agentic.md](agentic.md#finishing-the-task-and-scope)).
- **Adds tests, docs and files** at every effort level: second paragraph of that block.
- **Self-started review rounds at `xhigh`/`max`**: "When the work the user asked for is done and its checks pass, stop and report. Don't start extra rounds of review or hardening on your own, and don't launch reviewer sub-agents unless the user asked for a review."
- **Builds when asked for ideas** on open-ended requests: the conservative default in [agentic.md](agentic.md#action-vs-suggestion).
- **JSON on reasoning tasks**: the "Think the problem through" line, with adaptive thinking rather than `between_tools`.
- **Answers from training knowledge**: the search instruction in [agentic.md](agentic.md#search-and-research).
- **Skips verification at `low`**: the verification block in [agentic.md](agentic.md#verification).

## Claude Haiku 5.5

[Guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-haiku-5-5). Default effort `medium`; `low` for chat and high-volume requests, `high` for knowledge work and strict instruction following. Thinking on by default; `thinking: {type: "disabled"}` works at `low` to `high`.

- **Prompts to answer directly don't stop thinking**: lower effort or disable thinking.
- **Search**: give the date, and with long system prompts or `low` effort add the search nudge (see [agentic.md](agentic.md#search-and-research)).
- **Thinking off + structured outputs skips needed tool calls**: use adaptive thinking, or "The JSON output format applies to your final answer only. When you need a tool, call it first, with no text before the call, and write the JSON once you have the results."
- **Stops early in long agent prompts at `low`**: the finishing block in [agentic.md](agentic.md#finishing-the-task-and-scope).
- **Skips verification at `low`/`medium`**: the verification block.
- **Chatbots give in under pressure**: the rules-hold line in [anatomy.md](anatomy.md#6-constraints--guardrails), with `high` effort.
- **Reasoning-like text in replies** with thinking off or at `low`: switch to adaptive thinking at `medium`.
