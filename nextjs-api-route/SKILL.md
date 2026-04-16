---
name: nextjs-api-route
description: Use when creating a Next.js API route or Server Action. Use when asked "create an API route", "add a server action", "backend endpoint in Next.js", "API handler for X", "server-side function for X".
---

# Next.js API Route / Server Action

**Rule:** API routes are for external consumers. Server Actions are for form mutations within the app. Choose one, don't mix them for the same operation.

## Before Starting

Load `references/patterns.md` — when to use routes vs Server Actions, and structure for each.

## API Route (`app/api/`)

1. Create `app/api/{resource}/route.ts`
2. Export named functions per HTTP method: `GET`, `POST`, `PATCH`, `DELETE`
3. Always return `NextResponse.json(...)` with an explicit status code
4. Validate input before processing — use `zod` or manual checks
5. Never expose internal errors to the client — catch and return a clean message

```ts
// app/api/users/route.ts
export async function GET(request: Request) {
  try {
    const users = await UserService.getAll()
    return NextResponse.json({ success: true, data: users }, { status: 200 })
  } catch {
    return NextResponse.json({ success: false, error: 'Failed to fetch users' }, { status: 500 })
  }
}
```

## Server Action

1. Create or add to `app/{route}/actions.ts` — `"use server"` at the top
2. Use for form submissions and mutations triggered from Client Components
3. Return a typed result — never throw raw errors to the client
4. Revalidate affected cache paths with `revalidatePath`
