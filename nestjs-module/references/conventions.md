# NestJS Module Conventions

## Structure by ORM

### Mongoose / TypeORM
```
{domain}/
├── dto/
│   ├── create-{domain}.dto.ts
│   └── update-{domain}.dto.ts
├── {domain}.module.ts
├── {domain}.service.ts
├── {domain}.controller.ts
├── {domain}.repository.ts    ← TypeORM only
└── {domain}.schema.ts        ← Mongoose: Schema | TypeORM: entity.ts
```

### Prisma (no repository layer)
```
{domain}/
├── dto/
│   ├── create-{domain}.dto.ts
│   └── update-{domain}.dto.ts
├── {domain}.module.ts
├── {domain}.service.ts        ← injects PrismaService directly
└── {domain}.controller.ts
```

## Naming Rules

| Element | Pattern | Example |
|---|---|---|
| Files | `kebab-case` | `users.service.ts` |
| Classes | `PascalCase` | `UsersService` |
| DTOs | `PascalCase` + `Dto` | `CreateUserDto` |
| Interfaces | `I` + PascalCase | `IAuthPayload` |
| Types | `T` + PascalCase | `TJwtPayload` |

## Required Patterns

**Response shape** — always wrap in `ApiResponseDto<T>`:
```ts
return { success: true, data: result }
```

**Module export** — explicit, never wildcard:
```ts
@Module({
  providers: [UsersService],
  exports: [UsersService],   // only what other modules need
})
```

**`common/`** — only for code used in 3+ modules. Single-use code stays in its own module.

**Split controllers/services** when a module has distinct flows (admin vs user, read vs write) or a file exceeds ~150 lines.
