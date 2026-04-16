---
name: security-audit
description: Use before deploying to staging or production. Use when asked "security audit", "is this safe to deploy", "check security before deploy", "pre-deploy checklist", "audit the api security", "review security".
---

# Security Audit

**Rule:** A `✗ FAIL` is a blocker — do not deploy. A `⚠ WARN` is a conversation — review and decide.

## Steps

1. Run the automated audit:
   ```bash
   bash ~/.claude/skills/core/security-audit/scripts/audit.sh
   ```

2. Fix every `✗ FAIL` before continuing — no exceptions

3. Review each `⚠ WARN` manually — decide if acceptable for this specific deploy

4. Manual checklist (cannot be automated):
   - [ ] All public endpoints are intentional and documented
   - [ ] JWT secret is strong (32+ random chars, not a word or phrase)
   - [ ] CORS origins match actual frontend URLs for this environment
   - [ ] Rate limiting thresholds make sense for expected traffic volume
   - [ ] No sensitive data written to logs (passwords, full tokens, PII)

5. Re-run after fixing to confirm clean pass before deploying
