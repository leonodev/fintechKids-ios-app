#!/bin/bash

# Console Colors
GREEN='\033[0;32m'
ORANGE='\033[38;5;208m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo " 🛠️ Tuist File Generator"
echo "=========================================="

# Root folder name (e.g., tuistdemo)
ROOT_APP_NAME=$(basename "$PWD")

# Extract all quote-enclosed strings near product/package definitions in Project.swift
EXCLUDED_DEPS=""
if [ -f "Project.swift" ]; then
    EXCLUDED_DEPS=$(grep -iE 'product:|package\(' Project.swift | grep -oE '"[^"]+"' | tr -d '"')
fi

# 1. Read local modules from Targets/ (including Main App)
MODULES=()
MAIN_APP_NAME=""

if [ -d "Targets" ]; then
    for dir in Targets/*/; do
        if [ -d "$dir" ]; then
            mod_name=$(basename "$dir")
            mod_lower=$(echo "$mod_name" | tr '[:upper:]' '[:lower:]')

            # Rule A: Detect Main App target (e.g., tuistdemo or names ending in demo/app)
            if [ "$mod_lower" == "$(echo "$ROOT_APP_NAME" | tr '[:upper:]' '[:lower:]')" ] || [[ "$mod_lower" =~ (demo|app)$ ]]; then
                MAIN_APP_NAME="$mod_name"
                continue
            fi

            # Rule B: Ignore SPM/Remote dependencies starting with FHK / fhk
            if [[ "$mod_lower" =~ ^fhk ]]; then
                continue
            fi

            # Rule C: Ignore if explicitly declared in dependencies inside Project.swift
            if echo "$EXCLUDED_DEPS" | grep -qxi "$mod_name"; then
                continue
            fi

            # Rule D: Ignore if directory contains Package.swift or .git
            if [ -f "$dir/Package.swift" ] || [ -d "$dir/.git" ]; then
                continue
            fi

            MODULES+=("$mod_name")
        fi
    done
fi

# Build list of selectable targets (Main App first)
TARGET_MODULES=()
DISPLAY_NAMES=()

if [ -n "$MAIN_APP_NAME" ]; then
    TARGET_MODULES+=("$MAIN_APP_NAME")
    DISPLAY_NAMES+=("$MAIN_APP_NAME (Main App 🚀)")
elif [ -d "Targets/$ROOT_APP_NAME" ]; then
    MAIN_APP_NAME="$ROOT_APP_NAME"
    TARGET_MODULES+=("$ROOT_APP_NAME")
    DISPLAY_NAMES+=("$ROOT_APP_NAME (Main App 🚀)")
fi

for mod in "${MODULES[@]}"; do
    TARGET_MODULES+=("$mod")
    DISPLAY_NAMES+=("$mod")
done

echo "1. Select the Target / Local Module:"
index=1
for display in "${DISPLAY_NAMES[@]}"; do
    echo "   $index. $display"
    ((index++))
done
echo "   $index. ➕ Create new module"

echo ""
read -p "   Select an option (1-$index): " MOD_CHOICE

# Validate option
if ! [[ "$MOD_CHOICE" =~ ^[0-9]+$ ]] || [ "$MOD_CHOICE" -lt 1 ] || [ "$MOD_CHOICE" -gt "$index" ]; then
    echo -e "${RED}❌ Invalid option.${NC}"
    exit 1
fi

if [ "$MOD_CHOICE" -eq "$index" ]; then
    # Option "Create new module"
    echo ""
    read -p "   New module name (e.g., ProfileFeature): " FEATURE_NAME
    if [ -z "$FEATURE_NAME" ]; then
        echo -e "${RED}❌ Module name cannot be empty.${NC}"
        exit 1
    fi
    FEATURE_PATH="Targets/$FEATURE_NAME"
    mkdir -p "$FEATURE_PATH"
    echo -e "${GREEN}📁 Module '$FEATURE_NAME' created in Targets/${NC}"
else
    # Selection of existing module
    FEATURE_NAME="${TARGET_MODULES[$((MOD_CHOICE-1))]}"
    FEATURE_PATH="Targets/$FEATURE_NAME"
fi

# Identifica si el módulo seleccionado es la Main App
IS_MAIN_APP=false
if [ "$FEATURE_NAME" == "$MAIN_APP_NAME" ]; then
    IS_MAIN_APP=true
fi

# 🛠️ PARCHE TUIST: Garantiza la estructura base de carpetas
mkdir -p "$FEATURE_PATH/Sources"
mkdir -p "$FEATURE_PATH/Tests"

if [ -z "$(ls -A "$FEATURE_PATH/Sources" 2>/dev/null)" ]; then
    touch "$FEATURE_PATH/Sources/.gitkeep"
fi

if [ -z "$(ls -A "$FEATURE_PATH/Tests" 2>/dev/null)" ]; then
    touch "$FEATURE_PATH/Tests/.gitkeep"
fi

if [ "$IS_MAIN_APP" = false ]; then
    mkdir -p "$FEATURE_PATH/Example/Sources"
    mkdir -p "$FEATURE_PATH/Testing/Sources"

    if [ -z "$(ls -A "$FEATURE_PATH/Example/Sources" 2>/dev/null)" ]; then
        touch "$FEATURE_PATH/Example/Sources/.gitkeep"
    fi

    if [ -z "$(ls -A "$FEATURE_PATH/Testing/Sources" 2>/dev/null)" ]; then
        touch "$FEATURE_PATH/Testing/Sources/.gitkeep"
    fi
fi

# 2. Menú Adaptativo de Destino Entorno
echo ""
echo "2. Where do you want to create the file in '$FEATURE_NAME'?"

if [ "$IS_MAIN_APP" = true ]; then
    echo "   1. Main App Code (Production)"
    echo "   2. Unit Tests 🧪"
    read -p "   Select an option (1 or 2): " MAIN_OPTION
    
    case "$MAIN_OPTION" in
        1) OPTION="1" ;;
        2) OPTION="3" ;;
        *) echo -e "${RED}❌ Invalid option.${NC}"; exit 1 ;;
    esac
else
    echo "   1. Production"
    echo "   2. Example"
    echo "   3. Unit Tests 🧪"
    echo "   4. Testing / Mocks 🛠️"
    read -p "   Select an option (1, 2, 3 or 4): " OPTION
fi

# Determine base directory
if [ "$OPTION" == "1" ]; then
    BASE_DIR="$FEATURE_PATH/Sources"
elif [ "$OPTION" == "2" ]; then
    BASE_DIR="$FEATURE_PATH/Example/Sources"
elif [ "$OPTION" == "3" ]; then
    BASE_DIR="$FEATURE_PATH/Tests"
elif [ "$OPTION" == "4" ]; then
    BASE_DIR="$FEATURE_PATH/Testing/Sources"
else
    echo -e "${RED}❌ Invalid option.${NC}"
    exit 1
fi

# 3. 📂 NUEVO PASO: Seleccionar o crear subdirectorio específico (ej. Resources, Views, etc.)
echo ""
echo "3. Select destination folder inside '$FEATURE_NAME':"

SUBDIRS=("$BASE_DIR")

# Buscar subcarpetas existentes dentro del BASE_DIR
if [ -d "$BASE_DIR" ]; then
    while IFS= read -r d; do
        [ -n "$d" ] && SUBDIRS+=("$d")
    done < <(find "$BASE_DIR" -mindepth 1 -type d ! -path '*/.*' 2>/dev/null | sort)
