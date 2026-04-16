# Spring Boot Domain Conventions

## File Structure

```
src/main/java/com/company/project/
├── controllers/
│   └── UserController.java
├── services/
│   └── UserService.java
├── repositories/
│   └── UserRepository.java          ← extends JpaRepository or MongoRepository
├── entities/                         ← SQL only (@Entity)
│   └── User.java
├── documents/                        ← Mongo only (@Document)
│   └── User.java
├── dtos/
│   ├── request/
│   │   ├── CreateUserRequest.java
│   │   └── UpdateUserRequest.java
│   └── response/
│       └── GetUserResponse.java
└── mappers/
    └── UserMapper.java               ← MapStruct interface
```

## Naming Rules

| Element | Pattern | Example |
|---|---|---|
| Entity / Document | `PascalCase` (no suffix) | `User`, `AuditLog` |
| Repository | `Entity` + `Repository` | `UserRepository` |
| Service | `Entity` + `Service` | `UserService` |
| Controller | `Entity` + `Controller` | `UserController` |
| Mapper | `Entity` + `Mapper` | `UserMapper` |
| Request DTO | `Action` + `Entity` + `Request` | `CreateUserRequest` |
| Response DTO | `Action` + `Entity` + `Response` | `GetUserResponse` |

## Key Rules

**Entity (SQL):**
- Extend `BaseEntity` — inherits id (UUID), createdAt, updatedAt, isDeleted
- `@Enumerated(EnumType.STRING)` — never store enums as integers
- Relationships: always `FetchType.LAZY` — never EAGER
- Never `CascadeType.ALL` — be explicit

**Repository:**
- Interface only — Spring Data generates queries from method names
- Complex queries: `@Query` with JPQL (SQL) or JSON (Mongo)

**Service:**
- `@Transactional` on write methods (SQL only)
- `throw new ApiException("message", HttpStatus.XXX)` for controlled errors — never return null to signal failure
- All entity ↔ DTO conversions via MapStruct mapper — never map manually

**Controller:**
- `@RestController` + `@RequestMapping("/api/v1/entity")`
- `@RequiredArgsConstructor` — constructor injection only, never `@Autowired` on fields
- Always return `ResponseEntity<ApiResponse<T>>`
- Protect routes with `@PreAuthorize` — see `springboot-security` skill
