#!/bin/bash

# Script para crear un ZIP limpio del proyecto Culture Connect
# Este script excluye archivos de build y dependencias para reducir el tamaño

echo "🧹 Creando ZIP limpio del proyecto Culture Connect..."

# Nombre del archivo ZIP
PROJECT_NAME="culture_connect_clean"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ZIP_NAME="${PROJECT_NAME}_${TIMESTAMP}.zip"

# Crear el ZIP excluyendo directorios pesados
zip -r "../${ZIP_NAME}" . \
  -x "*.git/*" \
  -x "*build/*" \
  -x "*.dart_tool/*" \
  -x "*ios/build/*" \
  -x "*ios/Pods/*" \
  -x "*ios/Flutter/ephemeral/*" \
  -x "*android/.gradle/*" \
  -x "*android/.idea/*" \
  -x "*android/app/build/*" \
  -x "*android/local.properties" \
  -x "*android/key.properties" \
  -x "*.idea/*" \
  -x "*.vscode/*" \
  -x "*node_modules/*" \
  -x "*.DS_Store" \
  -x "*/.flutter-plugins-dependencies" \
  -x "*/flutter_*.log" \
  -x "*/*.iml" \
  -x "*/pubspec.lock"

if [ $? -eq 0 ]; then
    echo "✅ ZIP creado exitosamente!"
    echo "📦 Archivo: ../${ZIP_NAME}"
    
    # Mostrar el tamaño del archivo
    ZIP_SIZE=$(du -h "../${ZIP_NAME}" | cut -f1)
    echo "📊 Tamaño: ${ZIP_SIZE}"
    
    echo ""
    echo "📍 Ubicación completa:"
    echo "   $(cd .. && pwd)/${ZIP_NAME}"
else
    echo "❌ Error al crear el ZIP"
    exit 1
fi

echo ""
echo "ℹ️  El ZIP NO incluye:"
echo "   - Directorios build/"
echo "   - Dependencias (Pods, node_modules)"
echo "   - Archivos de configuración local"
echo "   - Archivos de keystore (por seguridad)"
echo ""
echo "⚠️  Para usar el proyecto, el destinatario deberá ejecutar:"
echo "   flutter pub get"
echo "   cd ios && pod install (si usa iOS)"

