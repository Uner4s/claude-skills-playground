---
name: springboot-domain
description: Use when adding a new Spring Boot domain or feature. Use when asked "create a users domain", "add a new entity", "scaffold Spring Boot feature for X", "new endpoint for X in Spring Boot", "add domain".
---

# Spring Boot Domain Scaffold

**Rule:** One class per responsibility. Never put logic in controllers, never map manually in services — always MapStruct.

## Before Starting

1. Run project-scan to check existing domain structure:
   ```bash
   bash ~/.claude/skills/core/project-scan/scripts/scan.sh
   ```
2. Load `references/conventions.md` — structure, naming, and patterns

## Steps

1. **Identify database** — JPA (SQL) or MongoDB (check `pom.xml` and `config/`)

2. **Create files** in this order:
   - Entity / Document
   - Repository interface
   - Request + Response DTOs (in `dtos/request/` and `dtos/response/`)
   - MapStruct Mapper
   - Service
   - Controller

3. **Naming** — `PascalCase` for all classes. DTOs: `CreateEntityRequest`, `GetEntityResponse`

4. **Controller** — returns `ResponseEntity<ApiResponse<T>>`. Constructor injection only. Logic only in services.

5. **Service** — `@Transactional` on write methods (SQL). Throw `ApiException` for controlled errors. Use mapper for all conversions.

6. **Test** — unit test for service (`EntityServiceTest`) mocking the repository with Mockito.
