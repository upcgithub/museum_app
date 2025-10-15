#!/bin/bash

# Script de verificación pre-publicación para Culture Connect
# Este script verifica que todo esté listo para publicar en Play Store

echo "🔍 Culture Connect - Verificación Pre-Publicación"
echo "=================================================="
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
PASSED=0
FAILED=0
WARNINGS=0

# Función para verificar archivo
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $2"
        ((FAILED++))
        return 1
    fi
}

# Función para verificar directorio
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $2"
        ((FAILED++))
        return 1
    fi
}

# Función para verificar contenido en archivo
check_content() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $3"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $3"
        ((FAILED++))
        return 1
    fi
}

# Función para advertencia
warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

echo -e "${BLUE}📁 1. VERIFICANDO ESTRUCTURA DEL PROYECTO${NC}"
echo "----------------------------------------"
check_file "pubspec.yaml" "pubspec.yaml existe"
check_file "android/app/build.gradle" "build.gradle existe"
check_file "android/app/src/main/AndroidManifest.xml" "AndroidManifest.xml existe"
check_file "android/app/proguard-rules.pro" "proguard-rules.pro existe"
check_file "android/app/src/main/res/xml/network_security_config.xml" "network_security_config.xml existe"
echo ""

echo -e "${BLUE}📄 2. VERIFICANDO DOCUMENTACIÓN${NC}"
echo "----------------------------------------"
check_file "GOOGLE_PLAY_STORE_GUIDE.md" "Guía de Play Store existe"
check_file "PLAY_STORE_ASSETS.md" "Guía de assets existe"
check_file "PRIVACY_POLICY.md" "Política de privacidad existe"
check_file "TERMS_OF_SERVICE.md" "Términos de servicio existe"
check_file "RELEASE_CHECKLIST.md" "Checklist de release existe"
echo ""

echo -e "${BLUE}🔐 3. VERIFICANDO CONFIGURACIÓN DE FIRMA${NC}"
echo "----------------------------------------"
if [ -f "android/key.properties" ]; then
    echo -e "${GREEN}✓${NC} key.properties existe"
    ((PASSED++))
    
    # Verificar contenido de key.properties
    if grep -q "storePassword" android/key.properties; then
        echo -e "${GREEN}✓${NC} storePassword configurado"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} storePassword NO configurado"
        ((FAILED++))
    fi
    
    if grep -q "keyPassword" android/key.properties; then
        echo -e "${GREEN}✓${NC} keyPassword configurado"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} keyPassword NO configurado"
        ((FAILED++))
    fi
    
    if grep -q "keyAlias" android/key.properties; then
        echo -e "${GREEN}✓${NC} keyAlias configurado"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} keyAlias NO configurado"
        ((FAILED++))
    fi
    
    if grep -q "storeFile" android/key.properties; then
        echo -e "${GREEN}✓${NC} storeFile configurado"
        ((PASSED++))
        
        # Verificar que el keystore existe
        KEYSTORE_PATH=$(grep "storeFile" android/key.properties | cut -d'=' -f2)
        if [ -f "$KEYSTORE_PATH" ]; then
            echo -e "${GREEN}✓${NC} Keystore existe en la ubicación especificada"
            ((PASSED++))
        else
            echo -e "${RED}✗${NC} Keystore NO existe en: $KEYSTORE_PATH"
            ((FAILED++))
        fi
    else
        echo -e "${RED}✗${NC} storeFile NO configurado"
        ((FAILED++))
    fi
else
    echo -e "${RED}✗${NC} key.properties NO existe"
    echo -e "${YELLOW}   → Crea este archivo siguiendo GOOGLE_PLAY_STORE_GUIDE.md${NC}"
    ((FAILED++))
fi
echo ""

echo -e "${BLUE}⚙️  4. VERIFICANDO CONFIGURACIÓN DE ANDROID${NC}"
echo "----------------------------------------"
check_content "android/app/build.gradle" "com.museumapp.cultureconnect" "Application ID actualizado"
check_content "android/app/build.gradle" "minSdk = 21" "minSdk configurado (21)"
check_content "android/app/build.gradle" "targetSdk = 34" "targetSdk configurado (34)"
check_content "android/app/build.gradle" "signingConfigs.release" "Configuración de firma presente"
check_content "android/app/build.gradle" "minifyEnabled true" "Minificación habilitada"
check_content "android/app/build.gradle" "shrinkResources true" "Reducción de recursos habilitada"
echo ""

