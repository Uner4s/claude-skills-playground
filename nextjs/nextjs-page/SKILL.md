---
name: nextjs-page
description: Use when creating a new Next.js page, view, or screen. Use when asked "create a users page", "add a new page", "scaffold a view for X", "new screen for X in Next.js", "create the dashboard page".
---

# Next.js Page Scaffold

**Rule:** Pages only render views. Views only render components. Services only talk to the API. Never mix these responsibilities.

## Before Starting

1. Run project-scan to check `src/app/` and `src/views/` structure:
   ```bash
   bash ~/.claude/skills/project-scan/scripts/scan.sh
   ```
2. Load `references/conventions.md` — structure, naming, and patterns

## Steps

1. **Create the page** — `app/{route}/page.tsx`, server component, no `"use client"`:
   ```tsx
   import { MyView } from '@/views/MyView'
   export default function Page() { return <MyView /> }
   ```

2. **Create the view** in `views/MyView/`:
   - `index.tsx` — `"use client"`, logic and JSX, default export
   - `types.ts` — all types and interfaces, never inline in component
   - `style.ts` — only if multiple variants or long class strings exist

3. **Data fetching** — always through React Query in the view, never direct service calls in JSX

4. **Service** — if new entity, create `services/EntityService.ts`: pure functions, explicit types, REST only

5. **Naming** — `PascalCase` folders, `camelCase` functions, `T` prefix for types, `I` for interfaces
