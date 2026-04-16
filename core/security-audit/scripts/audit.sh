#!/bin/bash
# audit.sh — Pre-deploy security audit
# Covers: NestJS, Spring Boot, ASP.NET Core, Django

PASS=0; WARN=0; FAIL=0

ok()   { echo "  ✓  $1"; PASS=$((PASS+1)); }
warn() { echo "  ⚠  $1"; WARN=$((WARN+1)); }
fail() { echo "  ✗  $1"; FAIL=$((FAIL+1)); }

echo "=== SECURITY AUDIT ==="
echo "Path: $(pwd)"
echo ""

# ── Detect framework ──────────────────────────────────────────────────────────
FRAMEWORK="unknown"
if ls *.csproj 2>/dev/null | grep -q "." || ls *.sln 2>/dev/null | grep -q "."; then
    FRAMEWORK="dotnet"
elif [ -f "pom.xml" ]; then
    FRAMEWORK="springboot"
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    FRAMEWORK="springboot"
elif [ -f "manage.py" ]; then
    FRAMEWORK="django"
elif [ -f "package.json" ]; then
    grep -q '"@nestjs/core"' package.json && FRAMEWORK="nestjs" || FRAMEWORK="node"
fi
echo "Framework : $FRAMEWORK"
echo ""

# ── 1. Hardcoded secrets ──────────────────────────────────────────────────────
echo "## Secrets"
SECRET_HITS=$(grep -rniE "(secret|password|api_key|private_key)\s*[=:]\s*['\"][^'\"]{8,}" \
    --include="*.ts" --include="*.java" --include="*.cs" --include="*.py" \
    --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist \
    --exclude-dir=build --exclude-dir=target --exclude-dir=obj \
    . 2>/dev/null | grep -vE "\.example|\.test\.|\.spec\.|_test\.|test_" | head -5)

if [ -z "$SECRET_HITS" ]; then
    ok "No hardcoded secrets detected"
else
    fail "Possible hardcoded secrets found:"
    echo "$SECRET_HITS" | while IFS= read -r line; do echo "       $line"; done
fi

# ── 2. CORS wildcard ──────────────────────────────────────────────────────────
echo ""
echo "## CORS"
CORS_WILDCARD=""
case $FRAMEWORK in
    nestjs)     CORS_WILDCARD=$(grep -rn "origin:\s*['\"]\\*['\"]" src/ 2>/dev/null | head -3) ;;
    django)     CORS_WILDCARD=$(grep -rn "CORS_ALLOW_ALL_ORIGINS\s*=\s*True" . 2>/dev/null | grep -v "^\s*#" | head -3) ;;
    springboot) CORS_WILDCARD=$(grep -rn "allowedOrigins(\"\\*\")" src/ 2>/dev/null | head -3) ;;
    dotnet)     CORS_WILDCARD=$(grep -rn "AllowAnyOrigin()" . --include="*.cs" 2>/dev/null | head -3) ;;
esac

if [ -z "$CORS_WILDCARD" ]; then
    ok "No CORS wildcard detected"
else
    fail "CORS wildcard found — not safe for production:"
    echo "$CORS_WILDCARD" | while IFS= read -r line; do echo "       $line"; done
fi

# ── 3. Rate limiting ──────────────────────────────────────────────────────────
echo ""
echo "## Rate Limiting"
case $FRAMEWORK in
    nestjs)
        grep -q '"@nestjs/throttler"' package.json 2>/dev/null \
            && ok "@nestjs/throttler present" \
            || fail "@nestjs/throttler not found — add rate limiting before deploying" ;;
    django)
        grep -rq "DEFAULT_THROTTLE_CLASSES\|DEFAULT_THROTTLE_RATES" . 2>/dev/null \
            && ok "DRF throttling configured" \
            || warn "No throttle classes found in REST_FRAMEWORK settings" ;;
    springboot)
        grep -q "bucket4j" pom.xml build.gradle build.gradle.kts 2>/dev/null \
            && ok "bucket4j dependency present" \
            || warn "No rate limiting dependency found (bucket4j recommended)" ;;
    dotnet)
        grep -rq "AddRateLimiter\|UseRateLimiter" . --include="*.cs" 2>/dev/null \
            && ok "Rate limiting middleware configured" \
            || warn "No rate limiting found — add AddRateLimiter before deploying" ;;
    *) warn "Unknown framework — verify rate limiting manually" ;;
