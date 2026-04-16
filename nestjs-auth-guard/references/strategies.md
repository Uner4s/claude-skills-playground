# NestJS Auth Strategies

## Strategy 1 — Simple role-based

Use for small or low-complexity projects with few user types and static roles.

```
src/auth/
├── auth.module.ts
├── auth.service.ts
├── auth.controller.ts
├── jwt.strategy.ts
├── jwt-auth.guard.ts
├── roles.guard.ts
├── decorators/
│   ├── public.decorator.ts     ← @Public() bypasses JwtAuthGuard
│   ├── roles.decorator.ts      ← @Roles('admin', 'user')
│   └── current-user.decorator.ts
└── types/
    └── jwt-payload.type.ts
```

**When to use:** few user types, access rules unlikely to change, speed matters more than flexibility.

---

## Strategy 2 — CASL permission-based

Use for projects with many user types, dynamic permissions, or admin-controlled access rules.

```
src/auth/
├── auth.module.ts
├── auth.service.ts
├── auth.controller.ts
├── jwt.strategy.ts
├── jwt-auth.guard.ts
├── casl/
│   ├── casl-ability.factory.ts  ← builds the ability for each user
│   └── policies.guard.ts        ← checks policies on each request
├── decorators/
│   ├── public.decorator.ts
│   ├── check-policies.decorator.ts
│   └── current-user.decorator.ts
└── types/
    ├── jwt-payload.type.ts
    └── app-ability.type.ts
```

**Core concept:** focus shifts from `user.role === 'admin'` to `user.can('update', Post)`.
A role is just a named set of permissions — permissions are what matter.

**When to use:** multi-tenant, complex access rules, or permissions managed at runtime from an admin panel.

---

## Decision rule

Ask at project setup — do not assume:
> "Does this project need simple role-based guards, or dynamic permission-based authorization with CASL?"

The answer must define the folder structure before any feature code is written.