fi

# Si existe la carpeta Resources a nivel de módulo, incluirla también en las opciones
if [ -d "$FEATURE_PATH/Resources" ]; then
    while IFS= read -r d; do
        if [[ ! " ${SUBDIRS[*]} " =~ " ${d} " ]]; then
            SUBDIRS+=("$d")
        fi
    done < <(find "$FEATURE_PATH/Resources" -type d ! -path '*/.*' 2>/dev/null | sort)
fi

dir_index=1
for d in "${SUBDIRS[@]}"; do
    rel_path="${d#$FEATURE_PATH/}"
    echo "   $dir_index. $rel_path/"
    ((dir_index++))
done
echo "   $dir_index. ➕ Create / Specify new folder (e.g., Resources, Views/Home)"

echo ""
read -p "   Select folder option (1-$dir_index): " DIR_CHOICE

if ! [[ "$DIR_CHOICE" =~ ^[0-9]+$ ]] || [ "$DIR_CHOICE" -lt 1 ] || [ "$DIR_CHOICE" -gt "$dir_index" ]; then
    echo -e "${RED}❌ Invalid option.${NC}"
    exit 1
fi

if [ "$DIR_CHOICE" -eq "$dir_index" ]; then
    echo ""
    read -p "   Enter new folder path relative to $FEATURE_NAME/ (e.g., Resources, Views/Detail): " NEW_FOLDER_NAME
    if [ -z "$NEW_FOLDER_NAME" ]; then
        echo -e "${RED}❌ Folder name cannot be empty.${NC}"
        exit 1
    fi
    
    # Limpiar barras iniciales
    NEW_FOLDER_NAME=$(echo "$NEW_FOLDER_NAME" | sed 's/^\///')

    # Si el usuario escribe 'Resources' o 'Resources/...', crearlo en la raíz del target
    if [[ "$NEW_FOLDER_NAME" =~ ^Resources(/|$) ]]; then
        TARGET_DIR="$FEATURE_PATH/$NEW_FOLDER_NAME"
    else
        # Si escribe otra cosa (ej. Views/Detail), crearlo dentro de BASE_DIR
        TARGET_DIR="$BASE_DIR/$NEW_FOLDER_NAME"
    fi
