#!/bin/bash
# Hook: Stop — tsc --noEmit on the full project
#
# Runs a full TypeScript type check when Claude finishes its task.
# Only activates in TypeScript projects (tsconfig.json must exist).
# Triggered once when Claude stops, not on every file edit.

# Skip if not a TypeScript project
[ -f "tsconfig.json" ] || exit 0

echo "▸ tsc --noEmit"
npx tsc --noEmit 2>&1 || true
