# Anatomy of a Claude prompt

Six components. Use only the ones the task's complexity calls for.

## 1. Role / Identity

Define who Claude is in this context, with specific expertise and perspective.

```xml
<role>
You are a senior code reviewer specializing in web application security
with 10 years of experience in OWASP Top 10.
</role>
```

A specific role ("senior security reviewer") outperforms "you are a helpful assistant", which adds nothing because Claude already is one.

## 2. Context / Background

Explain the **why** behind the task. Claude produces better responses when it understands the purpose.

```xml
<context>
We're migrating a legacy PHP app to Node.js. We need to review each
endpoint before production. The team has intermediate security experience.
</context>
```

## 3. Clear Instructions

State exactly what to do and what to return.

**Weak**: "Help me with this code"
**Strong**: "Review this REST endpoint for SQL injection, XSS, and broken authentication vulnerabilities. For each vulnerability found, indicate severity (high/medium/low), affected line, and suggested fix."

Ask for specific details instead of "be as detailed as possible", which produces bloated responses with no direction.

## 4. Examples (Few-shot)

3-5 diverse examples covering normal and edge cases. Examples are the most effective way to guide output format and quality.

```xml
<examples>
<example>
<input>SELECT * FROM users WHERE id = ' + req.params.id</input>
<output>
**Vulnerability**: SQL Injection
**Severity**: High
**Line**: 23
**Fix**: Use parameterized queries: `SELECT * FROM users WHERE id = $1`
</output>
</example>
</examples>
```

- Include at least one edge case or difficult scenario.
- Vary examples so Claude generalizes instead of copying a single pattern.
- Keep format consistent across all examples.
- Align examples with the instructions: when they disagree, Claude follows the examples.

## 5. Output Format

Specify exactly what structure you expect. Without it, the format drifts between calls.

```xml
<output_format>
Respond in JSON with this structure:
{
  "vulnerabilities": [
    {
      "type": "string",
      "severity": "high|medium|low",
      "line": "number",
      "description": "string",
      "fix": "string"
    }
  ],
  "summary": "string",
  "risk_score": "number (1-10)"
}
</output_format>
```

## 6. Constraints / Guardrails

Define explicit boundaries, each stated as the behavior you want: a bare prohibition gives Claude nothing to do instead.

```xml
<constraints>
- Limit suggestions to security issues
- If no vulnerabilities are found, say "No vulnerabilities found"
- Base the analysis only on the provided code
- Report at most 5 vulnerabilities, ordered by severity
</constraints>
```

## XML tags

Claude reads XML tags as structural delimiters. Tag names are free: choose clear names and use them consistently, then refer to sections by name ("Follow the format in `<output_format>`").

| Use                      | Example                                       |
| ------------------------ | --------------------------------------------- |
| Separate prompt sections | `<role>`, `<instructions>`, `<constraints>`   |
| Delimit input data       | `<document>`, `<code>`, `<email>`             |
| Define output format     | `<output_format>`, `<response>`               |
| Group examples           | `<examples><example>...</example></examples>` |
| Isolate user content     | `<user_input>{{INPUT}}</user_input>`          |

Wrapping user content in its own tag keeps it apart from the instructions, which reduces prompt injection risk without eliminating it.
