# Agentic system prompts

For prompts that drive an agent calling tools. Each section names the behavior to steer; the reference's "Tool use" and "Agentic systems" sections and the model guides carry full sample prompts.

## Action vs. suggestion

Claude follows the wording literally: "Can you suggest some changes?" gets suggestions, "Change this function to improve its performance" gets edits. Set the default in the system prompt:

- **Proactive**: "By default, implement changes rather than only suggesting them. If the user's intent is unclear, infer the most useful likely action and proceed, using tools to discover missing details instead of guessing."
- **Conservative**: "When the user asks for ideas, options or a plan, give them that and stop. Don't start building or changing anything until they say to go ahead."

## Tool calls

- **Parallel calls**: "If you intend to call multiple tools and there are no dependencies between the calls, make all of the independent calls in parallel. Call dependent tools sequentially, and never guess missing parameters."
- **Grounding**: "Read any file the user references before answering. Investigate the relevant code before making claims about it."

## Progress updates

Remove lines inherited from older models such as "hold all findings for the final response": recent models already write fewer updates. When the user follows the work live, ask for updates at set points: "Before you start, say in a line what you're about to do; brief updates while you work help the user follow along. Close with a short recap that stands on its own (what you found, what you did, and what's next) so a reader who only sees the last message has the full picture."

## Finishing the task and scope

Recent models sometimes stop to check in before the work is done, or add work nobody asked for. The same two paragraphs appear across the model guides:

```text
Keep working until everything the user asked for is done, and only stop to ask when you can't go on without the user or before a risky step.

When the work the user asked for is done and checked, stop and report. Don't add features, tests, files, docs or refactors that weren't asked for. If you think one would help, mention it at the end instead of doing it.
```

Use the first for early stops, the second for unrequested additions. Neither replaces the confirmation rules below.

- **Tests**: "Write a general solution that works for all valid inputs, not just the test cases. If a test is wrong or the task is infeasible, tell me instead of working around it."
- **Temporary files**: "Remove any temporary files, scripts or helpers you create once the task is done."

## Verification

When changes are reported as done without test or build output, add:

```text
When you change code that can be run, built, or type-checked, run a real check that exercises the change before reporting it done: the project's tests, type-checker, or build, or the changed command itself. A syntax-only check, or a check command that failed to start, does not count; if all that is missing is the project's declared dependencies, install them with its own package manager and lockfile (e.g. npm install, pip install -r requirements.txt), never via sudo or the system package manager, unless told not to. Only if no real check can run here, say which one you did not run and why instead of reporting the change as done.
```

## Autonomy and safety

State which actions need confirmation: "Take local, reversible actions like editing files or running tests freely. Ask before actions that are hard to reverse, affect shared systems or could be destructive: deleting files or branches, force-pushing, pushing code, posting to external services."

## Subagents

Recent models delegate to subagents on their own, sometimes where a direct call would do. Give the rule: "Use subagents when tasks can run in parallel, need isolated context, or are independent workstreams. For simple tasks, sequential operations or single-file edits, work directly."

## Long-running tasks

- **Context limits**: in a harness that compacts context, say so, or Claude may wrap up early as the window fills: "Your context window will be compacted automatically, so continue working until the task is complete. Save progress and state before the context refreshes."
- **First window**: use it to set up the framework (tests, setup scripts such as `init.sh`), and later windows to iterate on a todo list.
- **State**: structured files for structured state (`tests.json`), free-form notes for progress (`progress.txt`), and git as log and checkpoint.
- **Fresh start**: when starting a new window instead of compacting, say how to resume: "Review progress.txt, tests.json and the git log."
- **Verification tools**: give Claude tools to check its own work (tests, browser or computer use) when no human reviews each step.

## Search and research

- **Date**: with a search tool, give the current date in the system prompt or the tool description ("The current date is {{current_date}}."), rendered once when the conversation starts.
- **What to search**: "Your training data ends well before today's date. Records, office holders, prices, versions, rules and anything "latest" may have changed since then, so search for those before you answer, even when you feel sure. Facts that can't change need no search."
- **Calibration**: drop lines that discourage searching ("minimize tool calls", "only use tools when strictly necessary"), and also blanket ones ("search for any factual question"), which add searches without adding correct answers.
- **Research tasks**: define what a successful answer looks like, ask Claude to verify claims across several sources, and for complex questions ask it to track competing hypotheses with confidence levels in a notes file.
