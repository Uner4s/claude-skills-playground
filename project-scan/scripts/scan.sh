#!/bin/bash
# scan.sh — Project structure scanner
# Supports: NestJS, Next.js, Express, React Native, Spring Boot, Django, ASP.NET Core

echo "=== PROJECT SCAN ==="
echo "Path: $(pwd)"
echo ""

# --- Stack Detection ---
echo "## Stack"
if ls *.csproj 2>/dev/null | grep -q "." || ls *.sln 2>/dev/null | grep -q "."; then
  echo "Framework: ASP.NET Core"
  echo "Runtime: .NET"
elif [ -f "pom.xml" ]; then
  echo "Framework: Spring Boot (Maven)"
  echo "Runtime: Java"
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  echo "Framework: Spring Boot (Gradle)"
  echo "Runtime: Java / Kotlin"
elif [ -f "manage.py" ]; then
  echo "Framework: Django"
  echo "Runtime: Python"
elif [ -f "package.json" ]; then
  if grep -q '"@nestjs/core"' package.json 2>/dev/null; then
    echo "Framework: NestJS"
  elif grep -q '"next"' package.json 2>/dev/null; then
    echo "Framework: Next.js"
  elif grep -q '"react-native"' package.json 2>/dev/null; then
    echo "Framework: React Native"
  elif grep -q '"express"' package.json 2>/dev/null; then
    echo "Framework: Express"
  else
    echo "Framework: Node.js"
  fi
  NODE_VERSION=$(node --version 2>/dev/null || echo "unknown")
  echo "Runtime: Node.js $NODE_VERSION"
else
  echo "Framework: Unknown"
fi
echo ""

# --- Source Structure ---
echo "## Source Structure"
if [ -d "src/main/java" ]; then
  find src/main/java -maxdepth 5 -type d | sed 's|src/main/java/||' | grep -v "^$" | head -30
elif [ -d "src" ]; then
  find src -maxdepth 3 -type d | sed 's|src/||' | grep -v "^$" | head -30
elif [ -d "app" ]; then
  find app -maxdepth 3 -type d | sed 's|app/||' | grep -v "^$" | head -20
else
  echo "No standard src/ or app/ found — top-level directories:"
  find . -maxdepth 1 -type d | grep -v "^\.$" | grep -v "node_modules\|\.git\|\.next\|dist\|build\|target" | sed 's|./||' | sort
fi
echo ""

# --- Key Config Files ---
echo "## Config Files"
for f in \
  package.json pom.xml build.gradle build.gradle.kts \
  tsconfig.json .env.example docker-compose.yml Dockerfile \
  prisma/schema.prisma application.yml application.properties \
  settings.py requirements.txt; do
  [ -f "$f" ] && echo "  - $f"
done
echo ""

# --- Test Structure ---
echo "## Tests"
FOUND_TESTS=false
for d in src/test test __tests__ spec; do
  if [ -d "$d" ]; then
    echo "Test dir: $d"
    find "$d" -maxdepth 3 -type d | head -10
    FOUND_TESTS=true
    break
  fi
done
$FOUND_TESTS || echo "No test directory found"
