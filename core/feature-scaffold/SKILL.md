---
name: feature-scaffold
description: Use when creating a new feature, module, or domain from scratch. Use when asked "scaffold a users module", "create a new feature", "add a new domain", "create module for X", "new feature called X".
---

# Feature Scaffold

**Rule:** Copy the pattern that already exists — never invent structure from scratch.

## Steps

1. Run project-scan to understand the actual project state:
   ```bash
   bash ~/.claude/skills/core/project-scan/scripts/scan.sh
   ```

2. Identify the existing module closest to what you're building — use it as reference.
   Look at: folder structure, file naming, how imports are organized.

3. List what the new feature needs based on what you found:
   - Files to create (same naming as reference, different domain only)
   - Registrations required (module imports, decorators, DI)
   - Cross-cutting concerns to connect (guards, filters, pipes)

4. Create files in the exact same structure as the reference module.
   If reference has `users/dto/`, new module has `{domain}/dto/`.

5. Register the new module exactly where and how existing ones are registered.
