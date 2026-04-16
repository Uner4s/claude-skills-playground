---
name: env-check
description: Use before running the project locally, asked "check my env", "env vars ok?", "is my .env complete", "missing env vars", "why is the app not starting", "setup environment".
---

# Env Check

**Rule:** A missing env var causes silent failures at runtime. Check before you run, not after it breaks.

## Steps

1. Run the check:
   ```bash
   bash ~/.claude/skills/env-check/scripts/check-env.sh
   ```

2. For each `MISSING` variable reported:
   - Check the project README or docs for the expected value
   - If it's a secret (API key, token, password) — ask the team, never invent values
   - If it has a safe local default — add it with a comment explaining what it is

3. Re-run after filling the gaps to confirm the env is complete before starting the server.
