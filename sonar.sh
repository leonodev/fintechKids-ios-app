#!/bin/bash
set -e

echo "========================================="
echo " 🚀 Iniciando Análisis de Calidad - FHK "
echo "========================================="

echo "🔍 [1/2] Ejecutando SwiftLint..."
swiftlint lint --reporter json > swiftlint-report.json

echo "🐳 [2/2] Lanzando Sonar Scanner (Docker)..."
docker run --rm \
  --network="host" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=FintechHomeKids \
  -Dsonar.projectName=FintechHomeKids \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://127.0.0.1:9001 \
  -Dsonar.token=sqp_104e5b6dea1c62e527a05f47ced2bee3ce9f9d3e \
  -Dsonar.lang.patterns.swift=**/*.swift

echo "========================================="
echo " 🎉 ¡Análisis completado!"
echo "========================================="
