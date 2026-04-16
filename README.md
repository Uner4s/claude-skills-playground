# claude-skills-playground

A personal collection of [Claude Code](https://claude.ai/code) skills focused on enforcing a consistent and clean git workflow across projects.

Skills are concise by design — each one has a single clear rule, concrete steps, and nothing more. No fluff, no overengineering.

---

## What are Claude Code skills?

Skills are instruction files that Claude Code loads to change how it behaves in specific situations. When you ask Claude to do something that matches a skill's trigger, it follows the skill's rules instead of its default behavior.

Skills follow a priority order:

| Layer | Location | When it applies |
|---|---|---|
| Enterprise | Managed by org | All repos in the org |
| **Personal** | `~/.claude/skills/` | All your projects |
| Project | `.claude/skills/` in repo | That repo only |
| Plugin | Installed via marketplace | If installed |

The skills in this repo live at the **Personal** layer — they apply globally across all your projects once installed.

---

## Skills

### `commit`
Enforces conventional commit format (`feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`) with rules on what to stage, message structure, and when to split commits.

> **Core rule:** One logical change per commit. If the message needs "and", split it.

### `pull-request`
Provides a body template per PR type (`feat`, `fix`, `refactor`, `chore`). Every PR must answer two questions: what changed and how to verify it.

> **Core rule:** If a reviewer can't test it from the body alone, rewrite it.

### `branch-health`
A five-step sequence to verify a branch is clean before pushing or opening a PR: local status, remote sync, missing commits, ahead commits, and conflict preview.

> **Core rule:** Always run this before opening a PR. Never assume your branch is clean.

### `skill-creator`
A meta-skill — the rules for writing new skills in this collection. Covers structure, length limits, description guidelines, and the quality test every skill must pass.

> **Core rule:** A skill that doesn't change behavior is not a skill — it's a comment.

---

## Installation

Copy the skill folders into your personal Claude Code skills directory:

```bash
cp -r commit branch-health pull-request skill-creator ~/.claude/skills/
```

> `~/.claude/skills/` is the Personal layer — skills installed here apply to all your projects.

---

## Design principles

- **Max 60 lines** per `SKILL.md` — if it needs more, it should be two skills
- **One core rule** per skill, visible at the top
- **Executable steps** — "run `git status`", not "check the repo state"
- **No fluff** — no Overview, Background, or Introduction sections
- **English only**
- Skills are meant to work together: `branch-health` → `commit` → `pull-request` is the natural flow

---

## Branching note

These personal skills default to `main` as the base branch. For multi-environment projects (`develop → staging → main`), define a project-level or enterprise-level override with the appropriate branching rules.
