---
name: branch-health
description: Use when checking branch status, asked "am I up to date", "check my branch", "any conflicts with main", "is my branch behind", "branch health check", "sync with main", "what's missing in my branch".
---

# Branch Health

**Rule:** Always run this before opening a PR or pushing. Never assume your branch is clean.

## Check Sequence

Run in order — stop and fix if any step shows a problem:

1. **Local status** — uncommitted or untracked changes
   ```bash
   git status
   ```

2. **Fetch + compare against remote** — updates refs without merging
   ```bash
   git fetch origin
   git status -sb
   ```

3. **Commits missing from your branch** — what main has that you don't
   ```bash
   git log HEAD..origin/main --oneline
   ```

4. **Your commits not yet in main** — what you'd be pushing
   ```bash
   git log origin/main..HEAD --oneline
   ```

5. **Conflict preview** — dry-run merge, always abort after
   ```bash
   git merge --no-commit --no-ff origin/main
   git merge --abort
   ```

## Reading Results

- **Behind main** → rebase before continuing: `git pull --rebase origin main`
- **CONFLICT detected** → resolve conflicts before pushing
- **Ahead with no conflicts** → branch is ready

> Replace `main` with `master` or `develop` depending on the project's base branch.
