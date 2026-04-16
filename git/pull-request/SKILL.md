---
name: pull-request
description: Use when creating a pull request, asked "open a PR", "write a PR", "PR description", "pull request template", "create PR for this feature/fix/refactor/chore".
---

# Pull Request

**Rule:** The body must answer two questions: *what changed* and *how to verify it*. If a reviewer can't test it from the body alone, rewrite it.

## Title

```
type(scope): short description
```

Same types as commits: `feat` · `fix` · `refactor` · `chore`

---

## Templates

### feat — New Feature
```
## What
- [What capability was added]

## Why
- [Business or technical reason]

## How to verify
- [ ] [Happy path step]
- [ ] [Edge case or error state to check]
```

### fix — Bug Fix
```
## What broke
- [Description of the bug and its impact]

## Root cause
- [What was causing it]

## How to verify
- [ ] [Reproduce the bug — confirm old behavior]
- [ ] [Confirm fix — confirm new behavior]
```

### refactor — Structural Change
```
## What changed
- [Structural or architectural changes made]

## What did NOT change
- [Behavior that remains identical — reassure the reviewer]

## How to verify
- [ ] [Existing tests pass]
- [ ] [Specific behavior to manually confirm]
```

### chore — Maintenance
```
## What
- [Dependency update / config change / tooling]

## Impact on other devs
- [What they need to do after merging, if anything]
```

---

## Before Opening

- Run `branch-health` first — never open a PR from a dirty branch
- Every PR should be reviewable in under 15 minutes — if not, split it

> **Personal projects:** targets `main` by default.
> **Multi-environment projects** (develop → staging → main): define a project-level or enterprise-level override of this skill with the appropriate branching rules.
