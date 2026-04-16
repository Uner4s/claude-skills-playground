---
name: commit
description: Use when creating a git commit, asked "commit my changes", "what should the commit message be", "how do I commit this", "stage and commit", "write a commit".
---

# Commit

**Rule:** One logical change per commit. If the message needs "and", split it into two commits.

## Format

```
type(scope): short description
```

**Types:** `feat` · `fix` · `refactor` · `chore` · `docs` · `test` · `style`

- Scope is optional — use it when the change is isolated to a specific module or layer
- Description: imperative mood, lowercase, no period, max 72 chars
- Example: `feat(auth): add JWT refresh token rotation`

## What to Stage

Only stage files directly related to this change. Never stage:
- `.env` or any file containing secrets or credentials
- Build artifacts (`dist/`, `build/`, `.next/`, `target/`)
- Auto-generated files unless the commit is specifically about them

## Before Committing

1. Run `git diff --staged` — verify only the expected files are included
2. If unrelated changes appear in the working tree, stash them or commit separately
3. Check the message against the format — one type, one scope, one action
