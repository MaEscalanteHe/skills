# Techniques

## Reasoning

Current models use **adaptive thinking** (`thinking: {type: "adaptive"}`): Claude decides when and how much to think. The `effort` parameter is the main control for depth, and on several recent models thinking is always on. Manual extended thinking with `budget_tokens` is the older mode, and from Claude 4.7 on it returns a 400 error. [models.md](models.md) has each model's defaults.

- **Effort before prompt lines.** To get less thinking, lower `effort`: on current models, prompt instructions to think less or answer directly do not reliably reduce it. In chat system prompts, remove lines telling Claude to think carefully; replies start sooner with no clear loss in quality.
- **Documented exception.** Reasoning tasks with JSON output: see [anatomy.md](anatomy.md#5-output-format).
- **Reasoning stays in thinking.** A prompt asking the model to write its reasoning in the response, for example in `<thinking>` tags, may be declined with the `reasoning_extraction` refusal category. Ask for a short explanation of the answer or a summary of the actions taken instead. Manual CoT (reason first, final answer in `<answer>` tags) is for older models running with thinking off.
- **General over prescriptive.** When guiding thinking, "think thoroughly" often reasons better than a hand-written step-by-step plan.
- **Self-check.** Append "Before you finish, verify your answer against [test criteria]", useful for code and math. Claude Opus 5 already verifies its work; there, this instruction causes over-verification.
- **Settled answers.** In multi-turn chat, "Once you have answered something, treat that answer as done. On later turns, focus your thinking on what the user is asking now, and don't go back over an earlier answer unless the user asks about it or points out a problem with it." reduces re-thinking on follow-ups. Leave it out where later steps can reveal earlier mistakes.

## Long documents

For inputs of 20k+ tokens:

- Put the documents at the top, above instructions, examples and the query. Placing the query at the end improved response quality by up to 30% in Anthropic's tests, especially with several documents.
- Wrap each document with its metadata:

```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
      {{ANNUAL_REPORT}}
    </document_content>
  </document>
</documents>

Analyze the annual report. Identify strategic advantages and recommend Q3 focus areas.
```

- Ask Claude to quote the relevant passages first (in `<quotes>` tags), then answer from those quotes.

## Prompt chaining

Most multistep reasoning now happens inside one call. Split a task into separate calls only when you need to inspect, log or branch on intermediate outputs. The common chain is self-correction: draft, then review against criteria, then refine.

## Working with Claude's values

Claude has built-in values (honesty, safety, helpfulness). Work with them:

- Ask for the specific perspective you need, instead of asking it to ignore its instructions.
- State the legitimate context and purpose ("This is for a security CTF", "This is for a fiction novel") instead of asking it to be less cautious.

## Anti-patterns

| Anti-pattern                                   | Problem                                                     | Fix                                            |
| ---------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------- |
| "CRITICAL: You MUST use this tool when…"       | Recent models follow the system prompt closely and overtrigger | "Use this tool when…"                       |
| Thoroughness pushes tuned for older models     | "If in doubt, use [tool]" now causes overuse                | Targeted guidance: "Use [tool] when it helps…" |
| Multiple tasks in a single prompt              | Diluted quality on each sub-task                            | One prompt per task, or explicit decomposition |
