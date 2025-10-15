#!/bin/bash

# Script para generar el build de producción de Culture Connect
# Autor: Hans
# Fecha: $(date +%Y-%m-%d)

echo "🚀 Culture Connect - Build de Producción"
echo "========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: No se encontró pubspec.yaml${NC}"
    echo "Asegúrate de ejecutar este script desde la raíz del proyecto"
    exit 1
fi

echo -e "${YELLOW}📋 Paso 1: Limpiando proyecto...${NC}"
flutter clean
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al limpiar el proyecto${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Limpieza completada${NC}"
echo ""

echo -e "${YELLOW}📦 Paso 2: Obteniendo dependencias...${NC}"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al obtener dependencias${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Dependencias obtenidas${NC}"
echo ""

echo -e "${YELLOW}🔍 Paso 3: Verificando configuración...${NC}"
# Verificar que existe key.properties
if [ ! -f "android/key.properties" ]; then
    echo -e "${RED}❌ Error: No se encontró android/key.properties${NC}"
    echo "Por favor, crea este archivo siguiendo la guía en GOOGLE_PLAY_STORE_GUIDE.md"
    exit 1
fi
echo -e "${GREEN}✓ key.properties encontrado${NC}"
echo ""

echo -e "${YELLOW}🏗️  Paso 4: Generando App Bundle (.aab)...${NC}"
echo "Esto puede tomar varios minutos..."
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al generar el App Bundle${NC}"
    exit 1
fi
echo -e "${GREEN}✓ App Bundle generado exitosamente${NC}"
echo ""

# Obtener tamaño del archivo
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB_PATH" ]; then
    SIZE=$(ls -lh "$AAB_PATH" | awk '{print $5}')
    echo -e "${GREEN}📊 Tamaño del App Bundle: $SIZE${NC}"
    echo ""
    
    echo -e "${GREEN}✅ ¡Build completado exitosamente!${NC}"
    echo ""
    echo "📂 Archivo generado:"
    echo "   $AAB_PATH"
    echo ""
    echo "📋 Próximos pasos:"
    echo "   1. Ve a Google Play Console: https://play.google.com/console"
    echo "   2. Selecciona tu aplicación"
    echo "   3. Ve a Producción → Versiones"
    echo "   4. Sube el archivo app-release.aab"
    echo ""
    echo "💡 Consulta la guía completa en: GOOGLE_PLAY_STORE_GUIDE.md"
else
    echo -e "${RED}❌ Error: No se pudo encontrar el App Bundle generado${NC}"
    exit 1
fi

