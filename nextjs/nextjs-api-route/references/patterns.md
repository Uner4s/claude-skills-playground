# Next.js API Route vs Server Action

## When to use each

| Scenario | Use |
|---|---|
| External API consumed by mobile / other services | API Route |
| Frontend-only form mutation or button action | Server Action |
| Webhook receiver | API Route |
| Data mutation from a Client Component | Server Action |
| Needs custom headers or HTTP status codes | API Route |

## API Route structure

```
app/
└── api/
    └── {resource}/
        ├── route.ts          ← GET, POST handlers
        └── [id]/
            └── route.ts      ← GET by id, PATCH, DELETE
```

```ts
// app/api/users/route.ts
import { NextResponse } from 'next/server'

export async function GET() {
  try {
    const data = await db.user.findMany()
    return NextResponse.json({ success: true, data }, { status: 200 })
  } catch {
    return NextResponse.json({ success: false, error: 'Internal error' }, { status: 500 })
  }
}

export async function POST(request: Request) {
  const body = await request.json()
  // validate body before processing
}
```

## Server Action structure

```ts
// app/users/actions.ts
"use server"
import { revalidatePath } from 'next/cache'

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string
  // validate
  await db.user.create({ data: { name } })
  revalidatePath('/users')
  return { success: true }
}
```

## Rules

- API routes: always explicit status codes, always catch errors, never leak internals
- Server Actions: always `revalidatePath` after mutations, return typed result objects
- No GraphQL — REST only
- `process.env` only in server-side code — never in Client Components without `NEXT_PUBLIC_` prefix
