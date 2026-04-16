---
name: nestjs-auth-guard
description: Use when implementing auth or authorization in NestJS. Use when asked "add auth guard", "protect this endpoint", "JWT auth", "add permissions to route", "role-based access", "CASL permissions", "secure this controller".
---

# NestJS Auth Guard

**Rule:** Before writing any guard, confirm which permission strategy the project uses. Never mix strategies in the same project.

## Before Starting

1. Check what already exists in `src/auth/` and `src/security/`:
   ```bash
   bash ~/.claude/skills/project-scan/scripts/scan.sh
   ```
2. Load `references/strategies.md` — the two available strategies

## Steps

### Adding to an existing auth setup
1. Follow the exact same guard and decorator pattern already in the project
2. Never create a second auth module — extend the existing one

### Setting up auth from scratch
1. **Ask first:** "Does this project need simple role-based guards or dynamic permission-based (CASL)?"
2. Implement the chosen strategy fully before writing any feature code
3. Place everything in `src/auth/` — JWT guard, strategy, decorators, and types
4. Configure `JwtModule.registerAsync` with env-based secret in `auth.module.ts`
5. Register `JwtAuthGuard` as a global guard in `AppModule` — opt-out with `@Public()` decorator
