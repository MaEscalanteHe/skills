---
name: prompt-engineer
description: "Write or improve prompts and system prompts for Claude. Use when the user asks for a new prompt, pastes a prompt for feedback, or asks about prompt engineering techniques (few-shot, chain of thought, XML structure)."
license: MIT
---

# Prompt Engineer for Claude

**Reference:** [Anthropic: Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

## Workflow

### 1. Size the prompt to the task

Keep the prompt proportional to the task:

- **Simple** (translation, reformatting, single-step task): clear instructions alone.
- **Moderate** (classification, analysis with criteria): add role, output format and constraints.
- **Complex** (multi-step system, reasoning, design): use the full anatomy, with examples, reasoning and XML structure.

Before writing a moderate or complex prompt, read [references/anatomy.md](references/anatomy.md). When diagnosing a pasted prompt, or when the task needs reasoning, long documents or prompt chaining, read [references/techniques.md](references/techniques.md). When the prompt drives an agent that calls tools, read [references/agentic.md](references/agentic.md).

When the target model is known, read [references/models.md](references/models.md): models differ in default effort, thinking controls and prompt-level quirks. For a model not listed there, check its guide in the reference's "Model-specific guidance" table.

### 2a. Improve a pasted prompt

Diagnose what works, what is missing and what is unnecessary, then write the improved version. Offer variants when there is a real trade-off (conciseness vs. detail, etc.).

### 2b. Create a new prompt

Ask at most 3 questions, covering only what the request leaves open:

- What specific task should Claude perform?
- What's the usage context and expected output format?
- Which Claude model will run it?
- Any constraints, special requirements or reference examples?

Then write the prompt.

### 3. Check

The prompt is done when every item passes, or is skipped on purpose because the task is simple:

- [ ] **Colleague test**: a colleague with minimal context could follow it
- [ ] **Specific role**: concrete expertise and perspective
- [ ] **Clear task**: what Claude must do fits in one unambiguous sentence
- [ ] **Context**: Claude knows WHY it is doing the task
- [ ] **Examples**: 3-5 relevant, diverse examples, consistent with the instructions, when the task is complex
- [ ] **Format**: the response structure is defined
- [ ] **Constraints**: each limit is stated as the behavior wanted, with its reason
- [ ] **Plain emphasis**: directions read as "Use X when…", without CRITICAL or MUST
- [ ] **Thinking left to effort**: no request to write reasoning in the response, and no "think more" or "think less" lines beyond the documented cases
- [ ] **XML tags**: tags separate sections and delimit data
- [ ] **Self-contained**: the prompt works without context it does not include
- [ ] **Single source**: each instruction appears once, and none conflict
- [ ] **Data first, query last**: long inputs at the top, the main question or task at the end
- [ ] **Proportional**: the prompt's complexity matches the task's

### 4. Deliver

Write the prompt and the explanation in the user's language, with these sections:

- **Diagnosis** (only when improving an existing prompt): what works and what doesn't in the original.
- **Prompt**: the complete prompt in a code block, ready to copy.
- **Changes**: each change and how it improves the result, in plain language.
- **How to use**: where to place it (system prompt vs. user message), variables to replace (marked `{{VARIABLE}}`), and API settings when relevant (thinking, `effort`, structured outputs).
- **Next iterations**: 1-2 optional improvements.

When the user wants speed (e.g. "make me a prompt for X"), deliver only the prompt and offer: "Want me to explain the design decisions?"
