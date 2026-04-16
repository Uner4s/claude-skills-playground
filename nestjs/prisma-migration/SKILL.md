---
name: prisma-migration
description: Use when modifying the database schema with Prisma. Use when asked "create a migration", "add a field to the schema", "apply migrations", "prisma migrate", "update the database schema", "new column", "new model in Prisma".
---

# Prisma Migration

**Rule:** Never modify the database directly. Always: `schema.prisma` → migration → deploy → generate.

## Creating a migration (dev only)

1. Modify `prisma/schema.prisma` — make only the intended changes, nothing extra
2. Generate and apply:
   ```bash
   npx prisma migrate dev --name descriptive_migration_name
   ```
3. Regenerate the client:
   ```bash
   npx prisma generate
   ```
4. Restart the dev server — the client must be fresh before use

## Applying to production

```bash
npx prisma migrate deploy
```
Never run `migrate dev` against a production database — it may reset data.

## After any schema change

Run `test-runner` to confirm no existing queries broke:
```bash
bash ~/.claude/skills/core/test-runner/scripts/run-tests.sh
```

## Safety rules

- Migration names must be descriptive: `add_refresh_token_to_user`, not `update1`
- To remove a column with live data: rename first in one migration, remove in a separate one
- If `migrate dev` fails mid-way: check `prisma/_migrations/` for a failed migration and resolve before retrying
