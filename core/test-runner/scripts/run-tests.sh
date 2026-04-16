#!/bin/bash
# run-tests.sh — Runs tests for the detected framework
# Usage: run-tests.sh [--cov]

COVERAGE=$1

echo "=== TEST RUN ==="
echo "Path: $(pwd)"
echo ""

if ls *.csproj 2>/dev/null | grep -q "." || ls *.sln 2>/dev/null | grep -q "."; then
  echo "Framework: ASP.NET Core"
  echo "Running: dotnet test"
  dotnet test 2>&1

elif [ -f "pom.xml" ]; then
  echo "Framework: Spring Boot (Maven)"
  echo "Running: ./mvnw test"
  ./mvnw test 2>&1

elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  echo "Framework: Spring Boot (Gradle)"
  echo "Running: ./gradlew test"
  ./gradlew test 2>&1

elif [ -f "manage.py" ]; then
  echo "Framework: Django"
  echo "Running: python manage.py test"
  python manage.py test 2>&1

elif [ -f "package.json" ]; then
  if [ "$COVERAGE" = "--cov" ]; then
    echo "Running: yarn test:cov"
    yarn test:cov 2>&1
  else
    echo "Running: yarn test"
    yarn test 2>&1
  fi

else
  echo "ERROR: Unknown framework — cannot determine test command"
  exit 1
fi