else
    TARGET_DIR="${SUBDIRS[$((DIR_CHOICE-1))]}"
fi

# Crear el directorio destino si no existe
mkdir -p "$TARGET_DIR"

# 4. Ask for file name
echo ""
if [ "$OPTION" == "3" ]; then
    read -p "4. Name of the Test file (e.g., ${FEATURE_NAME}Tests): " FILE_NAME
elif [ "$OPTION" == "4" ]; then
    read -p "4. Name of the Mock file (e.g., Mock${FEATURE_NAME}Repository): " FILE_NAME
else
    read -p "4. Name of the file/asset (e.g., DetailView, Localizable.strings, Config.json): " FILE_NAME
fi

if [ -z "$FILE_NAME" ]; then
    echo -e "${RED}❌ File name cannot be empty.${NC}"
    exit 1
fi

# Si el archivo no tiene extensión (no tiene punto), añadir .swift por defecto
if [[ "$FILE_NAME" != *.* ]]; then
    FILE_NAME="${FILE_NAME}.swift"
fi

CLASS_NAME="${FILE_NAME%.*}"
FILE_PATH="$TARGET_DIR/$FILE_NAME"

# Check if file already exists and prompt to replace
if [ -f "$FILE_PATH" ]; then
    echo -e "${ORANGE}⚠️ The file '$FILE_NAME' already exists in $TARGET_DIR.${NC}"
    read -p "   Do you want to replace it? (y/n): " OVERWRITE_CONFIRM
    if [[ ! "$OVERWRITE_CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Operation canceled."
        exit 0
    fi
    echo -e "${ORANGE}🔄 Replacing existing file...${NC}"
fi

# 🗓️ Calculate current date
CURRENT_DATE=$(date +"%-d/%-m/%y" 2>/dev/null || date +"%d/%m/%y")

# 📄 Write header and content based on target type and extension
if [[ "$FILE_NAME" == *.swift ]]; then
    if [ "$OPTION" == "1" ]; then
cat << EOF > "$FILE_PATH"
//
//  $FILE_NAME
//  $FEATURE_NAME
//
//  Created on $CURRENT_DATE.
//

import SwiftUI
EOF
    elif [ "$OPTION" == "2" ]; then
cat << EOF > "$FILE_PATH"
//
//  $FILE_NAME
//  $FEATURE_NAME
//
//  Created on $CURRENT_DATE.
//

import SwiftUI
import ${FEATURE_NAME}
EOF
    elif [ "$OPTION" == "3" ]; then
cat << EOF > "$FILE_PATH"
//
//  $FILE_NAME
//  $FEATURE_NAME Tests
//
//  Created on $CURRENT_DATE.
//

import XCTest
@testable import ${FEATURE_NAME}

final class ${CLASS_NAME}: XCTestCase {

    override func setUpWithError() throws {
        // Setup state before each test method
    }

    override func tearDownWithError() throws {
        // Clean up state after each test method
    }

    func testExample() throws {
        // Given
        
        // When
        
        // Then
        XCTAssertTrue(true)
    }
}
EOF
    elif [ "$OPTION" == "4" ]; then
cat << EOF > "$FILE_PATH"
//
//  $FILE_NAME
//  $FEATURE_NAME Testing / Mocks
//
//  Created on $CURRENT_DATE.
//

import Foundation
import ${FEATURE_NAME}

public struct ${CLASS_NAME} {
    public init() {}
    
    // TODO: Add your public mocks or fake data here
}
EOF
    fi
else
    # Archivos que no son Swift (ej: .json, .strings, .plist)
    touch "$FILE_PATH"
fi

echo -e "${GREEN}📄 File '$FILE_NAME' saved successfully in $TARGET_DIR${NC}"

# 🔍 INTERACTIVE VALIDATION IN Project.swift (ORANGE ALERT)
if [ -f "Project.swift" ] && [ "$IS_MAIN_APP" = false ]; then
    if [ "$OPTION" == "1" ] || [ "$OPTION" == "3" ]; then
        IS_PROD_REGISTERED=$(grep -E "name:\s*\"$FEATURE_NAME\"" Project.swift)
        if [ -z "$IS_PROD_REGISTERED" ]; then
            echo ""
            echo -e "${ORANGE}⚠️ ATTENTION: The module '$FEATURE_NAME' is NOT registered in your Project.swift.${NC}"
            echo -e "   Please open your ${ORANGE}Project.swift${NC} and add the module definition."
            echo ""
            read -p "👉 Add the line in Project.swift, save the file, and press [ENTER] to continue... " USER_PAUSE
            echo ""
        fi
    elif [ "$OPTION" == "2" ]; then
        IS_EX_REGISTERED=$(grep -E "\.moduleExample\(for:\s*\"$FEATURE_NAME\"\)|\.featureModule\(name:\s*\"$FEATURE_NAME\"\)" Project.swift)
        if [ -z "$IS_EX_REGISTERED" ]; then
            echo ""
            echo -e "${ORANGE}⚠️ ATTENTION: The Example target for '$FEATURE_NAME' is NOT in your Project.swift.${NC}"
            echo -e "   Please open your ${ORANGE}Project.swift${NC} and add the following line:"
            echo -e "   ${ORANGE}.moduleExample(for: \"$FEATURE_NAME\"),${NC}"
            echo ""
            read -p "👉 Add the line in Project.swift, save the file, and press [ENTER] to continue... " USER_PAUSE
            echo ""
        fi
    elif [ "$OPTION" == "4" ]; then
        IS_TESTING_REGISTERED=$(grep -E "\.moduleTesting\(for:\s*\"$FEATURE_NAME\"\)" Project.swift)
        if [ -z "$IS_TESTING_REGISTERED" ]; then
            echo ""
            echo -e "${ORANGE}⚠️ ATTENTION: The Testing target for '$FEATURE_NAME' is NOT in your Project.swift.${NC}"
            echo -e "   Please open your ${ORANGE}Project.swift${NC} and add the following line:"
            echo -e "   ${ORANGE}.moduleTesting(for: \"$FEATURE_NAME\"),${NC}"
            echo ""
            read -p "👉 Add the line in Project.swift, save the file, and press [ENTER] to continue... " USER_PAUSE
            echo ""
        fi
    fi
fi

# Run Tuist Generate
echo "🔄 Regenerating project with Tuist..."
tuist generate

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Everything went well! The file was processed and Tuist executed successfully.${NC}"
else
    echo -e "${RED}❌ Failed to run 'tuist generate'.${NC}"
fi