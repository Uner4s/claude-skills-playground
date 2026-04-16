# Next.js Page Conventions

## Folder Structure

```
src/
├── app/
│   └── {route}/
│       └── page.tsx          ← Server component — renders the view, nothing else
├── views/
│   └── EntityName/           ← PascalCase folder
│       ├── index.tsx         ← "use client", logic + JSX, default export
│       ├── types.ts          ← All types and interfaces for this view
│       └── style.ts          ← Tailwind class groups (only if needed)
├── components/
│   └── ComponentName/
│       ├── index.tsx
│       ├── types.ts
│       └── style.ts
└── services/
    └── EntityService.ts      ← Pure functions, no React, no hooks
```

## Responsibility Rules

| Layer | Job | What it must NOT do |
|---|---|---|
| `page.tsx` | Render the view | Logic, state, data fetching |
| `views/` | UI logic + JSX | Call services directly |
| `services/` | HTTP calls | Any React code or hooks |
| `components/` | Reusable UI | Business logic |

## Patterns

**View with data:**
```tsx
"use client"
const { data, isLoading, error } = useQuery({
  queryKey: ['entity', param],
  queryFn: () => EntityService.getAll(param),
})
```

**Types — never inline:**
```ts
// types.ts
export type TEntityViewProps = Readonly<{ filter?: string }>
```

**Props — always Readonly:**
```tsx
export function MyView({ filter }: Readonly<TEntityViewProps>) { ... }
```

**style.ts — only when necessary:**
```ts
export const styles = {
  container: 'flex flex-col gap-4 p-6',
  title: 'text-2xl font-bold dark:text-white',
}
```

**State:**
- React Query → server state (fetched data)
- Jotai → shared global UI state
- Local `useState` → component-level UI only
