#!/bin/bash

echo "🚀 Limpiando sesiones previas de automatización..."
rm -f report.html # Limpiamos el reporte anterior si existe

echo "🧹 Desinstalando aplicación previa para limpiar entorno..."
xcrun simctl uninstall booted com.fleon.fintechKids 2>/dev/null

echo "🔍 Localizando el archivo .app compilado más reciente..."
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fintechKids.app" -path "*/Build/Products/*-iphonesimulator/fintechKids.app" ! -path "*/Index.noindex/*" -type d 2>/dev/null | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Error: No se encontró ningún build de la app. Asegúrate de compilar el proyecto en Xcode para simulador al menos una vez."
    exit 1
fi

echo "📦 App encontrada en: $APP_PATH"
echo "📥 Instalando versión limpia de la app en el simulador..."
xcrun simctl install booted "$APP_PATH"

echo "⏳ Esperando a que el sistema operativo registre la app..."
sleep 3

echo "⚙️ Configurando entorno..."
export MAESTRO_DRIVER_STARTUP_TIMEOUT=300000

echo "🛢️ Limpiando usuario de pruebas en Supabase..."
SUPABASE_URL="https://chaukyiczbxkkbnxgahi.supabase.co"
SUPABASE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoYXVreWljemJ4a2tibnhnYWhpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTIwNTUyNywiZXhwIjoyMDgwNzgxNTI3fQ.NerDcVdOObC2okmQczez66zWDtjsODyF2qlwO9-s17Q"

# Borramos de la tabla 'members' el registro donde el nombre sea 'Mateo' (o usa el email/id)
curl -s -X DELETE "${SUPABASE_URL}/rest/v1/fhk_family_members?member_name=eq.user1" \
  -H "apikey: ${SUPABASE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_KEY}"

 

echo "🏃 Ejecutando pruebas de Maestro en orden estricto..."
maestro test --format html-detailed --output report.html \
  .maestro/flows/select-language.yaml \
  .maestro/flows/make-login.yaml \
  .maestro/flows/create-new-member.yaml

echo "📊 Abriendo el reporte detallado en tu navegador..." 
if [ -f report.html ]; then
    echo "✅ ¡Proceso terminado exitosamente!"
    
    # Abre automáticamente el reporte en Chrome/Safari sin pausar la terminal
    open report.html
else
    echo "❌ No se pudo generar el HTML porque el archivo report.html no se creó."
fi