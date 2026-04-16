# claude-skills-playground

Personal [Claude Code](https://claude.ai/code) skills and hooks — git workflow, code quality automation, security checks, and framework-specific scaffolding.

Concise by design. Every skill has one rule, concrete steps, and nothing more.

---

## Skills vs Hooks

**Skills** — activated when you ask Claude something. Change how it responds.
**Hooks** — run automatically on Claude Code events. Execute shell commands without being asked.

Skills live at `~/.claude/skills/` (Personal layer — all your projects).
Hooks live at `~/.claude/hooks/` + configured in `~/.claude/settings.json`.

---

## Skills

### `git/`
| Skill | Core rule |
|---|---|
| `commit` | One logical change per commit. If the message needs "and", split it. |
| `pull-request` | If a reviewer can't test it from the body alone, rewrite it. |
| `branch-health` | Always run before opening a PR. Never assume your branch is clean. |

### `core/`
| Skill | What it does |
|---|---|
| `skill-creator` | Rules for writing new skills in this collection |
| `project-scan` | Scans stack, source structure, modules, and tests before touching code |
| `feature-scaffold` | Copies the pattern that already exists — never invents structure |
| `test-runner` | Detects the framework and runs tests with the correct command |
| `env-check` | Compares `.env` against `.env.example` and reports missing vars |
| `security-audit` | Pre-deploy batch check: secrets, CORS, rate limiting, headers, controllers |

### `nestjs/`
| Skill | What it does |
|---|---|
| `nestjs-module` | Scaffold a full module (ORM-aware: Mongoose / TypeORM / Prisma) |
| `nestjs-auth-guard` | JWT setup + role-based vs CASL strategy decision |
| `prisma-migration` | Safe schema change workflow: migrate dev → generate → test |

### `springboot/`
| Skill | What it does |
|---|---|
| `springboot-domain` | Scaffold a full domain (entity, repo, DTOs, mapper, service, controller) |
| `springboot-security` | Protect endpoints with `@PreAuthorize` or set up JWT from scratch |

### `nextjs/`
| Skill | What it does |
|---|---|
| `nextjs-page` | page → view → service scaffold with App Router conventions |
| `nextjs-api-route` | API Route vs Server Action decision + structure |

---

## Hooks

### `hooks/ts-eslint.sh`
**Trigger:** `PostToolUse` — after `Edit`, `Write`, `MultiEdit` on `.ts` / `.tsx`
Runs ESLint on the file Claude just edited. Only in TypeScript projects (`tsconfig.json` must exist).

### `hooks/ts-typecheck.sh`
**Trigger:** `Stop` — when Claude finishes responding
Runs `tsc --noEmit` on the full project. Only in TypeScript projects.

### `hooks/security-check.sh`
**Trigger:** `PostToolUse` — after `Edit`, `Write`, `MultiEdit` on any file
Checks controller files for missing security decorators (NestJS, Spring Boot, .NET, Django). Detects possible hardcoded secrets in any file.

---

## Installation

### Skills
```bash
cp -r git core nestjs springboot nextjs ~/.claude/skills/
```

### Hooks
```bash
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

Add the config from `hooks/settings.snippet.json` into `~/.claude/settings.json`.

---

## Design principles

- **Max 60 lines** per `SKILL.md` — if it needs more, split into two skills
- **One core rule** per skill, visible at the top
- **Executable steps** — `run git status`, not "check the repo state"
- **No fluff** — no Overview, Background, or Introduction sections
- **English only**
- `scripts/` for executable code · `references/` for framework conventions · `assets/` for templates

---

## Branching note

Personal skills default to `main`. For multi-environment projects (`develop → staging → main`), define a project-level or enterprise-level override.
