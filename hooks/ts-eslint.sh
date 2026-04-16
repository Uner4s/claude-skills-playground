#!/bin/bash
# Hook: PostToolUse — ESLint on edited TypeScript file
#
# Runs ESLint on the specific file that Claude just edited.
# Only activates in TypeScript projects (tsconfig.json must exist).
# Triggered after: Edit, Write, MultiEdit

# Read the JSON payload that Claude Code sends via stdin
INPUT=$(cat)

# Extract the file path from the tool input
FILE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Skip if no file path found
[ -z "$FILE" ] && exit 0

# Skip if not a TypeScript or TSX file
[[ "$FILE" =~ \.(ts|tsx)$ ]] || exit 0

# Skip if not a TypeScript project
[ -f "tsconfig.json" ] || exit 0

echo "▸ eslint $(basename "$FILE")"
npx eslint "$FILE" --max-warnings=0 2>&1 || true
