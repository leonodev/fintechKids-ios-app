---
name: TestingAgent
description: >
  Debes generar un .Ipa de iOS para posteriormente usarlo con MobSF para pruebas de PenTestig y encontrar posibles vulnerabilidades.
  Este agente controla de forma autónoma las rutas y carpetas fijas del proyecto, incluyendo `build/`, `build/export/`, el proyecto `fintechKids.xcodeproj`, y `ExportOptions.plist`.
  model: gemini-3-flash
---


## Plan de acciones

## Nota de rutas fijas controladas
Las rutas y carpetas fijas que maneja este agente son:
- `./build/`
- `./build/export/`
- `./fintechKids.xcodeproj`
- `./ExportOptions.plist`

No se solicitará confirmación paso a paso para operaciones dentro de estas rutas. El agente debe ejecutar el flujo completo automáticamente y puede ajustar rutas o archivos fijos según sea necesario.

## 1. Cambiar al schema de FintechKids-Dev
xcodebuild archive \
  -scheme "FintechKids-Dev" \
  -destination 'generic/platform=iOS' \
  -archivePath "./build/FintechKids.xcarchive"

## 2. Limpiar el entorno para evitar errores de caché
echo "Limpiando el proyecto..."
xcodebuild clean -scheme "FintechKids-Dev"


## 3. Archivar el proyecto (equivalente a Product > Archive)
echo "Iniciando proceso de archivado..."
xcodebuild archive \
  -scheme "FintechKids-Dev" \
  -destination 'generic/platform=iOS' \
  -archivePath "./build/FintechKids.xcarchive"

## 4. Verificar si el archivo se creó correctamente
if [ -d "./build/FintechKids.xcarchive" ]; then
  echo "¡Archivo generado exitosamente!"
else
  echo "Error: No se pudo generar el archivo."
  exit 1
fi

## 5. Exportar archivo .ipa para MobSF
xcodebuild -exportArchive \
  -archivePath "./build/FintechKids.xcarchive" \
  -exportPath "./build/export" \
  -exportOptionsPlist "ExportOptions.plist"


## Output Checklist taks.
- [ ] cambiar de schema y platform
- [ ] Limpiar el entorno
- [ ] Archive del proyecto
- [ ] Verificar archive creado
- [ ] Exportar archivo .ipa