echo -e "${BLUE}📱 5. VERIFICANDO ANDROIDMANIFEST${NC}"
echo "----------------------------------------"
check_content "android/app/src/main/AndroidManifest.xml" "Culture Connect" "Nombre de la app configurado"
check_content "android/app/src/main/AndroidManifest.xml" "android.permission.INTERNET" "Permiso INTERNET"
check_content "android/app/src/main/AndroidManifest.xml" "android.permission.CAMERA" "Permiso CAMERA"
check_content "android/app/src/main/AndroidManifest.xml" "android.hardware.camera" "Feature CAMERA declarado"
echo ""

echo -e "${BLUE}📦 6. VERIFICANDO DEPENDENCIAS${NC}"
echo "----------------------------------------"
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✓${NC} Flutter instalado"
    ((PASSED++))
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "   $FLUTTER_VERSION"
else
    echo -e "${RED}✗${NC} Flutter NO instalado"
    ((FAILED++))
fi

# Verificar pub get
if [ -d ".dart_tool" ]; then
    echo -e "${GREEN}✓${NC} Dependencias descargadas"
    ((PASSED++))
else
    warn "Dependencias no descargadas - ejecuta: flutter pub get"
fi
echo ""

echo -e "${BLUE}🏗️  7. VERIFICANDO BUILDS ANTERIORES${NC}"
echo "----------------------------------------"
if [ -d "build" ]; then
    echo -e "${YELLOW}⚠${NC} Directorio build existe"
    warn "Se recomienda ejecutar 'flutter clean' antes del build final"
    
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        AAB_SIZE=$(ls -lh build/app/outputs/bundle/release/app-release.aab | awk '{print $5}')
        echo -e "${GREEN}✓${NC} App Bundle anterior existe (tamaño: $AAB_SIZE)"
        ((PASSED++))
    fi
else
    echo -e "${YELLOW}⚠${NC} No hay builds anteriores"
    ((WARNINGS++))
fi
echo ""

echo -e "${BLUE}🎨 8. VERIFICANDO ASSETS${NC}"
echo "----------------------------------------"
check_dir "assets" "Directorio assets existe"
check_file "assets/logo.png" "Logo existe"
check_dir "assets/audio" "Directorio audio existe"
check_dir "assets/data" "Directorio data existe"
check_dir "assets/fonts" "Directorio fonts existe"
echo ""

echo -e "${BLUE}📝 9. VERIFICANDO VERSIÓN${NC}"
echo "----------------------------------------"
if [ -f "pubspec.yaml" ]; then
    VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
    if [ ! -z "$VERSION" ]; then
        echo -e "${GREEN}✓${NC} Versión actual: $VERSION"
        ((PASSED++))
        
        # Extraer versionCode y versionName
        VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
        VERSION_CODE=$(echo $VERSION | cut -d'+' -f2)
        echo "   versionName: $VERSION_NAME"
        echo "   versionCode: $VERSION_CODE"
    else
        echo -e "${RED}✗${NC} Versión no encontrada en pubspec.yaml"
        ((FAILED++))
    fi
fi
echo ""

echo -e "${BLUE}🔒 10. VERIFICANDO SEGURIDAD${NC}"
echo "----------------------------------------"

# Verificar que key.properties no está en git
if grep -q "key.properties" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✓${NC} key.properties está en .gitignore"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} key.properties NO está en .gitignore"
    echo -e "${YELLOW}   → ¡PELIGRO! Añade android/key.properties a .gitignore${NC}"
    ((FAILED++))
fi

# Verificar que .jks no está en git
if grep -q "\.jks" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Archivos .jks están en .gitignore"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Archivos .jks NO están en .gitignore"
    ((FAILED++))
fi

# Verificar que .env está en .gitignore
if grep -q "\.env" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✓${NC} .env está en .gitignore"
    ((PASSED++))
else
    warn ".env debería estar en .gitignore"
fi
echo ""

echo "=================================================="
echo -e "${BLUE}📊 RESUMEN${NC}"
echo "=================================================="
echo -e "${GREEN}✓ Verificaciones pasadas:${NC} $PASSED"
echo -e "${RED}✗ Verificaciones fallidas:${NC} $FAILED"
echo -e "${YELLOW}⚠ Advertencias:${NC} $WARNINGS"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡TODO LISTO PARA PUBLICAR!${NC}"
    echo ""
    echo "Próximos pasos:"
    echo "1. Ejecuta: flutter clean"
    echo "2. Ejecuta: flutter pub get"
    echo "3. Ejecuta: flutter build appbundle --release"
    echo "4. Sube el AAB a Google Play Console"
    echo ""
    echo "Ver guía completa en: GOOGLE_PLAY_STORE_GUIDE.md"
    exit 0
else
    echo -e "${RED}❌ HAY PROBLEMAS QUE RESOLVER${NC}"
    echo ""
    echo "Por favor, corrige los errores marcados arriba."
    echo "Consulta GOOGLE_PLAY_STORE_GUIDE.md para más información."
    exit 1
fi

