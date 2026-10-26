# Techniques

## Prompting patterns

| Pattern              | When to Use                                  | Template                                               |
| -------------------- | -------------------------------------------- | ------------------------------------------------------ |
| **Zero-shot**        | Simple, well-defined tasks                   | Direct instruction without examples                    |
| **Few-shot**         | Tasks with specific format or subtle logic   | 3-5 examples in `<examples>`                           |
| **Chain of Thought** | Logic, math, multi-step analysis             | "Think step by step" + `<thinking>` tags               |
| **Role Prompting**   | Tasks requiring specific expertise           | `<role>` with credentials and perspective              |
| **Self-Consistency** | Critical decisions where you want robustness | "Generate 3 independent answers, then choose the best" |
| **Decomposition**    | Complex tasks with multiple sub-problems     | Split into numbered steps with clear dependencies      |

## Reasoning

Two different tools:

- **Chain of thought** is a prompt instruction: ask Claude to reason before answering, inside `<thinking>` tags so the reasoning stays apart from the response. For analytical tasks, ask it to consider multiple perspectives.
- **Extended thinking** is an API feature, turned on with the request's `thinking` parameter. It needs no tags in the prompt.

Use reasoning for logic problems, math, comparative analysis, multi-factor decisions and debugging. Leave it out of creative tasks, simple translations, direct extraction or formatting, and simple factual answers.

## Long documents

Claude pays more attention to the **end** of the prompt:

- Documents and data at the beginning
- Specific instructions at the end
- Main question as the last line

```xml
<document>
[long content here...]
</document>

<instructions>
Based on the document above, [your specific question here].
</instructions>
```

## Prompt caching

When using Claude's API with prompt caching:

- Place static content (instructions, examples) at the beginning
- Place dynamic content (user input) at the end
- Static sections get cached and reduce costs on repeated calls

## Working with Claude's values

Claude has built-in values (honesty, safety, helpfulness). Work with them:

- Ask for the specific perspective you need, instead of asking it to ignore its instructions.
- State the legitimate context and purpose ("This is for a security CTF", "This is for a fiction novel") instead of asking it to be less cautious.

## Anti-patterns

| Anti-pattern                         | Problem                                            | Fix                                            |
| ------------------------------------ | -------------------------------------------------- | ---------------------------------------------- |
| Contradictory instructions           | Claude tries to satisfy both, inconsistent results | Resolve the conflict, keep one instruction     |
| 3,000+ word prompt with no structure | Claude loses focus on key instructions             | Use XML tags, prioritize, remove redundancy    |
| Multiple tasks in a single prompt    | Diluted quality on each sub-task                   | One prompt per task, or explicit decomposition |
