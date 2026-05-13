# 🧩 [designsystem] Module Context: FintechHomeKids (FHK)
- Modulo en Swift Package Manager (SPM)

## 1. Role & Scope
* **Module Name:** [FHKDesignSystem]
* **Primary Responsibility:** [Responsable de exponer componentes de UI, Colores, Fuentes, Sizes y Espacios, etc.]
* **Repository Root:** `../fintechKidsModules/FHKDesignSystem`
* **Critical Paths:**
    1. - [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Components/Views]
        - Contiene todos las vistas clasificadas en subcarpetas por tipo de componente.
    2. - [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Components/Views/Modifiers]
        - Contiene los modificadores que pueden ser aplicados a las Views
    3. - [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Components/Views/UIViewRepresentable]
        - Contiene los elementos de ui que usan UIKit, que actuan como wrappers para poder usarlos en SwiftUI   
    4. [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Extensions]
        - Contiene las extensiones que pueden ser aplicadas a las Views
    5. [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Managers]
        - Contiene los manager para poder hacer uso de algunos componentes, por ejemplo, las Fuentes, Colores, Imagenes, Lotties Etc
    6. [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Resources]
        - Contiene Assets, Colores, Fuentes y Lotties en formato Json
    7. [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Sizes]
        - Contiene todas las tipologias de tamaños
    8. [../fintechKidsModules/FHKDesignSystem/Sources/FHKDesignSystem/Space]
        -  Contiene todas las tipologias de espacios



## 2. Technical Stack & Dependencies
* **Core Frameworks:** [SwiftUI, Swift 6]
* **Internal Dependencies:** [FHKUtils]
* **External SDKs:** [swift-snapshot-testing, lottie-spm, swift-algorithms]


## 3. Assigned Skills
- You must strictly enforce all the rules, interactive flows, and checklists defined in `.ai/skills/design-system/SKILL.md`.
