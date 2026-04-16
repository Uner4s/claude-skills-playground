#!/bin/bash
# Hook: PostToolUse — Security check on controller/view files
#
# Verifies that controllers have proper security decorators after every edit.
# Covers: NestJS, Spring Boot, ASP.NET Core, Django
# Triggered after: Edit, Write, MultiEdit

INPUT=$(cat)
FILE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

[ -z "$FILE" ] && exit 0
[ -f "$FILE" ]  || exit 0

warn() { echo "⚠  SECURITY: $1"; }
ok()   { echo "▸  security-check: $1"; }

is_auth_file() { echo "$1" | grep -qiE "auth|login|register|public"; }

# ── NestJS — *.controller.ts ─────────────────────────────────────────────────
if [[ "$FILE" =~ \.controller\.ts$ ]]; then
    if ! is_auth_file "$FILE"; then
        # Class-level @Public() on a non-auth controller is a smell
        if grep -qE "^@Public\(\)" "$FILE" 2>/dev/null; then
            warn "@Public() at class level in non-auth controller: $(basename $FILE)"
            warn "Move public routes to auth.controller.ts — never mix public and protected in the same controller"
        fi
    fi

    # No guards, no @Public() → relies on global JwtAuthGuard → OK
    if ! grep -qE "@UseGuards|@Public\(\)" "$FILE" 2>/dev/null; then
        ok "$(basename $FILE) — protected by global JwtAuthGuard"
    fi
fi

# ── Spring Boot — *Controller.java ───────────────────────────────────────────
if [[ "$FILE" =~ Controller\.java$ ]]; then
    if grep -qE "@RestController|@Controller" "$FILE" 2>/dev/null; then
        if ! is_auth_file "$FILE"; then
            if ! grep -q "@PreAuthorize" "$FILE" 2>/dev/null; then
                warn "No @PreAuthorize in $(basename $FILE)"
                warn "Endpoints rely only on .anyRequest().authenticated() — add granular permissions per method"
            else
                ok "$(basename $FILE) — @PreAuthorize present"
            fi
        fi
    fi
fi

# ── ASP.NET Core — *Controller.cs ────────────────────────────────────────────
if [[ "$FILE" =~ Controller\.cs$ ]]; then
    if grep -qE "ControllerBase|: Controller\b" "$FILE" 2>/dev/null; then
        if ! is_auth_file "$FILE"; then
            if ! grep -qE "\[AuthorizePermissions|\[Authorize\]" "$FILE" 2>/dev/null; then
                warn "No [AuthorizePermissions] in $(basename $FILE)"
                warn "Controller relies on FallbackPolicy only — add explicit permission attributes"
            else
                ok "$(basename $FILE) — [AuthorizePermissions] present"
            fi
        fi
    fi
fi

# ── Django — views.py / *views*.py ───────────────────────────────────────────
if [[ "$(basename $FILE)" == "views.py" ]] || [[ "$FILE" =~ _views?\.py$ ]]; then
    if grep -qE "class .+(APIView|ViewSet)" "$FILE" 2>/dev/null; then
        if ! grep -q "permission_classes" "$FILE" 2>/dev/null; then
            warn "No permission_classes in $(basename $FILE)"
            warn "Views rely on DEFAULT_PERMISSION_CLASSES — declare permission_classes explicitly per view"
        else
            ok "$(basename $FILE) — permission_classes present"
        fi
    fi
fi

# ── Universal — possible hardcoded secrets ───────────────────────────────────
if grep -qiE "(secret|password|api_key|private_key|token)\s*[=:]\s*['\"][^'\"]{8,}" "$FILE" 2>/dev/null; then
    warn "Possible hardcoded secret in $(basename $FILE) — use environment variables"
fi

exit 0