esac

# ── 4. Security headers ───────────────────────────────────────────────────────
echo ""
echo "## Security Headers"
case $FRAMEWORK in
    nestjs)
        grep -q '"helmet"' package.json 2>/dev/null || grep -rq "helmet" src/ 2>/dev/null \
            && ok "helmet present" \
            || fail "helmet not found — add app.use(helmet()) in main.ts" ;;
    django)
        grep -rq "SECURE_CONTENT_TYPE_NOSNIFF\|SECURE_BROWSER_XSS_FILTER" . 2>/dev/null \
            && ok "SECURE_* settings configured" \
            || warn "Missing SECURE_* settings in settings.py" ;;
    springboot)
        ok "Spring Security enables core headers by default — verify HSTS is set for HTTPS deployments" ;;
    dotnet)
        grep -rq "UseHsts\|X-Content-Type-Options" . --include="*.cs" 2>/dev/null \
            && ok "Security headers configured" \
            || warn "UseHsts() or security headers not found in Program.cs" ;;
esac

# ── 5. Unprotected controllers ────────────────────────────────────────────────
echo ""
echo "## Controllers"
case $FRAMEWORK in
    nestjs)
        while IFS= read -r ctrl; do
            base=$(basename "$ctrl")
            echo "$base" | grep -qi "auth\|public" && continue
            grep -qE "@UseGuards|@Public\(\)" "$ctrl" 2>/dev/null \
                && ok "$base — explicit guard or @Public()" \
                || ok "$base — relies on global JwtAuthGuard"
        done < <(find src/ -name "*.controller.ts" 2>/dev/null) ;;
    springboot)
        while IFS= read -r ctrl; do
            base=$(basename "$ctrl")
            echo "$base" | grep -qi "auth\|Auth" && continue
            grep -qE "@RestController|@Controller" "$ctrl" 2>/dev/null || continue
            grep -q "@PreAuthorize" "$ctrl" 2>/dev/null \
                && ok "$base — @PreAuthorize present" \
                || warn "$base — no @PreAuthorize (relies on anyRequest().authenticated() only)" && FAIL=$((FAIL+1))
        done < <(find src/ -name "*Controller.java" 2>/dev/null) ;;
    dotnet)
        while IFS= read -r ctrl; do
            base=$(basename "$ctrl")
            echo "$base" | grep -qi "auth\|Auth" && continue
            grep -qE "ControllerBase|: Controller\b" "$ctrl" 2>/dev/null || continue
            grep -qE "\[AuthorizePermissions|\[Authorize\]" "$ctrl" 2>/dev/null \
                && ok "$base — authorization attribute present" \
                || warn "$base — no [AuthorizePermissions] found"
        done < <(find . -name "*Controller.cs" -not -path "*/obj/*" 2>/dev/null) ;;
    django)
        while IFS= read -r view; do
            base=$(basename "$view")
            grep -qE "class .+(APIView|ViewSet)" "$view" 2>/dev/null || continue
            grep -q "permission_classes" "$view" 2>/dev/null \
                && ok "$base — permission_classes present" \
                || warn "$base — no explicit permission_classes (relies on DEFAULT_PERMISSION_CLASSES)"
        done < <(find . -name "views.py" -not -path "*/.git/*" 2>/dev/null) ;;
esac

# ── 6. Env completeness ───────────────────────────────────────────────────────
echo ""
echo "## Environment"
bash ~/.claude/skills/core/env-check/scripts/check-env.sh 2>/dev/null \
    || ok "No .env.example — skip env check"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "══════════════════════════════════════"
printf "  ✓ %d passed   ⚠ %d warnings   ✗ %d failed\n" $PASS $WARN $FAIL
echo "══════════════════════════════════════"

if [ $FAIL -gt 0 ]; then
    echo "  Fix all failures before deploying."
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "  Review warnings before deploying."
    exit 0
else
    echo "  All checks passed."
    exit 0
fi
