---
name: project-scan
description: Use before modifying, scaffolding, or refactoring code. Use when asked "analyze this project", "scan the project", "what's the structure here", "what do we have", "understand the codebase", "project overview". Always run at the start of a session on an unfamiliar project or after a long context gap.
---

# Project Scan

**Rule:** CLAUDE.md tells you the rules — this scan tells you the reality. Never assume structure from conventions alone.

## When to Run

- Before scaffolding a new module, feature, or component
- Before refactoring existing code
- At the start of a new session on any project
- After a long context gap (switched tasks, new chat)

## Steps

1. Run the scan:
   ```bash
   bash ~/.claude/skills/core/project-scan/scripts/scan.sh
   ```

2. From the output, identify:
   - **Stack** — framework and runtime detected
   - **Source layout** — where code actually lives
   - **Existing modules/domains** — what's already built
   - **Test structure** — if tests exist and where

3. Cross-reference with CLAUDE.md — confirm the actual structure matches the expected conventions

4. Only after completing steps 1–3, proceed with the requested task
