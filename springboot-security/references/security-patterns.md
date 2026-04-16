# Spring Boot Security Patterns

## Permission Model

Authorization uses `@PreAuthorize` with a custom `PermissionEvaluator`:

```java
@PreAuthorize("@permissionEvaluator.hasPermission(authentication, 'READ_USERS')")
```

Permissions are defined in an enum:
```java
public enum AppPermission {
    READ_USERS,
    MANAGE_USERS,
    READ_ROLES,
    MANAGE_ROLES
}
```

Each role holds a set of permissions. The evaluator checks if the authenticated user's role includes the required permission.

## SecurityConfig Structure

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()   // public routes
                .anyRequest().authenticated()                      // everything else requires JWT
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }
}
```

## Key Files in `src/security/`

| File | Responsibility |
|---|---|
| `JwtService.java` | Generate and validate JWT tokens |
| `JwtFilter.java` | Intercept requests, extract token, set SecurityContext |
| `UserDetailsServiceImpl.java` | Load user from DB for Spring Security |

## Rules

- JWT secret and expiration always from env vars — never hardcoded
- `SessionCreationPolicy.STATELESS` — no sessions, JWT only
- Public routes declared explicitly in `SecurityConfig` — everything else is protected by default
- `@EnableMethodSecurity` required for `@PreAuthorize` to work
