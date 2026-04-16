---
name: test-runner
description: Use when running tests, asked "run the tests", "are tests passing", "run tests with coverage", "check coverage", "test this change", "did I break anything".
---

# Test Runner

**Rule:** A change that breaks existing tests is not done. Run tests after every code change, not at the end.

## Steps

1. Run tests:
   ```bash
   bash ~/.claude/skills/core/test-runner/scripts/run-tests.sh
   ```

2. For coverage report:
   ```bash
   bash ~/.claude/skills/core/test-runner/scripts/run-tests.sh --cov
   ```

3. From the output, identify:
   - **Failing tests** — fix before continuing, never skip
   - **New code with no tests** — flag it explicitly
   - **Coverage drop** — if it decreased, justify it or add tests

## After Fixing a Failure

Re-run immediately after each fix — never batch multiple fixes and run once at the end.
