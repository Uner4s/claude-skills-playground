---
name: springboot-security
description: Use when protecting a Spring Boot endpoint or setting up JWT auth. Use when asked "protect this endpoint", "add security to route", "JWT in Spring Boot", "add @PreAuthorize", "secure this controller", "Spring Security setup".
---

# Spring Boot Security

**Rule:** Every endpoint must be explicitly protected. No endpoint is public unless declared with `permitAll()` in `SecurityConfig`.

## Before Starting

1. Check existing security setup in `src/security/` and `src/config/SecurityConfig.java`:
   ```bash
   bash ~/.claude/skills/project-scan/scripts/scan.sh
   ```
2. Load `references/security-patterns.md` — permission model and guard patterns

## Steps

### Protecting an existing endpoint

1. Add `@PreAuthorize` to the controller method:
   ```java
   @PreAuthorize("@permissionEvaluator.hasPermission(authentication, 'PERMISSION_NAME')")
   ```
2. Verify the permission exists in the `AppPermission` enum
3. Confirm the permission is assigned to the correct roles in the seeder or config

### Setting up JWT from scratch

1. Add dependencies: `spring-boot-starter-security`, `jjwt-api`, `jjwt-impl`, `jjwt-jackson`
2. Create in `src/security/`: `JwtFilter`, `JwtService`, `UserDetailsServiceImpl`
3. Create `SecurityConfig` in `src/config/` — define the filter chain and public routes
4. Add `JWT_SECRET` and `JWT_EXPIRATION` to `application.yml` via env vars — never hardcode
5. Run `env-check` to confirm vars are set:
   ```bash
   bash ~/.claude/skills/core/env-check/scripts/check-env.sh
   ```
