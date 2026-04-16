---
name: nestjs-module
description: Use when adding a new NestJS module or domain. Use when asked "create a users module", "add a new domain", "scaffold module for X", "new endpoint for X in NestJS", "add NestJS feature".
---

# NestJS Module Scaffold

**Rule:** Every module is self-contained. Files, naming, and structure must match existing modules exactly — no improvising.

## Before Starting

1. Run project-scan to understand current structure:
   ```bash
   bash ~/.claude/skills/core/project-scan/scripts/scan.sh
   ```
2. Load `references/conventions.md` — structure and naming rules

## Steps

1. **Identify the ORM** — Mongoose, TypeORM, or Prisma (check existing modules or `package.json`)

2. **Create module files** following the structure in `references/conventions.md` for the detected ORM

3. **Naming** — `kebab-case` for files, `PascalCase` for classes, `Dto` suffix for DTOs, `I` prefix for interfaces, `T` for types

4. **DTOs** — validate all inputs with `class-validator`. Validation messages in Spanish.

5. **Responses** — all endpoints return `ApiResponseDto<T>`. Never return raw entities or documents.

6. **Register** — import the module in `AppModule`. Export only services other modules may need.

7. **Test** — create `{domain}.service.spec.ts` mocking all external dependencies.
